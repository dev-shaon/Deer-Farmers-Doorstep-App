import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/features/following/presentation/widget/following_list.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:tc_mcandy/gen/assets.gen.dart';
// import 'package:tc_mcandy/helpers/ui_helpers.dart';

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({super.key});

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Following",
          style: TextFontStyle.headline16w600c303030Inter,
        ),
        centerTitle: true,
        backgroundColor: AppColors.cEA4335,
        elevation: 7,
        shadowColor: AppColors.c2C6E49.withValues(alpha: 0.1),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            // Center(
            //   child: Padding(
            //     padding: EdgeInsets.all(20.r),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         SvgPicture.asset(Assets.icons.runStar),
            //         UIHelper.verticalSpace(16.h),
            //         Text(
            //           "Keep up with your favorite stars",
            //           style: TextFontStyle.headline18w600c303030urbanist,
            //         ),
            //         UIHelper.verticalSpaceMedium,
            //         Text(
            //           "Follow talent for exclusive updates, quick access, and easy booking.",
            //           style: TextFontStyle.headline16w500c202020urbanist.copyWith(
            //             color: AppColors.c7C7C7C,
            //           ),
            //           textAlign: TextAlign.center,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
        
          
          ListView.builder(
            itemCount: 14,
            shrinkWrap: true,
            physics:  NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  FollowingList(
                    name: 'Phillip Septimus', 
                    role: 'Actress'
                  ),
                  Divider(color: AppColors.cADADAD, height: 2.h),
                ],
              );
            },
          ),
          
          ],
        ),
      ),
    );
  }
}
