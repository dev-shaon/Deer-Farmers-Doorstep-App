import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:size_matter_swt/common/custom_app_bar.dart';
import 'package:size_matter_swt/constants/app_constants.dart';
import 'package:size_matter_swt/constants/location_category.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/all_routes.dart';
import 'package:size_matter_swt/helpers/di.dart';
import 'package:size_matter_swt/helpers/navigation_service.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';
import 'package:size_matter_swt/networks/api_access.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  void initState() {
    super.initState();
    _getUserProfile();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final alreadyShown = appData.read(kKeyLocationDialogShown) ?? false;
      if (!alreadyShown) {
        _showLocationDialog(context);
      }
    });
  }

  void _showLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            "Location Permission Required",
            style: TextFontStyle.headline16w400c2C6E49Inter,
          ),
          content: Text(
            "This app collects location data to enable features such as finding nearby farms, ranches, and events, even when the app is running in the background.",
            style: TextFontStyle.headline16w500c303030Inter.copyWith(
              color: AppColors.c303030.withValues(alpha: 0.7),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                appData.write(kKeyLocationDialogShown, true);

                NavigationService.goBack();
              },
              child: Text(
                "Deny",
                style: TextFontStyle.headline14w600c000000Inter.copyWith(
                  color: Colors.red,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                appData.write(kKeyLocationDialogShown, true);
                NavigationService.goBack();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.c34A853,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                "Agree",
                style: TextFontStyle.headline14w600c000000Inter.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _getUserProfile() async {
    getProfileRxobj.getProfile();
    notificationRxObj.getNotificationData();
  }

  void _onCategorySelected(LocationCategory category) {
    final bool isSubscribed = appData.read(kkeyisSubscribe) ?? false;

    if (isSubscribed) {
      _navigateToCategoryScreen(category);
    } else {
      _showSubscriptionRequiredDialog(category);
    }
  }

  void _navigateToCategoryScreen(LocationCategory category) {
    if (category == LocationCategory.events) {
      NavigationService.navigateTo(Routes.eventListScreen);
    } else {
      NavigationService.navigateToWithArgs(Routes.navberScreen, {
        'category': category,
      });
    }
  }

  void _showSubscriptionRequiredDialog(LocationCategory category) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            "Subscription Required",
            style: TextFontStyle.headline16w400c2C6E49Inter,
          ),
          content: Text(
            "To access this feature, you need to subscribe first.",
            style: TextFontStyle.headline16w500c303030Inter.copyWith(
              color: AppColors.c303030.withValues(alpha: 0.7),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                NavigationService.goBack();
              },
              child: Text(
                "Cancel",
                style: TextFontStyle.headline14w600c000000Inter.copyWith(
                  color: Colors.red,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                NavigationService.goBack();
                NavigationService.navigateTo(Routes.subscriptionScreen);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.c34A853,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                "Subscribe",
                style: TextFontStyle.headline14w600c000000Inter.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(enableBack: false),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Which one would you like to see.",
                  style: TextFontStyle.headline16w500c303030Inter,
                ),
                UIHelper.verticalSpace(16.h),

                _buildCategoryButton(
                  label: "Farms",
                  image: Assets.images.ranchesImage.path,
                  category: LocationCategory.farms,
                ),
                UIHelper.verticalSpace(10.h),

                _buildCategoryButton(
                  label: "Ranches",
                  image: Assets.images.farmsImage.path,
                  category: LocationCategory.ranches,
                ),
                UIHelper.verticalSpace(10.h),

                _buildCategoryButton(
                  label: "Events",
                  image: Assets.images.eventImage.path,
                  category: LocationCategory.events,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton({
    required String label,
    required String image,
    required LocationCategory category,
  }) {
    return GestureDetector(
      onTap: () => _onCategorySelected(category),
      child: Container(
        height: 48.h,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(image)),
        ),
        child: Center(
          child: Text(label, style: TextFontStyle.headline20w600cFFFFFFInter),
        ),
      ),
    );
  }
}
