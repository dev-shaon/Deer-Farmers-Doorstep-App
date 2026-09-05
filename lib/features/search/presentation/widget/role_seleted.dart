import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';

class RoleSeleted extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleSeleted({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.cADADAD.withValues(alpha: 0.3)
              : AppColors.cADADAD.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(90.r),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              isSelected ? Assets.icons.selectedIcon : Assets.icons.unseclect,
            ),
            UIHelper.horizontalSpace(10.w),
            Text(
              text,
              style: TextFontStyle.headline12w300c303030Inter.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
