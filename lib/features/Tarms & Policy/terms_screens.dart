import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/features/Tarms%20&%20Policy/model/tarm_condition_model.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/helpers/navigation_service.dart';
import 'package:size_matter_swt/networks/api_access.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  @override
  void initState() {
    super.initState();
    termsRxObj.termsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFDF5),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Terms & Conditions",
          style: TextFontStyle.headline24w700c303030Inter,
        ),
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: InkWell(
            onTap: () => NavigationService.goBack(),
            child: SvgPicture.asset(Assets.icons.arrowBack),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: termsRxObj.getTermsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          }

          TarmConditionModel response = snapshot.data;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            child: Html(
              data: response.data?.content ?? '<p>No content available</p>',
              style: {
                "h2": Style.fromTextStyle(
                  TextFontStyle.headline20w700c303030Inter,
                ),
                "h3": Style.fromTextStyle(
                  TextFontStyle.headline16w500cADADADInter,
                ),
                "p": Style.fromTextStyle(
                  TextFontStyle.headline16w600c303030Inter,
                ),
                "br": Style.fromTextStyle(
                  TextFontStyle.headline14w400cADADADInter,
                ),
                "small": Style.fromTextStyle(
                  TextFontStyle.headline20w600cFFFFFFInter,
                ),
              },
            ),
          );
        },
      ),
    );
  }
}
