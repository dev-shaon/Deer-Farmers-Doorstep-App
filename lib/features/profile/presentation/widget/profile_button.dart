import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';

class ProfileButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final String icon;

  const ProfileButton({
    super.key,
    required this.title,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          color: AppColors.c2C6E49,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              height: 20.h,
              width: 20.w,
              colorFilter: ColorFilter.mode(AppColors.cFFFFFF, BlendMode.srcIn),
            ),
            UIHelper.horizontalSpace(8.w),
            Text(
              title,
              style: TextFontStyle.headline16w500cADADADInter.copyWith(
                color: AppColors.cFFFFFF,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
