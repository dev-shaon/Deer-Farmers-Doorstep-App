import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:size_matter_swt/constants/app_constants.dart';
import 'package:size_matter_swt/constants/location_category.dart';
import 'package:size_matter_swt/features/home/model/farms_model.dart';
import 'package:size_matter_swt/features/home/model/nearby_ads_model.dart';
import 'package:size_matter_swt/features/home/model/ranche_model.dart';
import 'package:size_matter_swt/features/event_list/model/events_model.dart';
import 'package:size_matter_swt/features/home/presentation/widgets/home_controller.dart';
import 'package:size_matter_swt/features/home/presentation/widgets/location_details_bottom_sheet.dart';
import 'package:size_matter_swt/features/home/presentation/widgets/map_marker_manager.dart';
import 'package:size_matter_swt/features/home/presentation/widgets/map_navigation_manager.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/color_helper.dart';
import 'package:size_matter_swt/helpers/helpers_method.dart';
import 'package:size_matter_swt/networks/api_access.dart';

class HomeMapLogic {
  static const double _nearbyAdsTriggerDistanceMeters = 100.0;
  static const double _nearbyAdsRadiusMeters = 360.0;

  final LocationCategory category;
  final BuildContext Function() getContext;
  final void Function(VoidCallback) refresh;

  late final MapMarkerManager markerManager;
  late final MapNavigationManager navigationManager;

  final Map<String, double> _distanceCache = {};

  HomeMapLogic({
    required this.category,
    required this.getContext,
    required this.refresh,
  }) {
    markerManager = MapMarkerManager(
      category: category,
      showLocationDetails: showLocationDetails,
    );
    navigationManager = MapNavigationManager(
      getMapController: () => mapController,
      refresh: refresh,
      getContext: getContext,
      googleApiKey: googleApiKeyy,
    );
  }

  GoogleMapController? mapController;
  Set<Marker> markers = {};
  Marker? userMarker;
  Marker? nearbyAdMarker;
  Position? currentPosition;
  bool isMarkersLoading = false;
  bool _hasPerformedPendingJump = false;

  NearbyAd? _nearbyAd;
  LatLng? _nearbyAdPosition;
  bool _isNearbyAdDismissed = false;
  bool _isNearbyAdFetchInFlight = false;

  Position? _lastTrackedPosition;
  double _distanceSinceLastNearbyAdsRequest = 0.0;

  bool get isRouteFetching => navigationManager.isRouteFetching;
  bool get isNavigating => navigationManager.isNavigating;
  Set<Polyline> get polylines => navigationManager.polylines;
  Stream<double> get remainingDistanceStream =>
      navigationManager.remainingDistanceStream;
  NearbyAd? get nearbyAd => _isNearbyAdDismissed ? null : _nearbyAd;

  static final CameraPosition kInitialPosition = CameraPosition(
    target: LatLng(23.8103, 90.4125),
    zoom: 14.0,
  );

  StreamSubscription? _dataSub;
  StreamSubscription<Position>? _positionSub;

  void handleMapManualMovement() {
    if (navigationManager.isNavigating &&
        !navigationManager.isProgrammaticMove &&
        homeController.isAutoCentering.value) {
      homeController.isAutoCentering.value = false;
    }
  }

  void reCenter() {
    if (currentPosition != null) {
      mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(currentPosition!.latitude, currentPosition!.longitude),
        ),
      );
      homeController.isAutoCentering.value = true;
    }
  }

  void stopNavigation() => navigationManager.stopNavigation();

  Future<void> init() async {
    _registerController();
    await checkLocationPermission();

    if (currentPosition != null && !_isNearbyAdFetchInFlight) {
      await _fetchNearbyAd(currentPosition!);
    }

    await _startBackgroundLocationTracking();

    _dataSub = _getStreamForCategory().listen((model) {
      refresh(() => markers = markerManager.buildMarkers(model));
    });

    homeController.selectedPlacesFilter.addListener(_onFilterChanged);
    await loadMarkers();
    checkPendingJump();
  }

  Stream _getStreamForCategory() {
    switch (category) {
      case LocationCategory.farms:
        return getFarmsRxObj.fillData.cast<FarmsModel>();
      case LocationCategory.ranches:
        return getRanchesRxObj.fillData.cast<RancheModel>();
      case LocationCategory.events:
        return getEventsRxObj.fillData.cast<EventsModel>();
    }
  }

  void _registerController() {
    homeController.jumpToLocation =
        ({
          required LatLng position,
          required String name,
          required String address,
          required String type,
          required String ownerName,
          required String phone,
          required String itemId,
          bool? initialIsFavourite,
          bool? initialIsVisited,
        }) async {
          if (mapController == null) {
            homeController.pendingJump = (
              position: position,
              name: name,
              address: address,
              type: type,
              ownerName: ownerName,
              phone: phone,
              itemId: itemId,
              initialIsFavourite: initialIsFavourite,
              initialIsVisited: initialIsVisited,
            );
            return;
          }

          mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(position, 16.0),
          );
          _hasPerformedPendingJump = true;
          showLocationDetails(
            position,
            name: name,
            address: address,
            type: type,
            ownerName: ownerName,
            phone: phone,
            itemId: itemId,
            initialIsFavourite: initialIsFavourite,
            initialIsVisited: initialIsVisited,
          );
          homeController.pendingJump = null;
        };

    homeController.stopNavigationCallback = () =>
        navigationManager.stopNavigation();
    homeController.checkPendingJumpCallback = () => checkPendingJump();
  }

  void checkPendingJump() {
    final jump = homeController.pendingJump;
    if (jump == null || mapController == null) return;

    homeController.jumpToLocation?.call(
      position: jump.position,
      name: jump.name,
      address: jump.address,
      type: jump.type,
      ownerName: jump.ownerName,
      phone: jump.phone,
      itemId: jump.itemId,
      initialIsFavourite: jump.initialIsFavourite,
      initialIsVisited: jump.initialIsVisited,
    );
  }

  void dispose() {
    homeController.jumpToLocation = null;
    homeController.stopNavigationCallback = null;
    navigationManager.dispose();
    _dataSub?.cancel();
    _positionSub?.cancel();
    homeController.selectedPlacesFilter.removeListener(_onFilterChanged);
  }

  void _onFilterChanged() {
    final val = _getRxValueForCategory();
    if (val != null) {
      refresh(() => markers = markerManager.buildMarkers(val));
    }
  }

  dynamic _getRxValueForCategory() {
    switch (category) {
      case LocationCategory.farms:
        return getFarmsRxObj.fillData.value;
      case LocationCategory.ranches:
        return getRanchesRxObj.fillData.value;
      case LocationCategory.events:
        return getEventsRxObj.fillData.value;
    }
  }

  Future<void> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      _lastTrackedPosition = currentPosition;
      if (currentPosition != null &&
          homeController.pendingJump == null &&
          !_hasPerformedPendingJump) {
        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(currentPosition!.latitude, currentPosition!.longitude),
            15.0,
          ),
        );
      }
      refresh(() {});
    }
  }

  Future<void> _startBackgroundLocationTracking() async {
    final permission = await Geolocator.checkPermission();
    if (permission != LocationPermission.always &&
        permission != LocationPermission.whileInUse) {
      return;
    }

    _positionSub?.cancel();
    _positionSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen(_handlePositionUpdate);
  }

  void _handlePositionUpdate(Position position) {
    currentPosition = position;

    final previous = _lastTrackedPosition;
    _lastTrackedPosition = position;

    if (previous != null) {
      _distanceSinceLastNearbyAdsRequest += calculateDistance(
        previous.latitude,
        previous.longitude,
        position.latitude,
        position.longitude,
      );

      if (_distanceSinceLastNearbyAdsRequest >=
          _nearbyAdsTriggerDistanceMeters) {
        final triggerCount =
            (_distanceSinceLastNearbyAdsRequest /
                    _nearbyAdsTriggerDistanceMeters)
                .floor();
        _distanceSinceLastNearbyAdsRequest -=
            triggerCount * _nearbyAdsTriggerDistanceMeters;

        if (!_isNearbyAdFetchInFlight) {
          unawaited(_fetchNearbyAd(position));
        }
      }
    }

    _evaluateNearbyAdGeofence(position);
  }

  Future<void> _fetchNearbyAd(Position position) async {
    _isNearbyAdFetchInFlight = true;
    try {
      final ad = await getNearbyAdsRxObj.fetchFirstNearbyAd(
        latitude: position.latitude,
        longitude: position.longitude,
        radius: _nearbyAdsRadiusMeters,
      );

      if (ad == null) {
        if (_nearbyAd != null ||
            nearbyAdMarker != null ||
            _isNearbyAdDismissed) {
          refresh(() => _clearNearbyAdState());
        }
        return;
      }

      final adPosition = _positionFromNearbyAd(ad);
      if (adPosition == null) {
        refresh(() => _clearNearbyAdState());
        return;
        
      }

      if (!_isInsideNearbyAdGeofence(position, adPosition)) {
        refresh(() => _clearNearbyAdState());
        return;
      }

      refresh(() {
        _nearbyAd = ad;
        _nearbyAdPosition = adPosition;
        _isNearbyAdDismissed = false;
        nearbyAdMarker = null;
      });
    } finally {
      _isNearbyAdFetchInFlight = false;
    }
  }

  void _evaluateNearbyAdGeofence(Position position) {
    if (_nearbyAd == null || _nearbyAdPosition == null) return;

    if (!_isInsideNearbyAdGeofence(position, _nearbyAdPosition!)) {
      refresh(() => _clearNearbyAdState());
    }
  }

  bool _isInsideNearbyAdGeofence(Position position, LatLng center) {
    final distance = calculateDistance(
      position.latitude,
      position.longitude,
      center.latitude,
      center.longitude,
    );
    return distance <= _nearbyAdsRadiusMeters;
  }

  LatLng? _positionFromNearbyAd(NearbyAd ad) {
    if (ad.triggerLatitude == null || ad.triggerLongitude == null) {
      return null;
    }
    return LatLng(ad.triggerLatitude!, ad.triggerLongitude!);
  }

  void dismissNearbyAd() {
    if (_nearbyAd == null || _isNearbyAdDismissed) return;
    refresh(() {
      _isNearbyAdDismissed = true;
      nearbyAdMarker = null;
    });
  }

  void focusOnNearbyAdFarm() {
    final ad = nearbyAd;
    if (ad == null) return;

    final targetPosition = _positionFromNearbyAd(ad);
    if (targetPosition == null) return;

    final pinHue = _resolveFavouriteVisitedPinHue();

    refresh(() {
      nearbyAdMarker = Marker(
        markerId: MarkerId('nearby_ad_${ad.id ?? 'farm'}'),
        position: targetPosition,
        zIndexInt: 4,
        icon: BitmapDescriptor.defaultMarkerWithHue(pinHue),
        infoWindow: InfoWindow(title: ad.title ?? 'Nearby Farm'),
      );
    });

    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(targetPosition, 16.0),
    );

    final itemId = ad.id?.toString() ?? '';
    final name = ad.title ?? 'Nearby Offer';
    final address = ad.subtitle ?? '';
    final type = _apiTypeForCategory();
    final distKm = (ad.distanceMeters ?? 0) / 1000.0;

    homeController.currentNavigationData = (
      destination: targetPosition,
      itemId: itemId,
      name: name,
      address: address,
      type: type,
      ownerName: '',
      phone: '',
      distanceKm: distKm,
      apiType: _apiTypeForCategory(),
      initialIsFavourite: false,
      initialIsVisited: false,
    );

    navigationManager.startNavigation(
      targetPosition,
      itemId,
      _apiTypeForCategory(),
      currentPosition,
    );
  }

  double _resolveFavouriteVisitedPinHue() {
    final source = _getRxValueForCategory();

    if (source is FarmsModel) {
      for (final farm in (source.data?.farms ?? <Farm>[])) {
        if ((farm.isFavorite ?? false) || (farm.isVisited ?? false)) {
          return colorToHue(hexToColor(farm.markerColor));
        }
      }
    } else if (source is RancheModel) {
      for (final ranch in (source.data?.ranches ?? <Ranch>[])) {
        if ((ranch.isFavorite ?? false) || (ranch.isVisited ?? false)) {
          return colorToHue(hexToColor(ranch.markerColor));
        }
      }
    } else if (source is EventsModel) {
      for (final event in (source.data?.events ?? <Event>[])) {
        if ((event.isFavorite ?? false) || (event.isVisited ?? false)) {
          return colorToHue(hexToColor(event.markerColor));
        }
      }
    }

    return colorToHue(AppColors.cEA4335);
  }

  void _clearNearbyAdState() {
    _nearbyAd = null;
    _nearbyAdPosition = null;
    _isNearbyAdDismissed = false;
    nearbyAdMarker = null;
  }

  Future<void> loadMarkers() async {
    refresh(() => isMarkersLoading = true);
    try {
      bool success = false;
      switch (category) {
        case LocationCategory.farms:
          success = await getFarmsRxObj.fetchFarmsData();
          break;
        case LocationCategory.ranches:
          success = await getRanchesRxObj.fetchRanches();
          break;
        case LocationCategory.events:
          success = await getEventsRxObj.fetchEvents();
          break;
      }
      if (success) _onFilterChanged();
    } finally {
      refresh(() => isMarkersLoading = false);
    }
  }

  Future<Position?> _resolveDistanceOrigin() async {
    if (currentPosition != null) return currentPosition;
    if (_lastTrackedPosition != null) {
      currentPosition = _lastTrackedPosition;
      return _lastTrackedPosition;
    }

    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final requested = await Geolocator.requestPermission();
      if (requested != LocationPermission.always &&
          requested != LocationPermission.whileInUse) {
        return null;
      }
    } else if (permission == LocationPermission.deniedForever) {
      return null;
    }

    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      currentPosition = pos;
      _lastTrackedPosition = pos;
      return pos;
    } catch (_) {
      return null;
    }
  }

  // ✅ Road distance with cache
  Future<double> _getRoadDistanceKm(LatLng origin, LatLng destination) async {
    final cacheKey =
        '${origin.latitude},${origin.longitude}-${destination.latitude},${destination.longitude}';

    if (_distanceCache.containsKey(cacheKey)) {
      return _distanceCache[cacheKey]!;
    }

    try {
      final dio = Dio();
      final url =
          "https://maps.googleapis.com/maps/api/directions/json"
          "?origin=${origin.latitude},${origin.longitude}"
          "&destination=${destination.latitude},${destination.longitude}"
          "&mode=driving"
          "&key=$googleApiKeyy";

      final response = await dio.get(url);

      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        final meters =
            response.data['routes'][0]['legs'][0]['distance']['value'] as int;
        final km = meters / 1000.0;
        _distanceCache[cacheKey] = km;
        return km;
      }
    } catch (e) {
      debugPrint("Road distance error: $e");
    }

    // fallback straight line
    return calculateDistance(
          origin.latitude,
          origin.longitude,
          destination.latitude,
          destination.longitude,
        ) /
        1000.0;
  }

  Future<void> showLocationDetails(
    LatLng destination, {
    required String name,
    required String address,
    required String type,
    required String ownerName,
    required String phone,
    required String itemId,
    bool? initialIsFavourite,
    bool? initialIsVisited,
  }) async {
    final origin = await _resolveDistanceOrigin();

    // ✅ road distance
    final distKm = origin != null
        ? await _getRoadDistanceKm(
            LatLng(origin.latitude, origin.longitude),
            destination,
          )
        : 0.0;

    showModalBottomSheet(
      context: getContext(),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => LocationDetailsBottomSheet(
        name: name,
        address: address,
        type: type,
        ownerName: ownerName,
        phone: phone,
        distanceKm: distKm,
        itemId: itemId,
        apiType: _apiTypeForCategory(),
        initialIsFavourite: initialIsFavourite,
        initialIsVisited: initialIsVisited,
        isNavigatingCurrently:
            navigationManager.isNavigating &&
            navigationManager.activeDestinationId == itemId,
        remainingDistanceStream: navigationManager.remainingDistanceStream,
        onFavouriteChanged: (isFav) =>
            updateFavouriteState(itemId, type, isFav),
        onVisitedChanged: (isVisited) =>
            updateVisitedState(itemId, type, isVisited),
        onStopNavigation: () {
          Navigator.pop(getContext());
          navigationManager.stopNavigation();
        },
        onStartNavigation: () {
          Navigator.pop(getContext());
          homeController.currentNavigationData = (
            destination: destination,
            itemId: itemId,
            name: name,
            address: address,
            type: type,
            ownerName: ownerName,
            phone: phone,
            distanceKm: distKm,
            apiType: _apiTypeForCategory(),
            initialIsFavourite: initialIsFavourite,
            initialIsVisited: initialIsVisited,
          );
          navigationManager.startNavigation(
            destination,
            itemId,
            _apiTypeForCategory(),
            currentPosition,
          );
        },
      ),
    );
  }

  String _apiTypeForCategory() {
    switch (category) {
      case LocationCategory.farms:
        return 'farm';
      case LocationCategory.ranches:
        return 'ranch';
      case LocationCategory.events:
        return 'event';
    }
  }

  void updateFavouriteState(String itemId, String type, bool isFav) {
    _updateState(itemId, type, isFav: isFav);
  }

  void updateVisitedState(String itemId, String type, bool isVisited) {
    _updateState(itemId, type, isVisited: isVisited);
  }

  void _updateState(
    String itemId,
    String type, {
    bool? isFav,
    bool? isVisited,
  }) {
    final id = int.tryParse(itemId);
    if (id == null) return;
    if (type.toLowerCase() == 'farm') {
      getFarmsRxObj.updateItemStatus(
        id,
        isFavorite: isFav,
        isVisited: isVisited,
      );
    } else if (type.toLowerCase() == 'ranch') {
      getRanchesRxObj.updateItemStatus(
        id,
        isFavorite: isFav,
        isVisited: isVisited,
      );
    } else if (type.toLowerCase() == 'event') {
      getEventsRxObj.updateItemStatus(
        id,
        isFavorite: isFav,
        isVisited: isVisited,
      );
    }

    if (homeController.currentNavigationData?.itemId == itemId) {
      final old = homeController.currentNavigationData!;
      homeController.currentNavigationData = (
        destination: old.destination,
        itemId: old.itemId,
        name: old.name,
        address: old.address,
        type: old.type,
        ownerName: old.ownerName,
        phone: old.phone,
        distanceKm: old.distanceKm,
        apiType: old.apiType,
        initialIsFavourite: isFav ?? old.initialIsFavourite,
        initialIsVisited: isVisited ?? old.initialIsVisited,
      );
    }
    refresh(() {});
  }
}
