import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:size_matter_swt/common/custom_app_bar.dart';
import 'package:size_matter_swt/constants/location_category.dart';
import 'package:size_matter_swt/features/home/presentation/widgets/home_map_logic.dart';
import 'package:size_matter_swt/features/home/presentation/widgets/home_map_widget.dart';
import 'package:size_matter_swt/features/home/presentation/widgets/home_search_bar.dart';
import 'package:size_matter_swt/features/home/presentation/widgets/home_controller.dart';
import 'package:size_matter_swt/features/home/presentation/widgets/location_details_bottom_sheet.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/networks/api_access.dart';

class HomeScreen extends StatefulWidget {
  final LocationCategory category;

  const HomeScreen({super.key, this.category = LocationCategory.farms});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeMapLogic _logic;

  @override
  void initState() {
    super.initState();
    _logic = HomeMapLogic(
      category: widget.category,
      getContext: () => context,
      refresh: (fn) {
        if (mounted) setState(fn);
      },
    );
    _init();
  }

  Future<void> _init() async {
    try {
      getProfileRxobj.getProfile();
      notificationRxObj.getNotificationData();
      await _logic.init();
    } catch (e) {
      debugPrint("HomeScreen._init Error: $e");
    }
  }

  @override
  void dispose() {
    _logic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: ValueListenableBuilder<bool>(
          valueListenable: homeController.isNavigating,
          builder: (context, isNavigating, child) {
            return Stack(
              children: [
                HomeMapWidget(
                  initialCameraPosition: HomeMapLogic.kInitialPosition,
                  hasLocationPermission: _logic.currentPosition != null,
                  topPadding: _logic.nearbyAd != null ? 180.h : 80.h,
                  markers: {
                    ..._logic.markers,
                    if (_logic.nearbyAdMarker != null) _logic.nearbyAdMarker!,
                    if (_logic.userMarker != null) _logic.userMarker!,
                  },
                  polylines: _logic.polylines,
                  onMapCreated: (controller) {
                    _logic.mapController = controller;
                    _logic.checkPendingJump();
                  },
                  onCameraMoveStarted: _logic.handleMapManualMovement,
                  onTap: (location) {
                    if (!_logic.isNavigating) {
                      setState(() {
                        _logic.userMarker = Marker(
                          markerId: const MarkerId('user_selected'),
                          position: location,
                        );
                      });
                    }
                  },
                ),

                ValueListenableBuilder<bool>(
                  valueListenable: homeController.isAutoCentering,
                  builder: (context, isAutoCentering, child) {
                    if (!isNavigating || isAutoCentering) {
                      return const SizedBox.shrink();
                    }
                    return Positioned(
                      right: 16,
                      bottom: MediaQuery.of(context).size.height * 0.42,
                      child: FloatingActionButton.small(
                        onPressed: _logic.reCenter,
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.c34A853,
                        child: const Icon(Icons.my_location),
                      ),
                    );
                  },
                ),
                if (_logic.isRouteFetching || _logic.isMarkersLoading)
                  const Center(
                    child: CircularProgressIndicator(color: AppColors.c34A853),
                  ),

                if (!isNavigating)
                  HomeSearchBar(
                    category: widget.category,
                    nearbyAd: _logic.nearbyAd,
                    onNearbyAdTap: _logic.focusOnNearbyAdFarm,
                    onCloseNearbyAd: _logic.dismissNearbyAd,
                  ),

                if (isNavigating &&
                    homeController.currentNavigationData != null)
                  DraggableScrollableSheet(
                    initialChildSize: 0.38,
                    minChildSize: 0.12,
                    maxChildSize: 0.5,
                    builder: (context, scrollController) {
                      final data = homeController.currentNavigationData!;
                      return SingleChildScrollView(
                        controller: scrollController,
                        child: LocationDetailsBottomSheet(
                          name: data.name,
                          address: data.address,
                          type: data.type,
                          ownerName: data.ownerName,
                          phone: data.phone,
                          distanceKm: data.distanceKm,
                          itemId: data.itemId,
                          apiType: data.apiType,
                          initialIsFavourite: data.initialIsFavourite,
                          initialIsVisited: data.initialIsVisited,
                          isNavigatingCurrently: true,
                          remainingDistanceStream:
                              _logic.remainingDistanceStream,
                          onFavouriteChanged: (isFav) =>
                              _logic.updateFavouriteState(
                                data.itemId,
                                data.apiType,
                                isFav,
                              ),
                          onVisitedChanged: (isVisited) =>
                              _logic.updateVisitedState(
                                data.itemId,
                                data.apiType,
                                isVisited,
                              ),
                          onStopNavigation: () => _logic.stopNavigation(),
                          onStartNavigation: () {},
                        ),
                      );
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
