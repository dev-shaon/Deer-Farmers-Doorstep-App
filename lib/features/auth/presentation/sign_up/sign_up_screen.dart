import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:size_matter_swt/common/a_g_container.dart';
import 'package:size_matter_swt/common/custom_button.dart';
import 'package:size_matter_swt/common/custom_form_field.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/constants/textfield_validation.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/all_routes.dart';
import 'package:size_matter_swt/helpers/loading_helper.dart';
import 'package:size_matter_swt/helpers/navigation_service.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';
import 'package:size_matter_swt/networks/api_access.dart';
import '../../../../helpers/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool passVisible = false;
  bool confirmPassVisible = false;
  bool isChecked = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController conPassController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    conPassController.dispose();
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

                  Text(
                    "Create an account",
                    style: TextFontStyle.headline24w700c303030Inter,
                  ),

                  UIHelper.verticalSpace(40.h),

                  CustomFormField(
                    validator: InputValidator.validateShopname,
                    controller: nameController,
                    hintText: "Shop Name",
                    prefixIcon: SvgPicture.asset(Assets.icons.person),
                  ),

                  UIHelper.verticalSpace(16.h),

                  CustomFormField(
                    validator: InputValidator.validateEmail,
                    controller: emailController,
                    hintText: "Username or email",
                    prefixIcon: SvgPicture.asset(Assets.icons.email),
                  ),

                  UIHelper.verticalSpace(16.h),

                  CustomFormField(
                    validator: InputValidator.validatePassword,
                    controller: passController,
                    hintText: "Password",
                    prefixIcon: SvgPicture.asset(Assets.icons.protect),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          passVisible = !passVisible;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.all(10.r),
                        child: SvgPicture.asset(
                          passVisible
                              ? Assets.icons.eyeOpen
                              : Assets.icons.eyeClose,
                        ),
                      ),
                    ),
                    isPass: true,
                    isObsecure: !passVisible,
                  ),

                  UIHelper.verticalSpace(16.h),

                  CustomFormField(
                    validator: (value) =>
                        InputValidator.validateConfirmPassword(
                          value,
                          passController.text,
                        ),
                    controller: conPassController,
                    hintText: "Confirm password",
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

                  UIHelper.verticalSpace(12.h),

                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isChecked = !isChecked;
                          });
                        },
                        child: SvgPicture.asset(
                          isChecked
                              ? Assets.icons.chakeBoxFilup
                              : Assets.icons.chakeBox,
                        ),
                      ),
                      UIHelper.horizontalSpace(6.w),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Agree to ',
                            style: TextFontStyle.headline14w400cADADADInter,
                          ),
                          GestureDetector(
                            onTap: () {
                              NavigationService.navigateTo(Routes.tarmsScreens);
                            },
                            child: Text(
                              'Terms of Service',
                              style: TextFontStyle.headline14w400cADADADInter
                                  .copyWith(color: AppColors.c34A853),
                            ),
                          ),
                          Text(
                            ' and ',
                            style: TextFontStyle.headline14w400cADADADInter,
                          ),
                          GestureDetector(
                            onTap: () {
                              NavigationService.navigateTo(Routes.policyScreen);
                            },
                            child: Text(
                              'Privacy Policy',
                              style: TextFontStyle.headline14w400cADADADInter
                                  .copyWith(color: AppColors.c34A853),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  UIHelper.verticalSpace(20.h),

                  CustomButton(
                    onTap: () {
                      if (!isChecked) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Please agree to Terms & Privacy Policy",
                            ),
                          ),
                        );
                        return;
                      }

                      if (_formKey.currentState!.validate()) {
                        debugPrint('Name: ${nameController.text}');
                        debugPrint('Email: ${emailController.text}');
                        debugPrint('Password: ${passController.text}');
                        debugPrint(
                          'Confirm Password: ${conPassController.text}',
                        );
                        signupRxobj
                            .signup(
                              name: nameController.text,
                              email: emailController.text,
                              password: passController.text,
                              passwordconfirmation: conPassController.text,
                            )
                            .waitingForSucess()
                            .then((success) {
                              if (success) {
                                NavigationService.popAndReplaceWihArgs(
                                  Routes.siginUpVerify,
                                  {"email": emailController.text},
                                );
                              }
                            });
                      }
                    },
                    btnName: "Sign Up",
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
                          text: 'Already have an account? ',
                          style: TextFontStyle.headline16w400c2C6E49Inter
                              .copyWith(color: AppColors.c7C7C7C),
                        ),
                        TextSpan(
                          text: 'Log In',
                          style: TextFontStyle.headline16w600c2C6E49Inter,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              NavigationService.navigateTo(Routes.signinScreen);
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
