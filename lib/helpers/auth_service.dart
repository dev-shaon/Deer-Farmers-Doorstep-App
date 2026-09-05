import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:size_matter_swt/helpers/toast.dart';
import 'package:size_matter_swt/networks/api_access.dart';

import 'all_routes.dart';
import 'loading_helper.dart';
import 'navigation_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> initializeGoogleSignIn() async {
    await GoogleSignIn.instance.initialize(
      serverClientId:
          "674817529988-chsi85iuid7dt79fqaebt1ak1p9f12hi.apps.googleusercontent.com",
    );
  }

  Future<User?> signInWithGoogle() async {
    try {
      // Use the new v7 API: authenticate() instead of signIn()
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();

      // Get the authentication details (for idToken)
      final googleAuth = googleUser.authentication;

      // Get the authorization details (for accessToken)
      final List<String> scopes = ['email', 'profile'];
      final authClient = googleUser.authorizationClient;

      // Try to get existing authorization first to avoid duplicate prompts
      var authorization = await authClient.authorizationForScopes(scopes);
      if (authorization == null) {
        log('Requesting scopes authorization from user...');
        authorization = await authClient.authorizeScopes(scopes);
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: authorization.accessToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final User? user = userCredential.user;
      log('Google Sign-In successful: ${authorization.accessToken}');
      if (user != null) {
        log(' Firebase Auth successful: ${user.email}');
        log(' Google Sign-In successful: ${authorization.accessToken}');
        // socialLoginRx.socialLogin(token: authorization.accessToken);

        await socialLoginRxObj
            .socialLogin(
              accessToken: authorization.accessToken,
              provider: 'google',
            )
            .waitingForSucess()
            .then((success) {
              if (success) {
                final isSubscribe =
                    socialLoginRxObj
                        .dataFetcher
                        .value
                        .data
                        ?.user
                        ?.isSubscribe ??
                    false;
                if (isSubscribe) {
                  NavigationService.navigateToReplacementUntil(
                    Routes.firstScreen,
                  );
                } else {
                  NavigationService.navigateToReplacementUntil(
                    Routes.subscriptionScreen,
                  );
                }
              }
            });
      } else {
        signOut();
        ToastUtil.showErrorMessage('Login failed. Try again.');
      }

      return user;
    } catch (e) {
      log('Error in Google Sign In: $e');
      return null;
    }
  }

  Future<UserCredential?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create an OAuth credential from
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Print tokens
      debugPrint(" ID Token: ${appleCredential.identityToken}");
      debugPrint(" Authorization Code: ${appleCredential.authorizationCode}");

      // Sign in with Firebase
      final userCredential = await _auth.signInWithCredential(oauthCredential);

      final user = userCredential.user;

      if (user != null) {
        String? displayName = appleCredential.givenName != null
            ? "${appleCredential.givenName} ${appleCredential.familyName}"
            : user.displayName;
        String? email = appleCredential.email ?? user.email;

        debugPrint(" Apple Login Success:");
        debugPrint(" Display Name: $displayName");
        debugPrint(" Email: $email");
        debugPrint(" UID: ${user.uid}");
        debugPrint(" Photo URL: ${user.photoURL}");

        log(
          "Sending to backend: token: ${appleCredential.identityToken}, provider: apple",
        );
        bool isSuccess = await socialLoginRxObj
            .socialLogin(
              accessToken: appleCredential.identityToken ?? "",
              provider: "apple",
            )
            .waitingForSucess();

        if (isSuccess) {
          final isSubscribe =
              socialLoginRxObj.dataFetcher.value.data?.user?.isSubscribe ??
              false;
          if (isSubscribe) {
            NavigationService.navigateToReplacementUntil(Routes.firstScreen);
          } else {
            NavigationService.navigateToReplacementUntil(
              Routes.subscriptionScreen,
            );
          }
          ToastUtil.showLongToast('Login Successfully');
        } else {
          ToastUtil.showShortToast('Login Failed');
        }
      }

      // NavigationService.navigateToReplacement(Routes.bottomNavigation);

      return userCredential;
    } catch (e) {
      debugPrint("❌ Apple Sign-In Error: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await _auth.signOut();
  }
}
