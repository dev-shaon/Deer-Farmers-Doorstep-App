import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';

class SubscriptionFeaturesCard extends StatelessWidget {
  final List<String> features;

  const SubscriptionFeaturesCard({super.key, required this.features});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.cF0F0F0,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.c303030.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: features.map((feature) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: feature == features.last ? 0 : 8.h,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(Assets.icons.markGreen),
                    UIHelper.horizontalSpace(6.w),
                    Expanded(
                      child: Text(
                        feature,
                        style: TextFontStyle.headline16w500c303030Inter
                            .copyWith(color: AppColors.c303030),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          UIHelper.verticalSpace(16.h),
          Text(
            "(Access to these features requires an active subscription.)",
            style: TextFontStyle.headline12w300c303030Inter.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
