import 'dart:async';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:size_matter_swt/common/custom_button.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/features/home/presentation/widgets/home_controller.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/helpers_method.dart';
import 'package:size_matter_swt/helpers/toast.dart';
import 'package:size_matter_swt/networks/api_access.dart';

class MapNavigationManager {
  final GoogleMapController? Function() getMapController;
  final void Function(VoidCallback) refresh;
  final BuildContext Function() getContext;
  final String googleApiKey;

  MapNavigationManager({
    required this.getMapController,
    required this.refresh,
    required this.getContext,
    required this.googleApiKey,
  });

  final Set<Polyline> polylines = {};
  bool isRouteFetching = false;
  List<LatLng> _remainingPoints = [];
  LatLng? _destination;
  String? activeDestinationId;
  String? activeDestinationType;
  bool isNavigating = false;
  bool isProgrammaticMove = false;
  bool _arrivalDialogShown = false;
  StreamSubscription<Position>? _locationStream;

  final _remainingDistanceController = StreamController<double>.broadcast();
  Stream<double> get remainingDistanceStream =>
      _remainingDistanceController.stream;

  static const double _arrivalRadiusMeters = 30.0;

  void dispose() {
    stopNavigation(notifyUi: false);
    _remainingDistanceController.close();
  }

  Future<void> startNavigation(
    LatLng destination,
    String itemId,
    String apiType,
    Position? currentPos,
  ) async {
    stopNavigation();
    refresh(() => isRouteFetching = true);
    try {
      Position position =
          currentPos ??
          await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
            ),
          );

      _destination = destination;
      activeDestinationId = itemId;
      activeDestinationType = apiType;
      final origin = LatLng(position.latitude, position.longitude);

      await _fetchAndDrawRoute(origin, destination);
      _startLocationTracking();

      homeController.isNavigating.value = true;
      homeController.isAutoCentering.value = true;
    } catch (e) {
      debugPrint("Navigation Error: $e");
      ScaffoldMessenger.of(
        getContext(),
      ).showSnackBar(const SnackBar(content: Text("Could not find route.")));
    } finally {
      refresh(() => isRouteFetching = false);
    }
  }

  Future<void> _fetchAndDrawRoute(LatLng origin, LatLng destination) async {
    final dio = Dio();
    final url =
        "https://maps.googleapis.com/maps/api/directions/json"
        "?origin=${origin.latitude},${origin.longitude}"
        "&destination=${destination.latitude},${destination.longitude}"
        "&mode=walking"
        "&alternatives=false"
        "&key=$googleApiKey";

    final response = await dio.get(url);

    if (response.statusCode == 200 && response.data['status'] == 'OK') {
      final List<LatLng> points = [];
      final legs = response.data['routes'][0]['legs'] as List;
      for (var leg in legs) {
        for (var step in (leg['steps'] as List)) {
          final decoded = PolylinePoints.decodePolyline(
            step['polyline']['points'],
          );
          points.addAll(decoded.map((p) => LatLng(p.latitude, p.longitude)));
        }
      }

      _remainingPoints = List.from(points);
      isNavigating = true;
      _drawPolylines(_remainingPoints);
      _zoomToFitRoute(origin, destination);
    } else {
      throw Exception("Directions API: ${response.data['status']}");
    }
  }

  void _drawPolylines(List<LatLng> points) {
    if (points.isEmpty) return;
    refresh(() {
      polylines.clear();
      polylines.add(
        Polyline(
          polylineId: const PolylineId('route_border'),
          points: points,
          color: Colors.black,
          width: 10,
          jointType: JointType.round,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          zIndex: 1,
        ),
      );
      polylines.add(
        Polyline(
          polylineId: const PolylineId('route_main'),
          points: points,
          color: const Color(0xFF0000FF),
          width: 8,
          jointType: JointType.round,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          zIndex: 2,
        ),
      );
    });
  }

  void _zoomToFitRoute(LatLng origin, LatLng destination) {
    final bounds = LatLngBounds(
      southwest: LatLng(
        min(origin.latitude, destination.latitude),
        min(origin.longitude, destination.longitude),
      ),
      northeast: LatLng(
        max(origin.latitude, destination.latitude),
        max(origin.longitude, destination.longitude),
      ),
    );
    getMapController()?.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 100),
    );
  }

  void _startLocationTracking() {
    _locationStream?.cancel();
    _locationStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 8,
          ),
        ).listen((Position position) {
          if (!isNavigating) return;
          final userLatLng = LatLng(position.latitude, position.longitude);
          _updateRemainingDistance(userLatLng);

          if (_destination != null) {
            final dist = calculateDistance(
              position.latitude,
              position.longitude,
              _destination!.latitude,
              _destination!.longitude,
            );
            if (dist <= _arrivalRadiusMeters) {
              _onArrived();
              return;
            }
          }

          _trimPassedPoints(userLatLng);

          if (homeController.isAutoCentering.value) {
            isProgrammaticMove = true;
            getMapController()
                ?.animateCamera(CameraUpdate.newLatLng(userLatLng))
                .then((_) => isProgrammaticMove = false);
          }
        });
  }

  void _updateRemainingDistance(LatLng userPos) {
    if (_remainingPoints.isEmpty) return;
    double total = 0.0;
    total += calculateDistance(
      userPos.latitude,
      userPos.longitude,
      _remainingPoints.first.latitude,
      _remainingPoints.first.longitude,
    );
    for (int i = 0; i < _remainingPoints.length - 1; i++) {
      total += calculateDistance(
        _remainingPoints[i].latitude,
        _remainingPoints[i].longitude,
        _remainingPoints[i + 1].latitude,
        _remainingPoints[i + 1].longitude,
      );
    }
    _remainingDistanceController.add(total / 1000.0);
  }

  void _trimPassedPoints(LatLng userLocation) {
    if (_remainingPoints.length < 2) return;
    int closestIndex = 0;
    double minDist = double.infinity;
    final limit = min(30, _remainingPoints.length);
    for (int i = 0; i < limit; i++) {
      final d = calculateDistance(
        userLocation.latitude,
        userLocation.longitude,
        _remainingPoints[i].latitude,
        _remainingPoints[i].longitude,
      );
      if (d < minDist) {
        minDist = d;
        closestIndex = i;
      }
    }
    if (closestIndex > 0) {
      _remainingPoints = _remainingPoints.sublist(closestIndex);
      _drawPolylines(_remainingPoints);
    }
  }

  void _onArrived() {
    if (_arrivalDialogShown) return;
    _arrivalDialogShown = true;

    final navData = homeController.currentNavigationData;
    final resolvedItemId = (navData?.itemId.isNotEmpty ?? false)
        ? navData!.itemId
        : (activeDestinationId ?? '');
    final resolvedApiType = (navData?.apiType.isNotEmpty ?? false)
        ? navData!.apiType
        : (activeDestinationType ?? '');
    stopNavigation();

    showDialog<void>(
      context: getContext(),
      barrierDismissible: true,
      builder: (dialogContext) {
        bool isSubmitting = false;

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Congratulations 🎉',
                      style: TextFontStyle.headline20w500c303030Inter,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'You\'ve reached your destination.\nMark this place as a visited place.',
                      style: TextFontStyle.headline16w500c303030Inter.copyWith(
                        color: AppColors.c7C7C7C,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.h),
                    CustomButton(
                      onTap: () async {
                        if (isSubmitting) return;
                        if (resolvedItemId.isEmpty) {
                          ToastUtil.showErrorMessage('Missing place id');
                          return;
                        }
                        if (resolvedApiType.isEmpty) {
                          ToastUtil.showErrorMessage('Missing place type');
                          return;
                        }

                        setStateDialog(() => isSubmitting = true);

                        final ok = await postVisitedRxObj.postVisited(
                          type: resolvedApiType,
                          id: resolvedItemId,
                        );

                        if (!dialogContext.mounted) return;

                        if (ok) {
                          getVisitedRxObj.fetchVisitedData();

                          final id = int.tryParse(resolvedItemId);
                          if (id != null) {
                            final type = resolvedApiType.toLowerCase();
                            if (type == 'farm') {
                              getFarmsRxObj.updateItemStatus(
                                id,
                                isVisited: true,
                              );
                            } else if (type == 'ranch') {
                              getRanchesRxObj.updateItemStatus(
                                id,
                                isVisited: true,
                              );
                            } else if (type == 'event') {
                              getEventsRxObj.updateItemStatus(
                                id,
                                isVisited: true,
                              );
                            }
                          }

                          Navigator.of(dialogContext).pop();
                          ToastUtil.showSuccessMessage('Marked as visited');
                        } else {
                          setStateDialog(() => isSubmitting = false);
                        }
                      },
                      btnName: isSubmitting
                          ? "Please wait..."
                          : "Mark as Visited",
                      isLocation: true,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      _arrivalDialogShown = false;
    });
  }

  void stopNavigation({bool notifyUi = true}) {
    isNavigating = false;
    _locationStream?.cancel();
    _locationStream = null;
    _remainingPoints.clear();
    _destination = null;
    activeDestinationId = null;
    activeDestinationType = null;

    if (notifyUi) {
      refresh(() {
        polylines.clear();
      });
      homeController.isNavigating.value = false;
      homeController.isAutoCentering.value = false;
      homeController.currentNavigationData = null;
    }
  }
}
