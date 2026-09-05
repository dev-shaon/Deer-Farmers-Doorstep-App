// ignore_for_file: constant_identifier_names

const String url = "https://deerfarmersdoorstep.com/api";

final class NetworkConstants {
  NetworkConstants._();
  static const ACCEPT = "Accept";
  static const APP_KEY = "App-Key";
  static const ACCEPT_LANGUAGE = "Accept-Language";
  static const ACCEPT_LANGUAGE_VALUE = "pt";
  static const APP_KEY_VALUE = String.fromEnvironment("APP_KEY_VALUE");
  static const ACCEPT_TYPE = "application/json";
  static const AUTHORIZATION = "Authorization";
  static const CONTENT_TYPE = "content-Type";
}

final class EndPoints {
  EndPoints._();
  static String login() => "/v1/login";
  static String signup() => "/v1/register";
  static String verifySignupOtp() => "/v1/verify-email";
  static String resendOtp() => "/v1/resend-otp";
  static String logout() => "/v1/logout";
  static String forgotPass() => "/v1/forgot-password";
  static String forgetverifyotp() => "/v1/verify-otp";
  static String resendForgotOtp() => "/v1/password/resend-otp";
  static String resetPassword() => "/v1/reset-password";
  static String changepassword() => "/v1/change-password";
  static String updateAvatar() => "/v1/update-avatar";
  static String userDetails() => "/v1/profile";
  static String updateprofile() => "/v1/update-profile";
  static String refreshToken() => "/v1/refresh-token";
  static String farms() => "/v1/farms";
  static String ranches() => "/v1/ranche";
  static String events() => "/v1/events";
  static String favorites() => "/v1/favorites";
  static String visited() => "/v1/visited";
  static String postFavourites() => "/v1/favorites";
  static String postVisited() => "/v1/visited";
  static String deleteFavourites(String id) => "/v1/favorites/$id";
  static String deleteVisited(String id) => "/v1/visited/$id";
  static String searchFarms(String query) => "/v1/farms?search=$query";
  static String searchRanches(String query) => "/v1/ranche?search=$query";
  static String searchEvents(String query) => "/v1/events?search=$query";

  static String nearbyAds() => "/v1/ads/nearby";

  static String notifications() => "/v1/notifications";
  static String deleteNotification(String id) => "/v1/notifications/delete/$id";

  static String readNotification(String id) =>
      "/v1/notifications/$id/mark-as-read";

  static String markAllNotification() => "/v1/notifications/mark-all-as-read";

  static String getAllEvents() => "/v1/events";

  static String eventDetails(String id) => "/v1/events/$id";

  static String allNotes() => "/v1/notes";

  static String autoSaveNotes() => "/v1/notes/auto-save";

  static String showNotes(String id) => "/v1/notes/show/$id";

  static String deleteNotes(String id) => "/v1/notes/delete/$id";

  static String policy() => "/v1/privacy-policy";
  static String terms() => "/v1/terms-conditions";
  static String deleteAccount() => "/v1/delete-profile";

  static String socialLogin() => "/v1/social/signin";

  // static String appleSignIn() => "/v1/auth/apple";
}
