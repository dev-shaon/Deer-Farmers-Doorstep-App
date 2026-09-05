import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:size_matter_swt/common/custom_button.dart';
import 'package:size_matter_swt/constants/app_constants.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/features/subscription/presentartion/widgets/pricing_card.dart';
import 'package:size_matter_swt/features/subscription/presentartion/widgets/subscription_features_card.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/all_routes.dart';
import 'package:size_matter_swt/helpers/di.dart';
import 'package:size_matter_swt/helpers/navigation_service.dart';
import 'package:size_matter_swt/helpers/toast.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';
import 'package:size_matter_swt/providers/subscription_provider.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    log("============> ${appData.read(kkeyisSubscribe)}");
    log('============> ${appData.read(kKeyUserId)}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final subProvider = context.watch<SubscriptionProvider>();
    final packages = subProvider.packages;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.c34A853.withValues(alpha: 0.4),
                  AppColors.scaffoldColor,
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      UIHelper.verticalSpace(16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 24.w),
                          Text(
                            "FARMERS DOORSTEP",
                            style: TextFontStyle.headline24w700c303030Inter
                                .copyWith(color: AppColors.c000000),
                          ),
                          InkWell(
                            onTap: () {
                              NavigationService.goBack();
                            },
                            child: SvgPicture.asset(
                              Assets.icons.cross,
                              color: AppColors.c000000,
                            ),
                          ),
                        ],
                      ),
                      UIHelper.verticalSpace(16.h),
                      Text(
                        "Unlock your visibility and most impactful potentials.",
                        style: TextFontStyle.headline16w500c303030Inter
                            .copyWith(
                              color: AppColors.c303030.withValues(alpha: 0.5),
                            ),
                        textAlign: TextAlign.center,
                      ),
                      UIHelper.verticalSpace(30.h),
                      SvgPicture.asset(Assets.icons.farmsssIcon),
                      UIHelper.verticalSpace(20.h),
                      SubscriptionFeaturesCard(
                        features: [
                          "Access all the firm around you.",
                          "Access all the ranch around you.",
                          "Access all the event around the country.",
                          "Navigate all the places easily",
                        ],
                      ),

                      UIHelper.verticalSpace(20.h),
                      if (subProvider.isLoading && packages.isEmpty)
                        // Offerings are still loading — show a spinner
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.h),
                          child: Column(
                            children: [
                              const CircularProgressIndicator(
                                color: AppColors.c34A853,
                              ),
                              UIHelper.verticalSpace(12.h),
                              Text(
                                "Loading subscription plans...",
                                style: TextFontStyle.headline12w300c303030Inter
                                    .copyWith(
                                      color: AppColors.c303030.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                              ),
                            ],
                          ),
                        )
                      else if (packages.isEmpty)
                        // Finished loading but still empty — show retry
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.h),
                          child: Column(
                            children: [
                              Text(
                                "Unable to load plans.\nPlease check your connection.",
                                textAlign: TextAlign.center,
                                style: TextFontStyle.headline12w300c303030Inter
                                    .copyWith(
                                      color: AppColors.c303030.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                              ),
                              UIHelper.verticalSpace(12.h),
                              TextButton(
                                onPressed: () => subProvider.loadOfferings(),
                                child: Text(
                                  "Tap to retry",
                                  style: TextFontStyle
                                      .headline14w600c000000Inter
                                      .copyWith(color: AppColors.c34A853),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(packages.length, (index) {
                              final package = packages[index];
                              final product = package.storeProduct;

                              String title = "";
                              String billingInfo = "";
                              bool showSavings = false;

                              if (package.packageType == PackageType.monthly) {
                                title = "Monthly";
                                billingInfo = "Billed Monthly";
                                showSavings = false;
                              } else if (package.packageType ==
                                  PackageType.annual) {
                                title = "Yearly";
                                billingInfo = "Billed Yearly";
                                showSavings = true;
                              } else if (package.packageType ==
                                  PackageType.weekly) {
                                title = "Weekly";
                                billingInfo = "Billed Weekly";
                                showSavings = false;
                              } else if (package.packageType ==
                                  PackageType.lifetime) {
                                title = "Lifetime";
                                billingInfo = "One-time payment";
                                showSavings = false;
                              } else {
                                title = product.title.split('(').first.trim();
                                billingInfo = product.description;
                                showSavings = false;
                              }

                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                child: PricingCard(
                                  period: title,
                                  price: product.priceString,
                                  isSelected: selectedIndex == index,
                                  billingInfo: billingInfo,
                                  showSavings: showSavings,
                                  onTap: () async {
                                    setState(() {
                                      selectedIndex = index;
                                    });
                                    final success = await subProvider
                                        .purchasePackage(package);
                                    if (!mounted) return;
                                    if (success) {
                                      appData.write(kkeyisSubscribe, true);
                                      ToastUtil.showSuccessMessage(
                                        "Subscription activated successfully!",
                                      );
                                      NavigationService.navigateTo(
                                        Routes.firstScreen,
                                      );
                                    } else {
                                      ToastUtil.showErrorMessage(
                                        "Purchase failed or cancelled.",
                                      );
                                    }
                                  },
                                ),
                              );
                            }),
                          ),
                        ),
                      UIHelper.verticalSpace(30.h),
                      CustomButton(
                        onTap: () async {
                          if (packages.isNotEmpty) {
                            if (selectedIndex < packages.length) {
                              final success = await subProvider.purchasePackage(
                                packages[selectedIndex],
                              );
                              if (!mounted) return;
                              if (success) {
                                appData.write(kkeyisSubscribe, true);
                                ToastUtil.showSuccessMessage(
                                  "Subscription activated successfully!",
                                );
                                NavigationService.navigateTo(
                                  Routes.firstScreen,
                                );
                              } else {
                                ToastUtil.showErrorMessage(
                                  "Purchase failed or cancelled.",
                                );
                              }
                            }
                          } else {
                            ToastUtil.showShortToast(
                              "Connecting to store, please try again...",
                            );
                            subProvider.loadOfferings();
                          }
                        },
                        btnName: subProvider.isPremium
                            ? "You are Subscribed"
                            : "Start Your 1-Week Free Trial",
                      ),
                      if (packages.isNotEmpty &&
                          selectedIndex < packages.length) ...[
                        UIHelper.verticalSpace(12.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Text(
                            "7 days free trial, then ${packages[selectedIndex].storeProduct.priceString}/${packages[selectedIndex].packageType == PackageType.annual ? 'year' : 'month'}. Cancel anytime in Google Play Store > Subscriptions before trial ends to avoid recurring charges.",
                            textAlign: TextAlign.center,
                            style: TextFontStyle.headline12w300c303030Inter
                                .copyWith(
                                  fontSize: 11.sp,
                                  color: AppColors.c303030.withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                          ),
                        ),
                      ],
                      UIHelper.verticalSpace(10.h),

                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: InkWell(
                                onTap: () {
                                  NavigationService.navigateTo(
                                    Routes.tarmsScreens,
                                  );
                                },
                                child: Text(
                                  "Terms of Conditions ",
                                  style: TextFontStyle
                                      .headline14w600c000000Inter
                                      .copyWith(
                                        color: AppColors.c34A853,
                                        decoration: TextDecoration.underline,
                                      ),
                                ),
                              ),
                            ),
                            TextSpan(
                              text: " and ",
                              style: TextFontStyle.headline14w600c000000Inter
                                  .copyWith(color: AppColors.c303030),
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: InkWell(
                                onTap: () {
                                  NavigationService.navigateTo(
                                    Routes.policyScreen,
                                  );
                                },
                                child: Text(
                                  " Privacy Policy",
                                  style: TextFontStyle
                                      .headline14w600c000000Inter
                                      .copyWith(
                                        color: AppColors.c34A853,
                                        decoration: TextDecoration.underline,
                                      ),
                                ),
                              ),
                            ),
                            const TextSpan(text: ". "),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: InkWell(
                                onTap: () async {
                                  final success = await subProvider
                                      .restorePurchases();
                                  if (!mounted) return;
                                  if (success) {
                                    appData.write(kkeyisSubscribe, true);
                                    ToastUtil.showSuccessMessage(
                                      "Purchases restored successfully!",
                                    );
                                    NavigationService.navigateTo(
                                      Routes.firstScreen,
                                    );
                                  } else {
                                    ToastUtil.showErrorMessage(
                                      "No active subscription found to restore.",
                                    );
                                  }
                                },
                                child: Text(
                                  "Restore Purchase",
                                  style: TextFontStyle
                                      .headline14w600c000000Inter
                                      .copyWith(
                                        color: AppColors.c34A853,
                                        decoration: TextDecoration.underline,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (subProvider.isLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
