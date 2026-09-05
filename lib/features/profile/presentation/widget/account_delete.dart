import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:size_matter_swt/common/custom_button.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/navigation_service.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';

class AccountDelete extends StatelessWidget {
  final String subTitile;
  final String text;
  final String confirmButtonName;
  final String cancleButtonName;
  final VoidCallback yesTap;
  final VoidCallback? noTap;
  final Color? confirmTextColor;
  final Color? confirmBorderColor;
  const AccountDelete({
    super.key,
    required this.subTitile,
    this.text = '',
    required this.confirmButtonName,
    required this.cancleButtonName,
    required this.yesTap,
    this.noTap,
    this.confirmTextColor,
    this.confirmBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.scaffoldColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: AppColors.scaffoldColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              subTitile,
              textAlign: TextAlign.center,
              style: TextFontStyle.headline20w500c303030Inter,
            ),
            if (text.isNotEmpty) ...[
              UIHelper.verticalSpace(8.h),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextFontStyle.headline16w600c303030Inter,
              ),
            ],
            UIHelper.verticalSpace(24.h),
            CustomButton(
              onTap: yesTap,
              btnName: confirmButtonName,
              bgColor: AppColors.cEA4335,
            ),
            UIHelper.verticalSpace(12.h),
            InkWell(
              borderRadius: BorderRadius.circular(20.r),
              onTap: () {
                NavigationService.goBack();
                yesTap();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color:
                        confirmBorderColor ??
                        AppColors.c34A853.withValues(alpha: 0.9),
                  ),
                ),
                child: Center(
                  child: Text(
                    cancleButtonName,
                    style: TextFontStyle.headline16w600c303030Inter.copyWith(
                      color: confirmTextColor ?? AppColors.c34A853,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
