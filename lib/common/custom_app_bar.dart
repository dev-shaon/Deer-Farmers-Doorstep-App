import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:size_matter_swt/common/custom_network_image.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/features/notification/model/notification_model.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/all_routes.dart';
import 'package:size_matter_swt/helpers/navigation_service.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';
import 'package:size_matter_swt/networks/api_access.dart';

import '../features/home/presentation/widgets/home_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? greetingText;
  final bool enableBack;
  final double? height;

  const CustomAppBar({
    super.key,
    this.greetingText,
    this.enableBack = true,
    this.height,
  });

  String _resolveGreetingText() {
    final hour = DateTime.now().hour;

    if (hour < 12) return 'Good Morning!';
    if (hour < 17) return 'Good Afternoon!';
    return 'Good Evening!';
  }

  @override
  Widget build(BuildContext context) {
    final resolvedGreetingText = greetingText ?? _resolveGreetingText();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          children: [
            if (enableBack)
              InkWell(
                onTap: () {
                  if (homeController.isNavigating.value) {
                    homeController.stopNavigationCallback?.call();
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: SvgPicture.asset(
                  Assets.icons.arrowBack,
                  height: 24.h,
                  width: 24.w,
                ),
              )
            else
              SizedBox(),

            UIHelper.horizontalSpace(10.w),

            Expanded(
              child: Container(
                height: height ?? preferredSize.height,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.r),
                  border: Border.all(color: Colors.grey.shade300),
                  color: AppColors.scaffoldColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        StreamBuilder<Map>(
                          stream: getProfileRxobj.profileStream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting ||
                                !snapshot.hasData ||
                                snapshot.data == null) {
                              return _buildShimmer(context);
                            }

                            final avatarUrl = getProfileRxobj.avatarUrl;
                            final name = getProfileRxobj.name ?? '';

                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    NavigationService.navigateTo(
                                      Routes.editProfileScreen,
                                    );
                                  },
                                  child: ClipOval(
                                    child: avatarUrl != null
                                        ? CustomNetworkImage(
                                            urls: avatarUrl,
                                            height: 48.h,
                                            width: 48.w,
                                          )
                                        : CircleAvatar(
                                            radius: 24.r,
                                            backgroundColor: AppColors.cADADAD,
                                            child: Icon(
                                              Icons.person,
                                              size: 24.r,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                                UIHelper.horizontalSpace(10.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      resolvedGreetingText,
                                      style: TextFontStyle
                                          .headline14w400cADADADInter,
                                    ),
                                    UIHelper.verticalSpace(2.h),
                                    Text(
                                      name.isNotEmpty ? name : '',
                                      style: TextFontStyle
                                          .headline16w600c303030Inter,
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),

                    StreamBuilder<NotificationModel>(
                      stream: notificationRxObj.fillData,
                      builder: (context, snapshot) {
                        int unreadCount = 0;
                        if (snapshot.hasData && snapshot.data?.data != null) {
                          unreadCount = snapshot.data!.data!.unreadCount ?? 0;
                        }

                        return InkWell(
                          onTap: () {
                            NavigationService.navigateTo(
                              Routes.notificationScreen,
                            );
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                padding: EdgeInsets.all(14.r),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.cADADAD),
                                  color: AppColors.scaffoldColor,
                                ),
                                child: SvgPicture.asset(
                                  Assets.icons.notification,
                                ),
                              ),
                              if (unreadCount > 0)
                                Positioned(
                                  right: -2.w,
                                  top: -2.h,
                                  child: Container(
                                    padding: EdgeInsets.all(4.r),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 16.w,
                                      minHeight: 16.h,
                                    ),
                                    child: Center(
                                      child: Text(
                                        unreadCount > 9
                                            ? '9+'
                                            : unreadCount.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        children: [
          CircleAvatar(radius: 24.r, backgroundColor: Colors.white),
          UIHelper.horizontalSpace(10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80.w,
                height: 14.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              UIHelper.verticalSpace(4.h),
              Container(
                width: 120.w,
                height: 16.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80.h);
}
