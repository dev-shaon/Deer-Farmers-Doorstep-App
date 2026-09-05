import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:size_matter_swt/common/custom_network_image.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';
import 'package:size_matter_swt/networks/api_access.dart';

class ProfileCard extends StatelessWidget {
  final VoidCallback? onTap;
  final bool showEditIcon;
  final File? selectedImage;
  // ✅ নতুন parameter — edit screen থেকে loading state পাঠাবে
  final bool isLoading;

  const ProfileCard({
    super.key,
    this.onTap,
    this.showEditIcon = false,
    this.selectedImage,
    this.isLoading = false,
  });

  // ✅ Shimmer block — card এর exact shape এ
  Widget _buildShimmer() {
    return Center(
      child: SizedBox(
        width: 335.w,
        height: 130.h,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Card shimmer
            Positioned(
              bottom: 0,
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 335.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
              ),
            ),

            // Avatar shimmer — card এর উপরে উঠে থাকে
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: CircleAvatar(
                    radius: 35.r,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ),

            // Name shimmer line
            Positioned(
              bottom: 30.h,
              left: 0,
              right: 0,
              child: Center(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: 120.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ),
            ),

            // Email shimmer line
            Positioned(
              bottom: 12.h,
              left: 0,
              right: 0,
              child: Center(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: 160.w,
                    height: 11.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) return _buildShimmer();

    return StreamBuilder<Map>(
      stream: getProfileRxobj.profileStream,
      builder: (context, snapshot) {
        final name = getProfileRxobj.name ?? '';
        final email = getProfileRxobj.email ?? '';
        final avatarUrl = getProfileRxobj.avatarUrl;

        return Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                decoration: BoxDecoration(
                  color: AppColors.cADADAD.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: AppColors.cADADAD.withValues(alpha: 0.4),
                  ),
                ),
                child: Column(
                  children: [
                    UIHelper.verticalSpace(20.h),
                    name.isEmpty
                        ? Container(
                            width: 100.w,
                            height: 16.h,
                            decoration: BoxDecoration(
                              color: AppColors.cADADAD.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          )
                        : Text(
                            name,
                            style: TextFontStyle.headline20w500c303030Inter,
                          ),
                    UIHelper.verticalSpace(4.h),
                    email.isEmpty
                        ? Container(
                            width: 150.w,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: AppColors.cADADAD.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          )
                        : Text(
                            email,
                            style: TextFontStyle.headline14w400cADADADInter,
                          ),
                  ],
                ),
              ),

              Positioned(
                top: -35.h,
                left: 0,
                right: 0,
                child: Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipOval(
                        child: snapshot.hasData && avatarUrl != null
                            ? CustomNetworkImage(
                                urls: avatarUrl,
                                width: 70.w,
                                height: 70.h,
                              )
                            : selectedImage != null
                            ? Image.file(
                                selectedImage!,
                                width: 70.w,
                                height: 70.h,
                                fit: BoxFit.cover,
                              )
                            : CircleAvatar(
                                radius: 35.r,
                                backgroundColor: AppColors.cADADAD,
                                child: Icon(
                                  Icons.person,
                                  size: 35.r,
                                  color: Colors.white,
                                ),
                              ),
                      ),

                      if (showEditIcon)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: onTap,
                            child: Container(
                              padding: EdgeInsets.all(5.r),
                              decoration: BoxDecoration(
                                color: AppColors.c2C6E49,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.scaffoldColor,
                                  width: 1.5.w,
                                ),
                              ),
                              child: SvgPicture.asset(
                                Assets.icons.profileEditIcon,
                                height: 12.h,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
