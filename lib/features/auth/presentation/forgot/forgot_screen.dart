import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:size_matter_swt/common/custom_button.dart';
import 'package:size_matter_swt/common/custom_form_field.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/constants/textfield_validation.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/helpers/all_routes.dart';
import 'package:size_matter_swt/helpers/loading_helper.dart';
import 'package:size_matter_swt/helpers/navigation_service.dart';
import 'package:size_matter_swt/helpers/toast.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';
import 'package:size_matter_swt/networks/api_access.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final TextEditingController emailcontroller = TextEditingController();
  @override
  void dispose() {
    emailcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Enter your email",
          style: TextFontStyle.headline24w700c303030Inter,
        ),
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.all(10.r),
          child: InkWell(
            onTap: () {
              NavigationService.goBack();
            },
            child: SvgPicture.asset(Assets.icons.arrowLeft),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            children: [
              UIHelper.verticalSpace(20.h),
              CustomFormField(
                controller: emailcontroller,
                validator: InputValidator.validateEmail,
                hintText: "Username or email",
                prefixIcon: SvgPicture.asset(Assets.icons.email),
              ),
              UIHelper.verticalSpace(32.h),
              CustomButton(
                onTap: () {
                  forgetPassRxobj
                      .forgetPass(email: emailcontroller.text)
                      .waitingForSucess()
                      .then((success) {
                        if (success) {
                          ToastUtil.showLongToast("OTP sent your email");
                          NavigationService.navigateToWithArgs(
                            Routes.verfiyScreen,
                            {'email': emailcontroller.text},
                          );
                        }
                      });

                  // log(emailController.text);
                },
                btnName: "Continue",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
