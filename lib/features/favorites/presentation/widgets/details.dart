import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';

class Details extends StatefulWidget {
  const Details({super.key});

@override
State<Details> createState() => _DetailsState();

}

class _DetailsState extends State<Details> {
  bool isFavorite = false;
  bool isLocationActive = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            height: 2.h,
            width: 60.w,
            decoration: BoxDecoration(
              color: AppColors.c7C7C7C,
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
        ),
        UIHelper.verticalSpace(16.h),
        Row(
          children: [
            Text(
              "Green Valley Organics",
              style: TextFontStyle.headline16w500c303030Inter,
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                setState(() {
                  isLocationActive = !isLocationActive;
                });
              },
              child: Container(
                padding: EdgeInsets.all(5.r),
                decoration: BoxDecoration(
                  color: AppColors.cADADAD.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: SvgPicture.asset(
                  isLocationActive
                      ? Assets.icons.selectedLocation
                      : Assets.icons.locationIcon,
                  height: 18.h,
                  width: 18.w,
                ),
              ),
            ),
            UIHelper.horizontalSpace(14.w),
            GestureDetector(
              onTap: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
              },
              child: Container(
                padding: EdgeInsets.all(5.r),
                decoration: BoxDecoration(
                  color: AppColors.cADADAD.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: SvgPicture.asset(
                  isFavorite
                      ? Assets.icons.favoriteSelect
                      : Assets.icons.favoritesOutline,
                  height: 18.h,
                  width: 18.w,
                ),
              ),
            ),
          ],
        ),
        UIHelper.verticalSpace(6.h),
        Text(
          "9876 Organic Way, Farmington",
          style: TextFontStyle.headline14w400cADADADInter,
        ),
        UIHelper.verticalSpace(8.h),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.c34A853,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Text(
                "Farm",
                style: TextFontStyle.headline12w400cFFFFFFInter,
              ),
            ),
            UIHelper.horizontalSpace(8.w),
            Text("(35.2 KM)", style: TextFontStyle.headline14w400cADADADInter),
          ],
        ),
        UIHelper.verticalSpace(12.w),
        Row(
          children: [
            SvgPicture.asset(Assets.icons.person),
            UIHelper.horizontalSpace(4.w),
            Text(
              "Ashley Akter",
              style: TextFontStyle.headline14w400cADADADInter,
            ),
            Spacer(),
            SvgPicture.asset(Assets.icons.phoneIcon, height: 14.h, width: 14.w),
            UIHelper.horizontalSpace(6.w),
            Text(
              "+880123456789",
              style: TextFontStyle.headline14w400cADADADInter,
            ),
          ],
        ),
        UIHelper.verticalSpace(20.h),
        GestureDetector(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: AppColors.c2C6E49,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(Assets.icons.start, height: 11.h, width: 9.w),
                UIHelper.horizontalSpace(6.w),
                Text(
                  "Start Navigation",
                  style: TextFontStyle.headline12w500c7C7C7CInter.copyWith(
                    color: AppColors.cFFFFFF,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
