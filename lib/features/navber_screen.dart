import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:size_matter_swt/constants/location_category.dart';
import 'package:size_matter_swt/features/home/presentation/home_screen.dart';
import 'package:size_matter_swt/features/favorites/presentation/favorites_screen.dart';
import 'package:size_matter_swt/features/home/presentation/widgets/home_controller.dart';
import 'package:size_matter_swt/features/profile/presentation/profile_screen.dart';
import 'package:size_matter_swt/features/visited/presentation/visited_screen.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';

class NavberScreen extends StatefulWidget {
  final LocationCategory category;
  final LatLng? jumpPosition;
  final String? jumpName;
  final String? jumpAddress;
  final String? jumpType;
  final String? jumpOwnerName;
  final String? jumpPhone;
  final String? jumpItemId;
  final bool? jumpIsFavorite;
  final bool? jumpIsVisited;

  const NavberScreen({
    super.key,
    this.category = LocationCategory.farms,
    this.jumpPosition,
    this.jumpName,
    this.jumpAddress,
    this.jumpType,
    this.jumpOwnerName,
    this.jumpPhone,
    this.jumpItemId,
    this.jumpIsFavorite,
    this.jumpIsVisited,
  });

  @override
  State<NavberScreen> createState() => _NavberScreenState();
}

class _NavberScreenState extends State<NavberScreen> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(category: widget.category),
      VisitedScreen(
        category: widget.category,
        onJumpToMap: _openHomeAndHandlePendingJump,
      ),
      FavoritesScreen(
        category: widget.category,
        onJumpToMap: _openHomeAndHandlePendingJump,
      ),
      const ProfileScreen(),
    ];

    if (widget.jumpPosition != null) {
      homeController.pendingJump = (
        position: widget.jumpPosition!,
        name: widget.jumpName ?? '',
        address: widget.jumpAddress ?? '',
        type: widget.jumpType ?? '',
        ownerName: widget.jumpOwnerName ?? '',
        phone: widget.jumpPhone ?? '',
        itemId: widget.jumpItemId ?? '',
        initialIsFavourite: widget.jumpIsFavorite,
        initialIsVisited: widget.jumpIsVisited,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _openHomeAndHandlePendingJump();
      });
    }
  }

  void _openHomeAndHandlePendingJump() {
    if (!mounted) return;
    setState(() => _currentIndex = 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeController.checkPendingJumpCallback?.call();
    });
  }

  Color iconColor(int index) {
    return _currentIndex == index ? Colors.blue : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: homeController.isNavigating,
      builder: (context, isNavigating, child) {
        return PopScope(
          canPop: !isNavigating,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            if (isNavigating) {
              homeController.stopNavigationCallback?.call();
            }
          },
          child: Scaffold(
            body: IndexedStack(index: _currentIndex, children: _screens),
            bottomNavigationBar: isNavigating
                ? const SizedBox.shrink()
                : Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, -4),
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r),
                      ),
                      child: BottomNavigationBar(
                        currentIndex: _currentIndex,
                        type: BottomNavigationBarType.fixed,
                        onTap: (index) => setState(() => _currentIndex = index),
                        selectedItemColor: AppColors.c34A853,
                        unselectedItemColor: AppColors.c303030,
                        backgroundColor: AppColors.scaffoldColor,
                        items: [
                          BottomNavigationBarItem(
                            icon: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(Assets.icons.homeBlack),
                                UIHelper.verticalSpace(4.h),
                              ],
                            ),
                            activeIcon: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(Assets.icons.homeGreen),
                                UIHelper.verticalSpace(4.h),
                              ],
                            ),
                            label: 'Home',
                          ),
                          BottomNavigationBarItem(
                            icon: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(Assets.icons.visitedBlack),
                                UIHelper.verticalSpace(4.h),
                              ],
                            ),
                            activeIcon: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(Assets.icons.visitedGreen),
                                UIHelper.verticalSpace(4.h),
                              ],
                            ),
                            label: 'Visited',
                          ),
                          BottomNavigationBarItem(
                            icon: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Center(
                                  child: SvgPicture.asset(
                                    // height: 18.h,
                                    // width: 18.w,
                                    Assets.icons.favorites,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                UIHelper.verticalSpace(4.h),
                              ],
                            ),
                            activeIcon: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Center(
                                  child: SvgPicture.asset(
                                    Assets.icons.favorites,
                                    colorFilter: ColorFilter.mode(
                                      AppColors.c4C956C,
                                      BlendMode.srcIn,
                                    ),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                UIHelper.verticalSpace(4.h),
                              ],
                            ),
                            label: 'Favorites',
                          ),
                          BottomNavigationBarItem(
                            icon: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(Assets.icons.profile),
                                UIHelper.verticalSpace(4.h),
                              ],
                            ),
                            activeIcon: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(Assets.icons.profileGreen),
                                UIHelper.verticalSpace(4.h),
                              ],
                            ),
                            label: 'Profile',
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
