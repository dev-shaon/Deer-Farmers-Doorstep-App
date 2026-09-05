// ignore_for_file: unused_element

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:size_matter_swt/features/Tarms%20&%20Policy/terms_screens.dart';
import 'package:size_matter_swt/features/Tarms%20&%20Policy/policy_screen.dart';
import 'package:size_matter_swt/features/auth/presentation/forgot/forgot_screen.dart';
import 'package:size_matter_swt/features/auth/presentation/reset_pass/reset_password_screen.dart';
import 'package:size_matter_swt/features/auth/presentation/sign_up/sigin_up_verify.dart';
import 'package:size_matter_swt/features/auth/presentation/sign_up/sign_up_screen.dart';
import 'package:size_matter_swt/features/auth/presentation/signin/signin_screen.dart';
import 'package:size_matter_swt/features/auth/presentation/forget_verify_screen/verfiy_screen.dart';
import 'package:size_matter_swt/features/change_password/presentation/change_password.dart';
import 'package:size_matter_swt/features/event_list/presentration/event_list_screen.dart';
import 'package:size_matter_swt/features/favorites/presentation/details_screen.dart';
import 'package:size_matter_swt/features/first_screen/presentation/first_screen.dart';
import 'package:size_matter_swt/features/navber_screen.dart';
import 'package:size_matter_swt/features/navigation_screen.dart';
import 'package:size_matter_swt/features/notes/presentration/add_notes.dart';
import 'package:size_matter_swt/features/notes/presentration/notes_screen.dart';
import 'package:size_matter_swt/features/notification/presentration/notification_screen.dart';
import 'package:size_matter_swt/features/profile/edit_profile_screen.dart';
import 'package:size_matter_swt/features/search/presentation/search_screen.dart';
import 'package:size_matter_swt/features/subscription/presentartion/subscription_screen.dart';
import 'package:size_matter_swt/features/subscription/presentartion/upgrade_subscription_screen.dart';
import 'package:size_matter_swt/onboarding/onboarding_screen.dart';

import '../constants/location_category.dart';

final class Routes {
  static final Routes _routes = Routes._internal();
  Routes._internal();
  static Routes get instance => _routes;
  static const String navigationScreen = '/navigation_screen';
  static const String onboardingSlaid = '/onboardingSlaid';
  static const String signinScreen = '/signinScreen';
  static const String signUpScreen = '/signUpScreen';
  static const String forgotScreen = '/forgotScreen';
  static const String verfiyScreen = '/verfiyScreen';
  static const String resetPasswordScreen = '/resetPasswordScreen';
  static const String policyScreen = '/policyScreen';
  static const String tarmsScreens = '/tarmsScreens';
  static const String firstScreen = '/firstScreen';
  static const String navberScreen = '/navberScreen';
  static const String editProfileScreen = '/editProfileScreen';
  static const String changePassword = '/changePassword';
  static const String notificationScreen = '/notificationScreen';
  static const String searchScreen = '/searchScreen';
  static const String detailsScreen = '/detailsScreen';
  static const String siginUpVerify = '/siginUpVerify';
  static const String subscriptionScreen = '/subscriptionScreen';
  static const String eventListScreen = '/eventListScreen';
  static const String notesScreen = '/notesScreen';
  static const String addNotes = '/addNotes';
  static const String upgradeSubscriptionScreen = '/upgradeSubscriptionScreen';
}

final class RouteGenerator {
  static final RouteGenerator _routeGenerator = RouteGenerator._internal();
  RouteGenerator._internal();
  static RouteGenerator get instance => _routeGenerator;

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.navigationScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const NavigationScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => const NavigationScreen(),
              );

      case Routes.onboardingSlaid:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const OnboardingScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => const OnboardingScreen(),
              );

      case Routes.signinScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const SigninScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => const SigninScreen());

      case Routes.signUpScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const SignUpScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => const SignUpScreen());

      case Routes.forgotScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const ForgotScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => const ForgotScreen());

      case Routes.verfiyScreen:
        final args = settings.arguments as Map;
        final String email = args['email'];
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: VerfiyScreen(email: email),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => VerfiyScreen(email: email),
              );

      case Routes.resetPasswordScreen:
        final args = settings.arguments as Map;
        final String email = args['email'];
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: ResetPasswordScreen(email: email),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => ResetPasswordScreen(email: email),
              );

      case Routes.policyScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const PolicyScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => const PolicyScreen());

      case Routes.tarmsScreens:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const TermsScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => const TermsScreen());

      case Routes.firstScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const FirstScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => const FirstScreen());

      case Routes.navberScreen:
        final args = settings.arguments as Map? ?? {}; // null-safe cast
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: NavberScreen(
                  category: args['category'] ?? LocationCategory.farms,
                  jumpPosition: args['jumpPosition'],
                  jumpName: args['jumpName'],
                  jumpAddress: args['jumpAddress'],
                  jumpType: args['jumpType'],
                  jumpOwnerName: args['jumpOwnerName'],
                  jumpPhone: args['jumpPhone'],
                  jumpItemId: args['jumpItemId'],
                  jumpIsFavorite: args['jumpIsFavorite'],
                  jumpIsVisited: args['jumpIsVisited'],
                ),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => NavberScreen(
                  category: args['category'] ?? LocationCategory.farms,
                  jumpPosition: args['jumpPosition'],
                  jumpName: args['jumpName'],
                  jumpAddress: args['jumpAddress'],
                  jumpType: args['jumpType'],
                  jumpOwnerName: args['jumpOwnerName'],
                  jumpPhone: args['jumpPhone'],
                  jumpItemId: args['jumpItemId'],
                  jumpIsFavorite: args['jumpIsFavorite'],
                  jumpIsVisited: args['jumpIsVisited'],
                ),
              );

      case Routes.editProfileScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const EditProfileScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => const EditProfileScreen(),
              );

      case Routes.changePassword:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const ChangePassword(),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => const ChangePassword());

      case Routes.notificationScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const NotificationScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => const NotificationScreen(),
              );

      case Routes.searchScreen:
        final args = (settings.arguments as Map? ?? {});
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: SearchScreen(
                  category: args['category'] ?? LocationCategory.farms,
                ),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => SearchScreen(
                  category: args['category'] ?? LocationCategory.farms,
                ),
              );

      case Routes.detailsScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const DetailsScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => const DetailsScreen());

      case Routes.siginUpVerify:
        final args = settings.arguments as Map;
        final String email = args['email'];
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: SiginUpVerify(email: email),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => SiginUpVerify(email: email),
              );

      case Routes.subscriptionScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const SubscriptionScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => const SubscriptionScreen(),
              );

      case Routes.eventListScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const EventListScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => const EventListScreen());

      case Routes.notesScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const NotesScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => const NotesScreen());

      case Routes.upgradeSubscriptionScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const UpgradeSubscriptionScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => const UpgradeSubscriptionScreen());

      case Routes.addNotes:
        final args = settings.arguments as Map? ?? {};
        final int? noteId = args['noteId'];
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: AddNotes(noteId: noteId),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => AddNotes(noteId: noteId),
              );

      default:
        return null;
    }
  }
}

class _FadedTransitionRoute extends PageRouteBuilder {
  final Widget widget;
  @override
  final RouteSettings settings;

  _FadedTransitionRoute({required this.widget, required this.settings})
    : super(
        settings: settings,
        reverseTransitionDuration: const Duration(milliseconds: 1),
        pageBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return widget;
            },
        transitionDuration: const Duration(milliseconds: 1),
        transitionsBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              return FadeTransition(
                opacity: CurvedAnimation(parent: animation, curve: Curves.ease),
                child: child,
              );
            },
      );
}

class ScreenTitle extends StatelessWidget {
  final Widget widget;

  const ScreenTitle({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: .5, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.bounceIn,
      builder: (context, value, child) {
        return Opacity(opacity: value, child: child);
      },
      child: widget,
    );
  }
}
