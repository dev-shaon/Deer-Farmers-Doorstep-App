import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';

class CustomTaskCard extends StatelessWidget {
  final String title;
  final String description;
  final Color titleBgColor;
  final Color titleTextColor;
  final Color cardColor;

  const CustomTaskCard({
    super.key,
    required this.title,
    required this.description,
    this.titleBgColor = Colors.green,
    this.titleTextColor = Colors.white,
    this.cardColor = const Color(0xffF1F1F1),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.c000000.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: titleBgColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Text(
              title,
              style: TextFontStyle.headline16w400c2C6E49Inter.copyWith(
                color: AppColors.cFFFFFF,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.r),
              child: Text(
                description,
                style: TextFontStyle.headline14w500c303030Inter.copyWith(
                  color: AppColors.c000000,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
