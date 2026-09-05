import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:size_matter_swt/common/custom_button.dart';
import 'package:size_matter_swt/common/custom_form_field.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/constants/textfield_validation.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/helpers/loading_helper.dart';
import 'package:size_matter_swt/helpers/navigation_service.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';
import 'package:size_matter_swt/networks/api_access.dart';
import 'package:size_matter_swt/helpers/toast.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _oldpassController = TextEditingController();
  final TextEditingController _newpassController = TextEditingController();
  final TextEditingController _conpassController = TextEditingController();
  bool oldPassVisible = false;
  bool newPassVisible = false;
  bool confirmPassVisible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _oldpassController.dispose();
    _newpassController.dispose();
    _conpassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          "Change Password",
          style: TextFontStyle.headline24w700c303030Inter,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.r),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              UIHelper.verticalSpace(30.h),

              CustomFormField(
                validator: InputValidator.validatePassword,
                controller: _oldpassController,
                hintText: "Old Password",
                prefixIcon: SvgPicture.asset(Assets.icons.protect),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      oldPassVisible = !oldPassVisible;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10.r),
                    child: SvgPicture.asset(
                      oldPassVisible
                          ? Assets.icons.eyeOpen
                          : Assets.icons.eyeClose,
                    ),
                  ),
                ),
                isPass: true,
                isObsecure: !oldPassVisible,
              ),

              UIHelper.verticalSpace(12.h),

              CustomFormField(
                validator: InputValidator.validatePassword,
                controller: _newpassController,
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

              UIHelper.verticalSpace(12.h),

              CustomFormField(
                validator: (value) => InputValidator.validateConfirmPassword(
                  value,
                  _newpassController.text,
                ),
                controller: _conpassController,
                hintText: "Confirm New Password",
                prefixIcon: SvgPicture.asset(Assets.icons.protect),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      confirmPassVisible = !confirmPassVisible;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10.r),
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

              const Spacer(),
              CustomButton(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    await changePasswordRxobj
                        .changePassword(
                          oldPassword: _oldpassController.text,
                          newPassword: _newpassController.text,
                          confirmPassword: _conpassController.text,
                        )
                        .waitingForSucess()
                        .then((success) {
                          if (success) {
                            ToastUtil.showSuccessMessage(
                              "Password changed successfully",
                            );
                            NavigationService.goBack();
                          }
                        });
                  }
                },
                btnName: "Save",
              ),
              UIHelper.verticalSpace(20.h),
            ],
          ),
        ),
      ),
    );
  }
}
