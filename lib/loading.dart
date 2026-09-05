import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:size_matter_swt/features/auth/presentation/signin/signin_screen.dart';
import 'package:size_matter_swt/features/first_screen/presentation/first_screen.dart';
import 'package:size_matter_swt/onboarding/onboarding_screen.dart';
import 'package:size_matter_swt/splash_screens/splash_screen.dart';

import 'constants/app_constants.dart';
import 'helpers/di.dart';
import 'helpers/helpers_method.dart';
import 'networks/dio/dio.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    await setInitValue();

    bool data = appData.read(kKeyIsLoggedIn) ?? false;
    if (data) {
      String token = appData.read(kKeyAccessToken);
      log("Token is ===========> $token");
      log("FCM Token is ===========> ${appData.read(kKeyFCMToken)}");
      // log("My role is ====================> ${appData.read(kKeyRole)}");
      DioSingleton.instance.update(token);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SplashScreen();
    } else {
      bool isLoggedIn = appData.read(kKeyIsLoggedIn) ?? false;
      bool isFirstTime = appData.read(kKeyIsFirstTime) ?? true;
      // bool isSubscribe = appData.read(kkeyisSubscribe) ?? false;

      if (isLoggedIn) {
        return const FirstScreen();
      } else {
        return isFirstTime ? const OnboardingScreen() : const SigninScreen();
      }
    }
  }
}
