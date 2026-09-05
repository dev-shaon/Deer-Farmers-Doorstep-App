import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:size_matter_swt/constants/app_constants.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/features/profile/presentation/widget/account_delete.dart';
import 'package:size_matter_swt/features/profile/presentation/widget/profile_button.dart';
import 'package:size_matter_swt/features/profile/presentation/widget/profile_card.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/all_routes.dart';
import 'package:size_matter_swt/helpers/helpers_method.dart';
import 'package:size_matter_swt/helpers/loading_helper.dart';
import 'package:size_matter_swt/helpers/navigation_service.dart';
import 'package:size_matter_swt/helpers/toast.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';
import 'package:size_matter_swt/networks/api_access.dart';

import '../../../helpers/di.dart';

import 'package:size_matter_swt/features/subscription/data/subscription_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _deletePasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserProfile();
  }

  @override
  void dispose() {
    _deletePasswordController.dispose();
    super.dispose();
  }

  void _getUserProfile() async {
    await getProfileRxobj.getProfile();
  }

  void _handleDeleteAccount() {
    final password = _deletePasswordController.text;

    deleteAccountRxObj.delete(password: password).waitingForSucess().then((
      success,
    ) {
      if (success) {
        ToastUtil.showLongToast("Account deleted successfully");
        appData.write(kKeyIsLoggedIn, false);
        appData.remove(kKeyAccessToken);
        appData.remove(kKeyFCMToken);
        SubscriptionService.logOut();
        NavigationService.navigateToReplacementUntil(Routes.signinScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> buttons = [
      {
        'title': 'Edit Profile',
        'icon': Assets.icons.editIcon,
        'onTap': () {
          NavigationService.navigateTo(Routes.editProfileScreen);
        },
      },
      {
        'title': 'Change Password',
        'icon': Assets.icons.protectWhite,
        'onTap': () {
          NavigationService.navigateTo(Routes.changePassword);
        },
      },
      {
        'title': 'Take Notes',
        'icon': Assets.icons.noteIcon,
        'onTap': () {
          NavigationService.navigateTo(Routes.notesScreen);
        },
      },
      {
        'title': 'Terms of Service',
        'icon': Assets.icons.termsIcon,
        'onTap': () {
          NavigationService.navigateTo(Routes.tarmsScreens);
        },
      },
      {
        'title': 'Privacy Policy',
        'icon': Assets.icons.privacyIcon,
        'onTap': () {
          NavigationService.navigateTo(Routes.policyScreen);
        },
      },
      {
        'title': 'Subscription',
        'icon': Assets.icons.subscriptionIcon,
        'onTap': () {
          NavigationService.navigateTo(Routes.upgradeSubscriptionScreen);
        },
      },
      {
        'title': 'Logout',
        'icon': Assets.icons.logOut,
        'onTap': () {
          showCustomDialog(
            context: context,
            subTitile: 'Are you sure you want to log out of your account?',
            confirmButtonName: 'Log Out',
            cancleButtonName: 'Cancel',
            yesTap: () {
              logoutRXobj.logOut().waitingForSucess().then((success) {
                if (success) {
                  ToastUtil.showLongToast("LogOut successfully");
                  appData.write(kKeyIsLoggedIn, false);
                  appData.remove(kKeyAccessToken);
                  appData.remove(kKeyFCMToken);
                  NavigationService.navigateToReplacementUntil(
                    Routes.signinScreen,
                  );
                }
              });
            },
          );
        },
      },
    ];

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 50.h),
      children: [
        UIHelper.verticalSpace(60.h),
        ProfileCard(),
        UIHelper.verticalSpace(10.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: buttons.length,
          itemBuilder: (context, index) {
            final button = buttons[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: ProfileButton(
                title: button['title'],
                onTap: button['onTap'],
                icon: button['icon'],
              ),
            );
          },
        ),
        UIHelper.verticalSpace(20.h),
        GestureDetector(
          onTap: () {
            _deletePasswordController.clear();
            showDialog(
              context: context,
              builder: (_) => AccountDelete(
                subTitile:
                    'To delete your account, please enter your password to confirm.',
                confirmButtonName: 'Yes',
                cancleButtonName: 'No',
                yesTap: _handleDeleteAccount,
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              color: AppColors.cEA4335,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  Assets.icons.deleteIcon,
                  height: 20.h,
                  width: 20.w,
                ),
                UIHelper.horizontalSpace(8.w),
                Text(
                  "Delete Account",
                  style: TextFontStyle.headline16w500cADADADInter.copyWith(
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
