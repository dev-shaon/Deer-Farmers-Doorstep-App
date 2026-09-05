import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:size_matter_swt/common/a_g_container.dart';
import 'package:size_matter_swt/common/custom_button.dart';
import 'package:size_matter_swt/common/custom_form_field.dart';
import 'package:size_matter_swt/constants/app_constants.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/constants/textfield_validation.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/all_routes.dart';
import 'package:size_matter_swt/helpers/di.dart';
import 'package:size_matter_swt/helpers/loading_helper.dart';
import 'package:size_matter_swt/helpers/navigation_service.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';
import 'package:size_matter_swt/networks/api_access.dart';

import '../../../../helpers/auth_service.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  bool passwordVisible = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  UIHelper.verticalSpace(36.h),
                  Center(
                    child: Text(
                      "Welcome back",
                      style: TextFontStyle.headline24w700c303030Inter,
                    ),
                  ),
                  UIHelper.verticalSpace(4.h),
                  Center(
                    child: Text(
                      "Log In to your existing account",
                      style: TextFontStyle.headline16w500c303030Inter,
                    ),
                  ),
                  UIHelper.verticalSpace(40.h),
                  CustomFormField(
                    controller: emailController,
                    validator: InputValidator.validateEmail,
                    hintText: "Username or email",
                    prefixIcon: SvgPicture.asset(Assets.icons.email),
                  ),
                  UIHelper.verticalSpace(16.h),

                  CustomFormField(
                    controller: passController,
                    validator: InputValidator.validatePassword,
                    hintText: "Password",
                    prefixIcon: SvgPicture.asset(Assets.icons.protect),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.all(10.r),
                        child: SvgPicture.asset(
                          passwordVisible
                              ? Assets.icons.eyeOpen
                              : Assets.icons.eyeClose,
                        ),
                      ),
                    ),
                    isPass: true,
                    isObsecure: !passwordVisible,
                  ),
                  UIHelper.verticalSpace(12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          NavigationService.navigateTo(Routes.forgotScreen);
                        },
                        child: Text(
                          "Forget password?",
                          style: TextFontStyle.headline14w400cADADADInter
                              .copyWith(
                                color: AppColors.c34A853,
                                decoration: TextDecoration.underline,
                              ),
                        ),
                      ),
                    ],
                  ),
                  UIHelper.verticalSpace(20.h),
                  CustomButton(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        debugPrint('Email: ${emailController.text}');
                        debugPrint('Password: ${passController.text}');
                        loginRxobj
                            .login(
                              email: emailController.text,
                              password: passController.text,
                            )
                            .waitingForSucess()
                            .then((success) {
                              if (success) {
                                final isSubscribe =
                                    loginRxobj
                                        .dataFetcher
                                        .value
                                        .data
                                        ?.user
                                        ?.isSubscribe ??
                                    false;

                                appData.write(kkeyisSubscribe, isSubscribe);

                                NavigationService.navigateToReplacementUntil(
                                  Routes.firstScreen,
                                );
                              }
                            });
                      }
                    },
                    btnName: "Log In",
                  ),
                  UIHelper.verticalSpace(43.h),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '────────  ',
                          style: TextStyle(color: AppColors.cADADAD),
                        ),
                        TextSpan(
                          text: 'Or',
                          style: TextFontStyle.headline12w300c303030Inter,
                        ),
                        TextSpan(
                          text: '  ────────',
                          style: TextStyle(color: AppColors.cADADAD),
                        ),
                      ],
                    ),
                  ),

                  UIHelper.verticalSpace(43.h),
                  AGContainer(
                    onAppleTap: () {
                      _authService.signInWithApple();
                    },
                    onGoogleTap: () async {
                      _authService.signInWithGoogle();
                    },
                  ),
                  UIHelper.verticalSpace(20.h),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Don’t have an account? ',
                          style: TextFontStyle.headline16w400c2C6E49Inter
                              .copyWith(color: AppColors.c7C7C7C),
                        ),
                        TextSpan(
                          text: 'Sign Up',
                          style: TextFontStyle.headline16w600c2C6E49Inter,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              NavigationService.navigateTo(Routes.signUpScreen);
                            },
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
    );
  }
}
