import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';

class PricingCard extends StatelessWidget {
  final String period;
  final String price;
  final String billingInfo;
  final VoidCallback? onTap;
  final bool showSavings;
  final bool isSelected;

  const PricingCard({
    super.key,
    required this.period,
    required this.price,
    required this.billingInfo,
    this.onTap,
    this.showSavings = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 145.h,
        width: 164.w,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.cE5FFF1.withValues(alpha: 0.1)
              : AppColors.cFFFFFF,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? AppColors.c34A853
                : AppColors.cADADAD.withValues(alpha: 0.5),
            width: isSelected ? 2.w : 1.w,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  period,
                  style: TextFontStyle.headline14w500c303030Inter.copyWith(
                    color: AppColors.c303030,
                  ),
                ),
                const Spacer(),
                if (isSelected) SvgPicture.asset(Assets.icons.verifyIcon),
              ],
            ),
            UIHelper.verticalSpace(4.h),
            Text(price, style: TextFontStyle.headline20w600c303030Inter),

            if (showSavings) ...[
              UIHelper.verticalSpace(8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.c2C6E49.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Save 20%",
                  style: TextFontStyle.headline12w500c7C7C7CInter,
                ),
              ),
            ],

            const Spacer(),

            Text(
              billingInfo,
              style: TextFontStyle.headline14w500c303030Inter.copyWith(
                color: AppColors.c303030,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
