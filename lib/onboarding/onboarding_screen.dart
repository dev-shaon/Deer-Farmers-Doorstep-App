import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:size_matter_swt/common/custom_button.dart';
import 'package:size_matter_swt/constants/app_constants.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/all_routes.dart';
import 'package:size_matter_swt/helpers/di.dart';
import 'package:size_matter_swt/helpers/navigation_service.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';
import 'package:size_matter_swt/onboarding/widget/onboard_Item.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  final int _totalPages = 3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) return;

      if (_currentPage < _totalPages - 1) {
        _currentPage++;

        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _timer?.cancel();
      }
    });
  }

  void _onNextPressed() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      appData.write(kKeyIsFirstTime, false);
      NavigationService.navigateToReplacementUntil(Routes.signinScreen);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      appData.write(kKeyIsFirstTime, false);
                      NavigationService.navigateToReplacementUntil(
                        Routes.signinScreen,
                      );
                    },
                    child: Text(
                      "Skip",
                      style: TextFontStyle.headline16w600c2C6E49Inter,
                    ),
                  ),
                ],
              ),

              UIHelper.verticalSpace(140.h), 

              SizedBox(
                height: 380.h,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    OnboardItem(
                      imageUrl: Assets.images.deer1.path,
                      title: 'Discover Farms & Ranches Easily',
                      subtitle:
                          'Find the best routes and plan your visits with a single tap.',
                    ),
                    OnboardItem(
                      imageUrl: Assets.images.deer2.path,
                      title: 'Track Every Place You Visit',
                      subtitle:
                          'Mark and save visited locations for future reference.',
                    ),
                    OnboardItem(
                      imageUrl: Assets.images.deer3.path,
                      title: 'Event Relevant to Your Industry',
                      subtitle:
                          'Stay updated with local farming and ranching offers near you.',
                    ),
                  ],
                ),
              ),

              UIHelper.verticalSpace(20.h),

              SmoothPageIndicator(
                controller: _pageController,
                count: _totalPages,
                effect: ExpandingDotsEffect(
                  dotHeight: 8.h,
                  dotWidth: 8.w,
                  expansionFactor: 3,
                  spacing: 6.w,
                  activeDotColor: AppColors.c34A853,
                  dotColor: AppColors.c34A853.withValues(alpha: 0.3),
                ),
              ),

              UIHelper.verticalSpace(32.h),

              CustomButton(
                onTap: _onNextPressed,
                btnName: _currentPage == _totalPages - 1
                    ? "Get Started"
                    : "Next",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
