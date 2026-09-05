import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:size_matter_swt/common/custom_button.dart';
import 'package:size_matter_swt/constants/app_constants.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/features/profile/model/profile_model.dart';
import 'package:size_matter_swt/features/subscription/presentartion/widgets/pricing_card.dart';
import 'package:size_matter_swt/features/subscription/presentartion/widgets/subscription_features_card.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/di.dart';
import 'package:size_matter_swt/helpers/navigation_service.dart';
import 'package:size_matter_swt/helpers/toast.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';
import 'package:size_matter_swt/networks/api_access.dart';
import 'package:size_matter_swt/providers/subscription_provider.dart';

enum SubscriptionType { week, month, year }

class UpgradeSubscriptionScreen extends StatefulWidget {
  const UpgradeSubscriptionScreen({super.key});

  @override
  State<UpgradeSubscriptionScreen> createState() =>
      _UpgradeSubscriptionScreenState();
}

class _UpgradeSubscriptionScreenState extends State<UpgradeSubscriptionScreen> {
  int _selectedPlan = 0;
  bool _hasUserManuallySelected = false;
  final int _defaultTotalDays = 7;
  final int _defaultCurrentDay = 3;

  @override
  void initState() {
    super.initState();
    _initSelectedPlan();
    _fetchProfile();
  }

  void _initSelectedPlan() {
    final sub = getProfileRxobj.subscription ??
        getProfileRxobj.profileModel?.data?.subscription;
    if (sub != null) {
      final prodId = sub.productId?.toLowerCase() ?? '';
      final entId = sub.entitlementId?.toLowerCase() ?? '';
      final isYearly = prodId.contains('year') ||
          prodId.contains('annual') ||
          entId.contains('year') ||
          entId.contains('annual');
      _selectedPlan = isYearly ? 1 : 0;
    }
  }

  void _fetchProfile() async {
    await getProfileRxobj.getProfile();
    if (mounted && !_hasUserManuallySelected) {
      setState(() {
        _initSelectedPlan();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final subProvider = context.watch<SubscriptionProvider>();
    final packages = subProvider.packages;

    Package? monthlyPackage;
    Package? yearlyPackage;
    for (final pkg in packages) {
      if (pkg.packageType == PackageType.monthly) {
        monthlyPackage = pkg;
      } else if (pkg.packageType == PackageType.annual) {
        yearlyPackage = pkg;
      }
    }

    if (monthlyPackage == null && packages.isNotEmpty) {
      monthlyPackage = packages.firstWhere(
        (p) => p.packageType == PackageType.monthly,
        orElse: () => packages.first,
      );
    }
    if (yearlyPackage == null && packages.isNotEmpty) {
      yearlyPackage = packages.firstWhere(
        (p) => p.packageType == PackageType.annual,
        orElse: () => packages.length > 1 ? packages[1] : packages.first,
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
          child: GestureDetector(
            onTap: () {
              NavigationService.goBack();
            },
            child: SvgPicture.asset(Assets.icons.arrowBack),
          ),
        ),
        automaticallyImplyLeading: false,
        title: Text(
          "Subscription",
          style: TextFontStyle.headline24w700c303030Inter,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.scaffoldColor, AppColors.cE6FFF1],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTrialCard(),
                    UIHelper.verticalSpace(50.h),
                    SubscriptionFeaturesCard(
                      features: [
                        "Access all the firm around you.",
                        "Access all the ranch around you.",
                        "Access all the event around the country.",
                        "Navigate all the places easily",
                      ],
                    ),
                    UIHelper.verticalSpace(50.h),
                    Row(
                      children: [
                        Expanded(
                          child: PricingCard(
                            period: "Monthly",
                            price: monthlyPackage?.storeProduct.priceString ??
                                "\$5.99",
                            billingInfo: "Billed Monthly",
                            isSelected: _selectedPlan == 0,
                            onTap: () {
                              setState(() {
                                _hasUserManuallySelected = true;
                                _selectedPlan = 0;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: PricingCard(
                            period: "Yearly",
                            price: yearlyPackage?.storeProduct.priceString ??
                                "\$39.99",
                            billingInfo: "Billed Yearly",
                            showSavings: true,
                            isSelected: _selectedPlan == 1,
                            onTap: () {
                              setState(() {
                                _hasUserManuallySelected = true;
                                _selectedPlan = 1;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    CustomButton(
                      btnName: "Upgrade Subscription",
                      onTap: () async {
                        final targetPackage =
                            _selectedPlan == 0 ? monthlyPackage : yearlyPackage;

                        if (targetPackage != null) {
                          final success =
                              await subProvider.purchasePackage(targetPackage);
                          if (!context.mounted) return;
                          if (success) {
                            appData.write(kkeyisSubscribe, true);
                            getProfileRxobj.getProfile();
                            ToastUtil.showSuccessMessage(
                              "Subscription upgraded successfully!",
                            );
                            NavigationService.goBack();
                          } else {
                            ToastUtil.showErrorMessage(
                              "Purchase failed or cancelled.",
                            );
                          }
                        } else if (packages.isNotEmpty) {
                          final pkg = _selectedPlan < packages.length
                              ? packages[_selectedPlan]
                              : packages.first;
                          final success =
                              await subProvider.purchasePackage(pkg);
                          if (!context.mounted) return;
                          if (success) {
                            appData.write(kkeyisSubscribe, true);
                            getProfileRxobj.getProfile();
                            ToastUtil.showSuccessMessage(
                              "Subscription upgraded successfully!",
                            );
                            NavigationService.goBack();
                          } else {
                            ToastUtil.showErrorMessage(
                              "Purchase failed or cancelled.",
                            );
                          }
                        } else {
                          ToastUtil.showShortToast(
                            "Connecting to store, please try again...",
                          );
                          subProvider.loadOfferings();
                        }
                      },
                    ),
                    UIHelper.verticalSpace(20.h),
                  ],
                ),
              ),
            ),
          ),
          if (subProvider.isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.c34A853,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTrialCard() {
    return StreamBuilder<Map>(
      stream: getProfileRxobj.profileStream,
      builder: (context, snapshot) {
        Profilemodel? model;
        if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.data!.isNotEmpty) {
          try {
            model = Profilemodel.fromJson(
              Map<String, dynamic>.from(snapshot.data!),
            );
          } catch (_) {}
        } else if (getProfileRxobj.profileModel != null) {
          model = getProfileRxobj.profileModel;
        }

        final isSubscribed =
            model?.data?.isSubscribe ?? getProfileRxobj.isSubscribe ?? false;
        final subscription =
            model?.data?.subscription ?? getProfileRxobj.subscription;

        final prodId = subscription?.productId?.toLowerCase() ?? '';
        final entId = subscription?.entitlementId?.toLowerCase() ?? '';
        bool isYearly = prodId.contains('year') ||
            prodId.contains('annual') ||
            entId.contains('year') ||
            entId.contains('annual');
        bool isMonthly = prodId.contains('month') || entId.contains('month');
        bool isWeekly = prodId.contains('week') || prodId.contains('trial');

        int calculatedTotal = 0;
        int remainingDays = 0;

        if (subscription?.expiresAt != null) {
          final diff = subscription!.expiresAt!.difference(DateTime.now());
          remainingDays = diff.inDays;
          if (diff.inHours > 0 && remainingDays == 0) {
            remainingDays = 1;
          } else if (remainingDays < 0) {
            remainingDays = 0;
          }
        }

        if (subscription?.createdAt != null &&
            subscription?.expiresAt != null) {
          calculatedTotal = subscription!.expiresAt!
              .difference(subscription.createdAt!)
              .inDays;
        }

        // Determine plan type: week, month, or year
        SubscriptionType planType;
        if (isYearly || calculatedTotal > 45) {
          planType = SubscriptionType.year;
        } else if (isMonthly || calculatedTotal > 7) {
          planType = SubscriptionType.month;
        } else if (isWeekly) {
          planType = SubscriptionType.week;
        } else {
          planType = SubscriptionType.week;
        }

        int totalDays;
        int daysLeft;
        int currentDay;

        switch (planType) {
          case SubscriptionType.year:
            totalDays = calculatedTotal >= 360 ? calculatedTotal : 360;
            if (subscription?.expiresAt != null) {
              daysLeft = remainingDays.clamp(0, totalDays);
              currentDay = (totalDays - daysLeft).clamp(1, totalDays);
            } else {
              totalDays = 360;
              daysLeft = 213;
              currentDay = 147;
            }
            break;
          case SubscriptionType.month:
            totalDays = (calculatedTotal >= 28 && calculatedTotal <= 31)
                ? calculatedTotal
                : 30;
            if (subscription?.expiresAt != null) {
              daysLeft = remainingDays.clamp(0, totalDays);
              currentDay = (totalDays - daysLeft).clamp(1, totalDays);
            } else {
              totalDays = 30;
              daysLeft = 20;
              currentDay = 10;
            }
            break;
          case SubscriptionType.week:
            totalDays = (calculatedTotal > 0 && calculatedTotal <= 7)
                ? calculatedTotal
                : 7;
            final createdAt = subscription?.createdAt;
            final expiresAt = subscription?.expiresAt;
            if (expiresAt != null) {
              if (createdAt != null) {
                final diff = DateTime.now().difference(createdAt).inDays + 1;
                currentDay = diff.clamp(1, totalDays);
                daysLeft = (totalDays - currentDay).clamp(0, totalDays);
              } else {
                daysLeft = remainingDays.clamp(0, totalDays);
                currentDay = (totalDays - daysLeft).clamp(1, totalDays);
              }
            } else {
              totalDays = _defaultTotalDays;
              currentDay = _defaultCurrentDay;
              daysLeft = totalDays - currentDay;
            }
            break;
        }

        String cardTitle;
        switch (planType) {
          case SubscriptionType.week:
            cardTitle = isSubscribed
                ? "Your weekly subscription is running"
                : "Your 7-day free trial is running";
            break;
          case SubscriptionType.month:
            cardTitle = "Your monthly subscription is running";
            break;
          case SubscriptionType.year:
            cardTitle = "Your yearly subscription is running";
            break;
        }

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: AppColors.c2C6E49.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.c2C6E49.withValues(alpha: 0.2),
            ),
          ),   
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  cardTitle,
                  style: TextFontStyle.headline16w600c2C6E49Inter.copyWith(
                    color: AppColors.c2C6E49,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              _buildProgressBar(totalDays, currentDay),
              SizedBox(height: 10.h),
              if (planType == SubscriptionType.week)
                _buildWeekIndicators(totalDays)
              else
                _buildMonthOrYearIndicators(totalDays, daysLeft),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressBar(int totalDays, int currentDay) {
    final progress =
        (currentDay / (totalDays > 0 ? totalDays : 1)).clamp(0.0, 1.0);
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        return Container(
          height: 7.h,
          width: totalWidth,
          decoration: BoxDecoration(
            color: const Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(100.r),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 7.h,
              width: totalWidth * progress,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF235E3B),
                    Color(0xFF989F2A),
                  ],
                ),
                borderRadius: BorderRadius.circular(100.r),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWeekIndicators(int totalDays) {
    final count = totalDays > 0 ? totalDays : 7;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(count, (index) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 4.r,
              height: 4.r,
              decoration: const BoxDecoration(
                color: Color(0xFFD1D5DB),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              "D${index + 1}",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF7C7C7C),
                fontFamily: Assets.fonts.urbanist,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildMonthOrYearIndicators(int totalDays, int daysLeft) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Day-1",
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF7C7C7C),
            fontFamily: Assets.fonts.urbanist,
          ),
        ),
        Text(
          "${daysLeft}d left",
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.c2C6E49,
            fontFamily: Assets.fonts.urbanist,
          ),
        ),
        Text(
          "Day-$totalDays",
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF7C7C7C),
            fontFamily: Assets.fonts.urbanist,
          ),
        ),
      ],
    );
  }
}
