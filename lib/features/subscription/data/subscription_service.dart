import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:size_matter_swt/constants/app_constants.dart';

class SubscriptionService {
  // Replace these placeholders with your actual RevenueCat API keys
  static const String _googleApiKey = "goog_NRjYXZzMXoVeqIwjHRPurOZWqeT";
  static const String _appleApiKey = "appl_zzxReTKYhQGfJWkxSxrLYRiScwQ";

  static Future<void> initialize() async {
    // purchases_flutter only supports Android and iOS. Guarding against Web or other platforms.
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      return;
    }

    if (kDebugMode) {
      await Purchases.setLogLevel(LogLevel.debug);
    }

    PurchasesConfiguration configuration;

    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(_googleApiKey);
    } else {
      configuration = PurchasesConfiguration(_appleApiKey);
    }

    final box = GetStorage();
    final bool isLoggedIn = box.read(kKeyIsLoggedIn) ?? false;
    final String? userId = box.read(kKeyUserId);
    if (isLoggedIn && userId != null && userId.isNotEmpty) {
      configuration.appUserID = userId;
    }

    await Purchases.configure(configuration);
  }

  static Future<void> logIn(String userId) async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return;
    try {
      await Purchases.logIn(userId);
    } catch (e) {
      debugPrint("Error logging into Purchases: $e");
    }
  }

  static Future<void> logOut() async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return;
    try {
      await Purchases.logOut();
    } catch (e) {
      debugPrint("Error logging out of Purchases: $e");
    }
  }
}
