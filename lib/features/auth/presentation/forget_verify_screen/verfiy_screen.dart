import 'dart:async';
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';
import 'package:size_matter_swt/common/custom_button.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/all_routes.dart';
import 'package:size_matter_swt/helpers/loading_helper.dart';
import 'package:size_matter_swt/helpers/navigation_service.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';
import 'package:size_matter_swt/networks/api_access.dart';

class VerfiyScreen extends StatefulWidget {
  final String email;

  const VerfiyScreen({super.key, required this.email});

  @override
  State<VerfiyScreen> createState() => _VerfiyScreenState();
}

class _VerfiyScreenState extends State<VerfiyScreen> {
  int _secondsRemaining = 10;
  Timer? _timer;
  bool _canResend = false;

  final TextEditingController otpController = TextEditingController();
  String otpCode = "";

  void _startTimer() {
    _secondsRemaining = 10;
    _canResend = false;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  void _resetPass() async {
    if (otpCode.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid 4 digit OTP")),
      );
      return;
    }

    await verifyForgetPassOtpRxobj
        .verifyOtp(email: widget.email, otp: otpCode)
        .waitingForSucess()
        .then((success) {
          if (success) {
            NavigationService.navigateToWithArgs(Routes.resetPasswordScreen, {
              'email': widget.email,
            });
          }
        });
  }

  void _resendOtp() async {
    if (!_canResend) return;
    try {
      final success = await resendForgotOtpRxobj.resend(email: widget.email);
      if (success) {
        _startTimer();
      }
    } catch (e) {
      log("Error resending OTP: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 75.w,
      height: 50.h,
      textStyle: TextFontStyle.headline20w700c303030Inter,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: AppColors.cADADAD),
        color: AppColors.cFFFFFF,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Check your email",
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

              Pinput(
                length: 4,
                controller: otpController,
                onChanged: (value) {
                  setState(() {
                    otpCode = value;
                  });
                },
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                ),
                preFilledWidget: Text(
                  '-',
                  style: TextFontStyle.headline14w400cADADADInter.copyWith(
                    color: AppColors.c303030,
                  ),
                ),
              ),

              UIHelper.verticalSpace(32.h),
              CustomButton(onTap: _resetPass, btnName: "Continue"),

              UIHelper.verticalSpace(20.h),
              RichText(
                text: TextSpan(
                  text: "Don't get any code? ",
                  style: TextFontStyle.headline14w400cADADADInter,
                  children: [
                    TextSpan(
                      text: _canResend
                          ? 'Resend'
                          : 'Resend - 0:${_secondsRemaining.toString().padLeft(2, '0')}',
                      style: TextFontStyle.headline14w600c000000Inter.copyWith(
                        color: _canResend
                            ? AppColors.c303030
                            : AppColors.cADADAD,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = _resendOtp,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
