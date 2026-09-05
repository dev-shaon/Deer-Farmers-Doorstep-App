import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String btnName;
  final TextStyle? textStyle;
  final double? borderRadius;
  final Color? bgColor;
  final Color? fontColor;
  final double? height;
  final double? width;
  final double? fontSize;
  final bool? isLocation;

  const CustomButton({
    super.key,
    required this.onTap,
    required this.btnName,
    this.textStyle,
    this.borderRadius,
    this.bgColor,
    this.height,
    this.width,
    this.fontSize,
    this.fontColor, this.isLocation,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? 355.w,
        height: height ?? 56.h,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 16.w),
        decoration: ShapeDecoration(
          color: bgColor ?? AppColors.c2C6E49,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 30.r),
            side: BorderSide(color: bgColor ?? AppColors.c2C6E49),
          ),
        ),
        child: FittedBox(
          child: Row(
            children: [
              if(isLocation == true) ...[
                Icon(Icons.location_on, color: fontColor ?? AppColors.cFFFFFF, size: fontSize ?? 16.sp),
                SizedBox(width: 8.w),
              ],
              Text(
                btnName,
                style:
                    textStyle ??
                    TextFontStyle.headline16w700cFFFFFFInter
              ),
            ],
          ),
        ),
      ),
    );
  }
}
