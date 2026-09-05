import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeMapWidget extends StatelessWidget {
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final bool hasLocationPermission;
  final double topPadding;
  final Function(GoogleMapController) onMapCreated;
  final Function(LatLng) onTap;
  final VoidCallback? onCameraMoveStarted;
  final CameraPosition initialCameraPosition;

  const HomeMapWidget({
    super.key,
    required this.markers,
    required this.polylines,
    required this.hasLocationPermission,
    required this.topPadding,
    required this.onMapCreated,
    required this.onTap,
    this.onCameraMoveStarted,
    required this.initialCameraPosition,
  });

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      padding: EdgeInsets.only(top: topPadding, bottom: 30.h),
      initialCameraPosition: initialCameraPosition,
      myLocationEnabled: hasLocationPermission,
      myLocationButtonEnabled: hasLocationPermission,
      zoomControlsEnabled: true,
      zoomGesturesEnabled: true,
      scrollGesturesEnabled: true,
      onCameraMoveStarted: onCameraMoveStarted,
      gestureRecognizers: {
        Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
      },
      onMapCreated: onMapCreated,
      markers: markers,
      polylines: polylines,
      onTap: onTap,
    );
  }
}
