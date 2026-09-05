import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';

class EventCard extends StatelessWidget {
  final String imageUrl;
  final String daysLeft;
  final String eventDay;
  final String eventMonth;
  final String eventYear;
  final String title;
  final String location;
  final String duration;
  final VoidCallback? onMapViewTap;

  const EventCard({
    super.key,
    required this.imageUrl,
    required this.daysLeft,
    required this.eventDay,
    required this.eventMonth,
    required this.eventYear,
    required this.title,
    required this.location,
    required this.duration,
    this.onMapViewTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                child: Image.network(
                  imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cFFFFFF,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    daysLeft,
                    style: TextFontStyle.headline14w500c303030Inter.copyWith(
                      color: AppColors.c303030,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Text(
                      "$eventDay $eventMonth",
                      style: TextFontStyle.headline16w500c303030Inter,
                    ),
                    Text(
                      eventYear,
                      style: TextFontStyle.headline20w600c303030Inter,
                    ),
                  ],
                ),
                UIHelper.horizontalSpace(12.w),
                const VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: Colors.grey,
                ),
                UIHelper.horizontalSpace(16.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextFontStyle.headline16w600c303030Inter
                            .copyWith(fontSize: 18.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      UIHelper.verticalSpace(4.h),
                      Text(
                        location,
                        style: TextFontStyle.headline14w500c303030Inter
                            .copyWith(color: AppColors.c7C7C7C),
                      ),
                      Text(
                        "Event duration: $duration",
                        style: TextFontStyle.headline14w500c303030Inter
                            .copyWith(color: AppColors.c7C7C7C),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: GestureDetector(
              onTap: onMapViewTap,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.c2C6E49,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(Assets.icons.mapIcon),
                    UIHelper.horizontalSpace(8.w),
                    Text(
                      "View in map",
                      style: TextFontStyle.headline14w500c303030Inter.copyWith(
                        color: AppColors.cFFFFFF,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
