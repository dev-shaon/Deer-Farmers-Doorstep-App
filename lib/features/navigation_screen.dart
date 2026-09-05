
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:size_matter_swt/common/custom_form_field.dart';
import 'package:size_matter_swt/features/first_screen/presentation/first_screen.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';



import 'package:size_matter_swt/networks/api_access.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  bool _isSearching = false;
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    notificationRxObj.getNotificationData();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: double.maxFinite,
          width: double.maxFinite,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFEEE3D7), Color(0xFFE9CDC8)],
            ),
          ),
          child: Stack(
            children: [
              // Positioned(
              //   left: -66.w,
              //   top: -35.h,
              //   child: Image.asset(Assets.images.babyImage.path, height: 170.h),
              // ),

              Positioned(
                top: kToolbarHeight + 8.h,
                right: 8.w,
                left: 8.w,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: _isSearching
                      ? Row(
                          children: [
                            /// Menu icon on the left
                           
                            // SizedBox(width: 8.w),

                            /// Search text field
                            Expanded(
                              child: CustomFormField(
                                focusNode: _searchFocusNode,
                                controller: _searchController,
                                fillColor: AppColors.c34A853,
                                borderRadius: 26.w,
                                hintText: "Search Time Capsule...",
                                textInputAction: TextInputAction.search,
                              ),
                            ),
                            // SizedBox(width: 8.w),
                            UIHelper.horizontalSpace(10.h),

                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isSearching = false;
                                  _searchController.clear();
                                });
                                _searchFocusNode.unfocus();
                              },
                              child: const Icon(Icons.close, size: 26),
                            ),
                            UIHelper.horizontalSpace(6.h),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            /// Menu icon on the right
                            
                          ],
                        ),
                ),
              ),

              Positioned(
                top: kToolbarHeight + 70.h,
                left: 0,
                right: 0,
                bottom: 70.h, // Leave space for bottom navigation bar
                child: FirstScreen(),
              ),

              Positioned(bottom: 0, child: _buildBottomNavigationBar()),
            ],
          ),
        ),
        // bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Stack(
      children: [
        CustomPaint(
          size: Size(MediaQuery.of(context).size.width, 100.h),
          painter: _BottomCurvePainter(),
        ),
        Positioned(
          bottom: 30.h,
          left: 20.w,
          right: 20.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  
                },
                child: SvgPicture.asset(
                  Assets.icons.person,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFFEEE3D7),
                    BlendMode.srcIn,
                  ),
                  width: 64.w,
                ),
              ),
              Row(
                children: [
                  // _buildIcon(Assets.icons.clockIcon),
                  // SizedBox(width: 12.w),
                  InkWell(
                    onTap: () {
                    },
                    // child: _buildIcon(Assets.icons.shareIcon),
                  ),
                  SizedBox(width: 12.w),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isSearching = true;
                      });
                      // Wait for the next frame to ensure widget is built
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _searchFocusNode.requestFocus();
                      });
                    },
                    child: _buildIcon(Assets.icons.person),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIcon(String icon) {
    return SvgPicture.asset(icon);
  }
}

class _BottomCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.allPrimaryColor
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(0, size.height * 0.001);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.4,
      size.width * 0.5,
      size.height * 0.2,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      0,
      size.width,
      size.height * 0.25,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
