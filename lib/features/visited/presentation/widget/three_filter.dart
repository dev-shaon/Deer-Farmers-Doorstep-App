import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';

class ThreeFilter extends StatelessWidget {
  final String title;
  final VoidCallback? ontap;
  final bool isSelected;
  const ThreeFilter({
    super.key,
    required this.title,
    this.ontap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.c2C6E49 : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.c2C6E49),
        ),
        child: Text(
          title,
          style: TextFontStyle.headline16w500c303030Inter.copyWith(
            color: isSelected ? AppColors.cFFFFFF : AppColors.c2C6E49,
          ),
        ),
      ),
    );
  }
}
