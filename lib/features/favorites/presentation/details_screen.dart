import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:size_matter_swt/common/custom_app_bar.dart';
import 'package:size_matter_swt/features/favorites/presentation/widgets/details.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:size_matter_swt/networks/api_access.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool _hasLocationPermission = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    notificationRxObj.getNotificationData();
  }

  Future<void> _checkLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      if (mounted) {
        setState(() {
          _hasLocationPermission = true;
        });
      }
    }
  }

  static final CameraPosition _kGoogleplex = CameraPosition(
    target: LatLng(23.8103, 90.4125),
    zoom: 14.0,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _kGoogleplex,
            myLocationEnabled: _hasLocationPermission,
            myLocationButtonEnabled: _hasLocationPermission,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
            gestureRecognizers: {
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
            markers: {
              Marker(
                markerId: MarkerId('details_location'),
                position: _kGoogleplex.target,
              )
            },
          ),
          Column(
            children: [
              Spacer(),
              // UIHelper.verticalSpace(200.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(color: AppColors.cFFFFFF),
                child: SafeArea(
                  child: Details()
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
