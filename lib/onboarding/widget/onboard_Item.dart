import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';

class OnboardItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;

  const OnboardItem({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(

          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r)),
          child: Image.asset(imageUrl, fit: BoxFit.cover),
        ),

        UIHelper.verticalSpace(20.h),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextFontStyle.headline20w700c303030Inter,
        ),
        UIHelper.verticalSpace(8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextFontStyle.headline14w500c303030Inter,
          ),
        ),
        UIHelper.verticalSpace(40.h),
      ],
    );
  }
}
