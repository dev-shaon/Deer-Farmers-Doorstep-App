import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:size_matter_swt/common/custom_network_image.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';


class FollowingList extends StatelessWidget {
  final String name;
  final String role;
  const FollowingList({super.key, required this.name, required this.role});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipOval(
                child: CustomNetworkImage(
                  urls:
                      "https://imgs.search.brave.com/biiK0m1k5Hvs4yhFVyTKgyhZlUKi7jnVBe4M03eJfcI/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9zdGF0/aWMucGljbHVtZW4u/Y29tL3BpYy13cC9w/aWNsdW1lbi1maXJz/dC0wMy53ZWJw",
                  height: 48.h,
                  width: 48,
                ),
              ),
              UIHelper.horizontalSpace(12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextFontStyle.headline16w600c303030Inter,
                  ),
                  UIHelper.verticalSpace(4.h),
                  Text(
                    role,
                    style: TextFontStyle.headline16w600c303030Inter,
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.cEA4335,
                border: Border.all(color: AppColors.c7C7C7C),
                borderRadius: BorderRadius.circular(8.r)
              ),
              child: Text(
                "Unfollow",
                style: TextFontStyle.headline16w600c303030Inter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
