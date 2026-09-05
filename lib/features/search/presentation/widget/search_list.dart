import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';

class SearchList extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const SearchList({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.onRemove,
  });

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          SvgPicture.asset(Assets.icons.clear),
          UIHelper.horizontalSpace(16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextFontStyle.headline16w500cADADADInter.copyWith(
                    color: AppColors.c7C7C7C,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                UIHelper.verticalSpace(8.h),
                Text(
                  widget.subtitle,
                  style: TextFontStyle.headline14w400cADADADInter,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          if (widget.onRemove != null)
            GestureDetector(
              onTap: widget.onRemove,
              child: Container(
                padding: EdgeInsets.all(7.r),
                decoration: BoxDecoration(
                  color: AppColors.cADADAD.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: SvgPicture.asset(
                  Assets.icons.cross,
                  height: 18.h,
                  width: 18.w,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
