import 'package:auto_animated/auto_animated.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:size_matter_swt/constants/custome_theme.dart';
import 'package:size_matter_swt/firebase_options.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/all_routes.dart';
import 'package:size_matter_swt/helpers/di.dart';
import 'package:size_matter_swt/helpers/helpers_method.dart';
import 'package:size_matter_swt/helpers/navigation_service.dart';
import 'package:size_matter_swt/features/subscription/data/subscription_service.dart';
import 'package:size_matter_swt/helpers/register_provider.dart';
import 'package:size_matter_swt/loading.dart';
import 'package:size_matter_swt/networks/dio/dio.dart';

import 'helpers/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  await AuthService().initializeGoogleSignIn();
  await SubscriptionService.initialize();

  diSetUp();

  DioSingleton.instance.create();

  // try {
  //   if (Platform.isIOS &&
  //       Platform.environment.containsKey('SIMULATOR_DEVICE_NAME')) {
  //     log('Running on an iOS simulator. Skipping high refresh rate setting.');
  //   } else {
  //     await FlutterDisplayMode.setHighRefreshRate();
  //     log('High refresh rate mode set successfully.');
  //   }
  // } catch (e) {
  //   log('Error setting high refresh rate: $e');
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    rotation();
    setInitValue();
    return MultiProvider(
      providers: providers,
      child: AnimateIfVisibleWrapper(
        showItemInterval: const Duration(milliseconds: 150),
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, dynamic result) async {
            // showMaterialDialog(context);
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return const UtillScreenMobile();
            },
          ),
        ),
      ),
    );
  }
}

class UtillScreenMobile extends StatelessWidget {
  const UtillScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Priche',
          theme: ThemeData(
            primarySwatch: CustomTheme.kToDark,
            primaryColor: AppColors.allPrimaryColor,
            useMaterial3: false,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.scaffoldColor,
              elevation: 0,
              foregroundColor: AppColors.c000000,
            ),
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: AppColors.allPrimaryColor,
            ),
            scaffoldBackgroundColor: AppColors.scaffoldColor,
          ),
          builder: (context, widget) {
            return MediaQuery(data: MediaQuery.of(context), child: widget!);
          },
          navigatorKey: NavigationService.navigatorKey,
          onGenerateRoute: RouteGenerator.generateRoute,
          home: const Loading(),
        );
      },
    );
  }
}
