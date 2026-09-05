import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/navigation_service.dart';


class TwoButton extends StatelessWidget {
  const TwoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 54.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              NavigationService.goBack;
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'Clear all',
                style: TextFontStyle.headline16w600c303030Inter,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              NavigationService.goBack;
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28.r),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.cB16341, AppColors.c964BFF],
                ),
              ),
              child: Text(
                'Show results',
                style: TextFontStyle.headline16w600c303030Inter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
