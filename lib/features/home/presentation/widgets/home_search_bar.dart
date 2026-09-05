import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:size_matter_swt/common/custom_form_field.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/features/home/model/nearby_ads_model.dart';
import 'package:size_matter_swt/features/search/presentation/widget/search_filter.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/all_routes.dart';
import 'package:size_matter_swt/helpers/navigation_service.dart';

import 'package:size_matter_swt/features/home/presentation/widgets/home_controller.dart';
import 'package:size_matter_swt/constants/location_category.dart';
import 'package:video_player/video_player.dart';

class HomeSearchBar extends StatelessWidget {
  final LocationCategory category;
  final NearbyAd? nearbyAd;
  final VoidCallback? onNearbyAdTap;
  final VoidCallback? onCloseNearbyAd;

  const HomeSearchBar({
    super.key,
    required this.category,
    this.nearbyAd,
    this.onNearbyAdTap,
    this.onCloseNearbyAd,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10.h,
      left: 20.w,
      right: 20.w,
      child: Column(
        children: [
          CustomFormField(
            onTap: () async {
              await NavigationService.navigateToWithArgs(Routes.searchScreen, {
                'category': category,
              });
              homeController.checkPendingJumpCallback?.call();
            },
            isRead: true,
            hintText: "Search farm, ranch or address",
            prefixIcon: SvgPicture.asset(Assets.icons.search),
            suffixIcon: Padding(
              padding: EdgeInsets.all(8.r),
              child: GestureDetector(
                onTap: () async {
                  final result = await showModalBottomSheet<int>(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    builder: (context) {
                      return SearchFilter(
                        initialSelectedPlaces:
                            homeController.selectedPlacesFilter.value,
                      );
                    },
                  );

                  if (result != null) {
                    homeController.selectedPlacesFilter.value = result;
                  }
                },
                child: SvgPicture.asset(Assets.icons.filter),
              ),
            ),
          ),
          if (nearbyAd != null) ...[
            SizedBox(height: 8.h),
            _NearbyAdCard(
              ad: nearbyAd!,
              onTap: onNearbyAdTap,
              onClose: onCloseNearbyAd,
            ),
          ],
        ],
      ),
    );
  }
}

class _NearbyAdCard extends StatelessWidget {
  final NearbyAd ad;
  final VoidCallback? onTap;
  final VoidCallback? onClose;

  const _NearbyAdCard({required this.ad, this.onTap, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200.h,
              child: Stack(
                children: [
                  Positioned.fill(child: _AdImage(url: ad.image)),
                  Positioned(
                    top: 10.h,
                    left: 10.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            Assets.icons.locationIcon,
                            height: 10.h,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Nearby Offer',
                            style: TextFontStyle.headline12w400cFFFFFFInter
                                .copyWith(fontSize: 10.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content Section
            Container(
              color: AppColors.cFFFFFF,
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ad.title ?? 'Nearby Offer',
                    style: TextFontStyle.headline16w600c303030Inter.copyWith(
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    ad.subtitle ?? 'Tap to view details.',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextFontStyle.headline12w500c7C7C7CInter.copyWith(
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // Distance Indicator
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cF0F0F0, // Solid background
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Distance',
                          style: TextFontStyle.headline12w500c7C7C7CInter
                              .copyWith(fontSize: 12.sp),
                        ),
                        Text(
                          _distanceLabel(ad),
                          style: TextFontStyle.headline12w500c7C7C7CInter
                              .copyWith(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.c303030,
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: onTap,
                          child: Container(
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: AppColors.c2C6E49,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  Assets.icons.start,
                                  height: 14.h,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.cFFFFFF,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  'Start Navigation',
                                  style: TextFontStyle
                                      .headline16w700cFFFFFFInter
                                      .copyWith(fontSize: 13.sp),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: GestureDetector(
                          onTap: onClose,
                          child: Container(
                            height: 40.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.cF0F0F0,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              'Skip',
                              style: TextFontStyle.headline12w500c7C7C7CInter
                                  .copyWith(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.c303030,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  // Sponsored Footer
                  Center(
                    child: Text(
                      'Sponsored · Location-based advertisement',
                      style: TextFontStyle.headline12w500c7C7C7CInter.copyWith(
                        fontSize: 9.sp,
                        color: AppColors.cADADAD,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _distanceLabel(NearbyAd ad) {
    if ((ad.distanceLabel ?? '').trim().isNotEmpty) {
      return ad.distanceLabel!;
    }

    final distanceMeters = ad.distanceMeters;
    if (distanceMeters == null) return 'Nearby';
    if (distanceMeters < 1000)
      return '${distanceMeters.toStringAsFixed(0)} m away';
    return '${(distanceMeters / 1000).toStringAsFixed(1)} km away';
  }
}

class _AdImage extends StatefulWidget {
  final String? url;
  const _AdImage({this.url});

  @override
  State<_AdImage> createState() => _AdImageState();
}

class _AdImageState extends State<_AdImage> {
  VideoPlayerController? _videoController;
  bool _isVideo = false;

  @override
  void initState() {
    super.initState();
    final url = widget.url ?? '';
    _isVideo =
        url.endsWith('.mp4') ||
        url.endsWith('.mov') ||
        url.endsWith('.avi') ||
        url.endsWith('.webm');

    if (_isVideo && url.isNotEmpty) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(url))
        ..initialize().then((_) {
          if (mounted) {
            setState(() {});
            _videoController!.setLooping(true);
            _videoController!.setVolume(0);
            _videoController!.play();
          }
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final url = widget.url ?? '';

    if (url.trim().isEmpty) {
      return Container(color: AppColors.c2C6E49);
    }

    if (_isVideo) {
      if (_videoController != null && _videoController!.value.isInitialized) {
        return FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _videoController!.value.size.width,
            height: _videoController!.value.size.height,
            child: VideoPlayer(_videoController!),
          ),
        );
      }
      return Container(color: AppColors.c2C6E49.withValues(alpha: 0.55));
    }

    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          Container(color: AppColors.c2C6E49),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(color: AppColors.c2C6E49.withValues(alpha: 0.55));
      },
    );
  }
}
