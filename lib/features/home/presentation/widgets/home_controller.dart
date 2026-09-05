import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

typedef JumpData = ({
  LatLng position,
  String name,
  String address,
  String type,
  String ownerName,
  String phone,
  String itemId,
  bool? initialIsFavourite,
  bool? initialIsVisited,
});

typedef NavigationData = ({
  LatLng destination,
  String itemId,
  String name,
  String address,
  String type,
  String ownerName,
  String phone,
  double distanceKm,
  String apiType,
  bool? initialIsFavourite,
  bool? initialIsVisited,
});

class HomeController {
  void Function({
    required LatLng position,
    required String name,
    required String address,
    required String type,
    required String ownerName,
    required String phone,
    required String itemId,
    bool? initialIsFavourite,
    bool? initialIsVisited,
  })?
  jumpToLocation;

  JumpData? pendingJump;

  final ValueNotifier<bool> isNavigating = ValueNotifier(false);
  final ValueNotifier<bool> isAutoCentering = ValueNotifier(true);
  final ValueNotifier<int> selectedPlacesFilter = ValueNotifier(-1);
  NavigationData? currentNavigationData;
  VoidCallback? stopNavigationCallback;
  VoidCallback? checkPendingJumpCallback;
}

final homeController = HomeController();
