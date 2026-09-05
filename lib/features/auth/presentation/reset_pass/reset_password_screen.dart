import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:size_matter_swt/common/custom_button.dart';
import 'package:size_matter_swt/common/custom_form_field.dart';
import 'package:size_matter_swt/constants/app_constants.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/constants/textfield_validation.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/helpers/all_routes.dart';
import 'package:size_matter_swt/helpers/di.dart';
import 'package:size_matter_swt/helpers/loading_helper.dart';
import 'package:size_matter_swt/helpers/navigation_service.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';
import 'package:size_matter_swt/networks/api_access.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newpassController = TextEditingController();
  final TextEditingController _conpassController = TextEditingController();
  bool newPassVisible = false;
  bool confirmPassVisible = false;
  bool isChecked = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Change password",
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                UIHelper.verticalSpace(40.h),

                CustomFormField(
                  controller: _newpassController,
                  validator: InputValidator.validatePassword,
                  hintText: "New Password",
                  prefixIcon: SvgPicture.asset(Assets.icons.protect),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        newPassVisible = !newPassVisible;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10.r),
                      child: SvgPicture.asset(
                        newPassVisible
                            ? Assets.icons.eyeOpen
                            : Assets.icons.eyeClose,
                      ),
                    ),
                  ),
                  isPass: true,
                  isObsecure: !newPassVisible,
                ),

                UIHelper.verticalSpace(16.h),

                CustomFormField(
                  controller: _conpassController,
                  validator: (value) => InputValidator.validateConfirmPassword(
                    value,
                    _newpassController.text,
                  ),
                  hintText: "Confirm new password",
                  prefixIcon: SvgPicture.asset(Assets.icons.protect),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        confirmPassVisible = !confirmPassVisible;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: SvgPicture.asset(
                        confirmPassVisible
                            ? Assets.icons.eyeOpen
                            : Assets.icons.eyeClose,
                      ),
                    ),
                  ),
                  isPass: true,
                  isObsecure: !confirmPassVisible,
                ),

                UIHelper.verticalSpace(32.h),

                CustomButton(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      await resetPasswordRxobj
                          .resetPassword(
                            email: widget.email,
                            token: appData.read(kkeyForgetOtpToken),
                            confirmPassword: _conpassController.text,
                            password: _newpassController.text,
                          )
                          .waitingForSucess()
                          .then((success) {
                            if (success) {
                              NavigationService.navigateToReplacementUntil(
                                Routes.signinScreen,
                              );
                            }
                          });
                    }
                  },
                  btnName: "Continue",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
