import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:size_matter_swt/common/custom_network_image.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';

class CustomNotification extends StatelessWidget {
  final String userName;
  final String actionText;
  final String title;
  final String timeText;
  final VoidCallback? deleteonTap;
  final bool isRead;
  final VoidCallback? onTap;

  const CustomNotification({
    super.key,
    required this.userName,
    required this.actionText,
    required this.title,
    required this.timeText,
    this.deleteonTap,
    this.isRead = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: isRead ? Colors.transparent : AppColors.cFCF5E9,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.w),
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.c34A853,
            child: CustomNetworkImage(
              urls:
                  "https://imgs.search.brave.com/DtSf7kst8ldYN_tEgoqiFfXUI8IK0uSz6nDbV5toquc/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS5nZXR0eWltYWdl/cy5jb20vaWQvMjE1/MDA0OTc2MS9waG90/by9ub3RpZmljYXRp/b24tYmVsbC13aXRo/LW9uZS1ub3RpZmlj/YXRpb24tcmVkLWRv/dC1wYXBlci1jcmFm/dC5qcGc_cz02MTJ4/NjEyJnc9MCZrPTIw/JmM9VW9NNUJTb1FY/cFpNRnBwV3FxaXo1/aHE4Qk80emtWRGZY/YmZzckIxLWh3dz0",
              borderRadius: 20.r,
            ),
          ),
          UIHelper.horizontalSpace(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: '$userName ',
                    style: TextFontStyle.headline16w600c303030Inter,
                    children: [
                      TextSpan(
                        text: actionText,
                        style: TextFontStyle.headline16w400c2C6E49Inter,
                      ),
                      TextSpan(
                        text: '\n$title',
                        style: TextFontStyle.headline16w600c303030Inter,
                      ),
                    ],
                  ),
                ),
                UIHelper.verticalSpace(4.h),
                Text(timeText, style: TextFontStyle.headline12w300c303030Inter),
              ],
            ),
          ),
          UIHelper.horizontalSpace(10.w),
          GestureDetector(
            onTap: deleteonTap,
            child: SvgPicture.asset(
              Assets.icons.deleted,
              height: 18.h,
              width: 18.w,
            ),
          ),
        ],
      ),
      )
    );
  }
}
