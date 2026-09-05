import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Package> _packages = [];
  List<Package> get packages => _packages;

  bool _isPremium = false;
  bool get isPremium => _isPremium;

  SubscriptionProvider() {
    _init();
    // Listen to RevenueCat customer info updates (e.g. after login, purchase, or webhook)
    Purchases.addCustomerInfoUpdateListener((customerInfo) {
      log('[RC Listener] CustomerInfo updated. Active entitlements: ${customerInfo.entitlements.active.keys.toList()}');
      _isPremium =
          customerInfo.entitlements.active.isNotEmpty ||
          (customerInfo.entitlements.all['Deer Farmers Doorstep Pro']?.isActive ?? false);
      log('[RC Listener] isPremium set to: $_isPremium');
      notifyListeners();
    });
  }

  Future<void> _init() async {
    await checkSubscriptionStatus();
    // Small delay so BillingClient finishes its initial connection before
    // we hit the store — prevents "BillingWrapper is not attached to a listener".
    await Future.delayed(const Duration(seconds: 1));
    await loadOfferings();
  }

  /// Call this right after SubscriptionService.logIn() to refresh state for the new user.
  Future<void> refreshAfterLogin() async {
    log('[SubscriptionProvider] refreshAfterLogin called');
    await checkSubscriptionStatus();
    await loadOfferings();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> checkSubscriptionStatus() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      _isPremium =
          customerInfo.entitlements.active.isNotEmpty ||
          (customerInfo
                  .entitlements
                  .all['Deer Farmers Doorstep Pro']
                  ?.isActive ??
              false);
      notifyListeners();
    } catch (e) {
      log("Error checking subscription status: $e");
    }
  }

  Future<void> loadOfferings({int maxRetries = 3}) async {
    _setLoading(true);
    int attempt = 0;
    while (attempt < maxRetries) {
      try {
        attempt++;
        log('[SubscriptionProvider] loadOfferings attempt $attempt/$maxRetries');
        final Offerings offerings = await Purchases.getOfferings();
        if (offerings.current != null) {
          _packages = offerings.current!.availablePackages;
          log('[SubscriptionProvider] Loaded ${_packages.length} packages');
        } else {
          log('[SubscriptionProvider] No current offering found');
        }
        break; // success — exit retry loop
      } catch (e) {
        log('Error loading offerings (attempt $attempt): $e');
        if (attempt < maxRetries) {
          // Wait 2 seconds before retrying to allow BillingClient to stabilize
          await Future.delayed(const Duration(seconds: 2));
        }
      }
    }
    _setLoading(false);
    notifyListeners();
  }

  Future<bool> purchasePackage(Package package) async {
    _setLoading(true);
    try {
      final PurchaseResult result = await Purchases.purchase(
        PurchaseParams.package(package),
      );

      _isPremium =
          result.customerInfo.entitlements.active.isNotEmpty ||
          (result
                  .customerInfo
                  .entitlements
                  .all['Deer Farmers Doorstep Pro']
                  ?.isActive ??
              false);

      notifyListeners();

      Fluttertoast.showToast(
        msg: "✅ Purchase successful! isPremium: $_isPremium",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );

      return _isPremium;
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);

      log(
        "Purchase failed - Code: $errorCode, Message: ${e.message}, Details: ${e.details}",
      );

      Fluttertoast.showToast(
        msg: "❌ Code: $errorCode\nMsg: ${e.message}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );

      return false;
    } catch (e) {
      log("Unknown purchase error: $e");

      Fluttertoast.showToast(
        msg: "❌ Unknown error: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );

      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> restorePurchases() async {
    _setLoading(true);
    try {
      CustomerInfo customerInfo = await Purchases.restorePurchases();
      _isPremium =
          customerInfo.entitlements.active.isNotEmpty ||
          (customerInfo
                  .entitlements
                  .all['Deer Farmers Doorstep Pro']
                  ?.isActive ??
              false);
      notifyListeners();

      Fluttertoast.showToast(
        msg: "✅ Restore successful! isPremium: $_isPremium",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );

      return _isPremium;
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);

      log("Restore failed - Code: $errorCode, Message: ${e.message}");

      Fluttertoast.showToast(
        msg: "❌ Restore failed\nCode: $errorCode\nMsg: ${e.message}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );

      return false;
    } catch (e) {
      log("Unknown restore error: $e");

      Fluttertoast.showToast(
        msg: "❌ Unknown restore error: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );

      return false;
    } finally {
      _setLoading(false);
    }
  }
}
