import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';

class AGContainer extends StatelessWidget {
  final VoidCallback? onAppleTap;
  final VoidCallback? onGoogleTap;
  const AGContainer({super.key, this.onAppleTap, this.onGoogleTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (Platform.isIOS) ...[
          GestureDetector(
            onTap: onAppleTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: AppColors.c303030,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    Assets.icons.apple,
                    width: 20.w,
                    height: 20.h,
                  ),
                  UIHelper.horizontalSpace(12.w),
                  Text(
                    "Sign in with Apple",
                    style: TextFontStyle.headline16w700cFFFFFFInter.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          UIHelper.verticalSpace(12.w),
        ],

        GestureDetector(
          onTap: onGoogleTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: AppColors.cFFFFFF,
              border: Border.all(color: AppColors.cADADAD),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(Assets.icons.google),
                UIHelper.horizontalSpace(12.w),
                Text(
                  "Sign in with Google",
                  style: TextFontStyle.headline16w600c303030Inter,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
