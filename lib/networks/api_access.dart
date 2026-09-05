import 'package:rxdart/rxdart.dart';
import 'package:size_matter_swt/features/Tarms%20&%20Policy/data/get_policy/rx.dart';
import 'package:size_matter_swt/features/Tarms%20&%20Policy/data/get_tarms/rx.dart';
import 'package:size_matter_swt/features/Tarms%20&%20Policy/model/privacy_policy_model.dart';
import 'package:size_matter_swt/features/Tarms%20&%20Policy/model/tarm_condition_model.dart';
import 'package:size_matter_swt/features/auth/data/social_login/rx.dart';
import 'package:size_matter_swt/features/change_password/data/rx.dart';
import 'package:size_matter_swt/features/auth/data/forget_resent_otp/rx.dart';
import 'package:size_matter_swt/features/auth/data/logout/rx.dart';
import 'package:size_matter_swt/features/auth/data/resent_otp/rx.dart';
import 'package:size_matter_swt/features/auth/data/reset_password/rx.dart';
import 'package:size_matter_swt/features/auth/data/rx_forget_pass/rx.dart';
import 'package:size_matter_swt/features/auth/data/rx_login/rx.dart';
import 'package:size_matter_swt/features/auth/data/verify_forget_otp/rx.dart';
import 'package:size_matter_swt/features/auth/model/login_response.dart';
import 'package:size_matter_swt/features/event_list/data/get_all_event/rx.dart';

import 'package:size_matter_swt/features/favorites/data/rx.dart';
import 'package:size_matter_swt/features/favorites/model/favourite_model.dart';
import 'package:size_matter_swt/features/home/data/post_favourite/rx.dart';
import 'package:size_matter_swt/features/notes/data/add_note/rx.dart';
import 'package:size_matter_swt/features/notes/data/delete_notes/rx.dart';
import 'package:size_matter_swt/features/notes/data/get_all_note/rx.dart';
import 'package:size_matter_swt/features/notes/data/details_note/rx.dart';
import 'package:size_matter_swt/features/notes/model/all_note_model.dart';
import 'package:size_matter_swt/features/notes/model/note_details_model.dart';
import 'package:size_matter_swt/features/notification/data/delete_notification/rx.dart';
import 'package:size_matter_swt/features/notification/data/get_all_notification/rx.dart';
import 'package:size_matter_swt/features/notification/data/mark_all_notification/rx.dart';
import 'package:size_matter_swt/features/notification/data/read_notification/rx.dart';
import 'package:size_matter_swt/features/notification/model/notification_model.dart';
import 'package:size_matter_swt/features/profile/data/delete%20account/rx.dart';
import 'package:size_matter_swt/features/visited/data/visited_data/rx.dart';
import 'package:size_matter_swt/features/visited/model/visited_model.dart';
import 'package:size_matter_swt/features/home/data/post_visited/rx.dart';
import 'package:size_matter_swt/features/home/data/farms_data/rx.dart';
import 'package:size_matter_swt/features/home/data/ranche_data/rx.dart';
import 'package:size_matter_swt/features/home/data/events_data/rx.dart';
import 'package:size_matter_swt/features/home/data/event_details/rx.dart';
import 'package:size_matter_swt/features/home/data/nearby_ads_data/rx.dart';
import 'package:size_matter_swt/features/home/model/farms_model.dart';
import 'package:size_matter_swt/features/home/model/ranche_model.dart';
import 'package:size_matter_swt/features/event_list/model/events_model.dart';
import 'package:size_matter_swt/features/home/model/event_details_model.dart';
import 'package:size_matter_swt/features/home/model/nearby_ads_model.dart';
import 'package:size_matter_swt/features/profile/data/edit_image_profile/rx.dart';
import 'package:size_matter_swt/features/profile/data/edit_profile/rx.dart';
import 'package:size_matter_swt/features/profile/data/get_profile/rx.dart';
import 'package:size_matter_swt/features/search/data/search_farms_data/rx.dart';
import 'package:size_matter_swt/features/search/data/search_ranche_data/rx.dart';
import 'package:size_matter_swt/features/search/data/search_events_data/rx.dart';
import 'package:size_matter_swt/features/search/model/search_model.dart';

import '../features/auth/data/rx_signup/rx.dart';
import '../features/auth/data/rx_signup_verify/rx.dart';

SignupRx signupRxobj = SignupRx(empty: {}, dataFetcher: BehaviorSubject<Map>());

LoginRx loginRxobj = LoginRx(
  empty: LoginResponse(),
  dataFetcher: BehaviorSubject<LoginResponse>(),
);

VerifySignupOtpRx verifySignupOtpRxobj = VerifySignupOtpRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);

ResendOtpapiRx resendOtpapiRxobj = ResendOtpapiRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);

LogoutRX logoutRXobj = LogoutRX(empty: {}, dataFetcher: BehaviorSubject<Map>());
ForgetPassRx forgetPassRxobj = ForgetPassRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
ResendForgotOtpRx resendForgotOtpRxobj = ResendForgotOtpRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
VerifyForgetPassOtpRx verifyForgetPassOtpRxobj = VerifyForgetPassOtpRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);

ResetPasswordRx resetPasswordRxobj = ResetPasswordRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);

ChangePasswordRx changePasswordRxobj = ChangePasswordRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);

EditProfileRx editProfileRxobj = EditProfileRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);

GetProfileRx getProfileRxobj = GetProfileRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);

UpdateProfileRx updateProfileRx = UpdateProfileRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);

GetFarmsRx getFarmsRxObj = GetFarmsRx(
  empty: FarmsModel(),
  dataFetcher: BehaviorSubject<FarmsModel>(),
);

GetRanchesRx getRanchesRxObj = GetRanchesRx(
  empty: RancheModel(),
  dataFetcher: BehaviorSubject<RancheModel>(),
);

GetEventsRx getEventsRxObj = GetEventsRx(
  empty: EventsModel(),
  dataFetcher: BehaviorSubject<EventsModel>(),
);

GetFavouriteRx getFavouriteRxObj = GetFavouriteRx(
  empty: FavouriteModel(),
  dataFetcher: BehaviorSubject<FavouriteModel>(),
);

GetVisitedRx getVisitedRxObj = GetVisitedRx(
  empty: VisitedModel(),
  dataFetcher: BehaviorSubject<VisitedModel>(),
);

PostFavouritesRx postFavouritesRxObj = PostFavouritesRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);

PostVisitedRx postVisitedRxObj = PostVisitedRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);

SearchFarmsRx searchFarmsRxObj = SearchFarmsRx(
  empty: SeachModel(),
  dataFetcher: BehaviorSubject<SeachModel>(),
);

SearchRanchesRx searchRanchesRxObj = SearchRanchesRx(
  empty: RancheModel(),
  dataFetcher: BehaviorSubject<RancheModel>(),
);

SearchEventsRx searchEventsRxObj = SearchEventsRx(
  empty: EventsModel(),
  dataFetcher: BehaviorSubject<EventsModel>(),
);

GetNearbyAdsRx getNearbyAdsRxObj = GetNearbyAdsRx(
  empty: NearbyAdsModel(),
  dataFetcher: BehaviorSubject<NearbyAdsModel>(),
);

NotificationRx notificationRxObj = NotificationRx(
  empty: NotificationModel(),
  dataFetcher: BehaviorSubject<NotificationModel>(),
);

DeleteNotificationRx deleteNotificationRxObj = DeleteNotificationRx(
  empty: <String, dynamic>{},
  dataFetcher: BehaviorSubject<Map<String, dynamic>>(),
);

ReadNotificationRx readNotificationRxObj = ReadNotificationRx(
  empty: <String, dynamic>{},
  dataFetcher: BehaviorSubject<Map<String, dynamic>>(),
);

MarkAllNotificationRx markAllNotificationRxObj = MarkAllNotificationRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);

GetAllEventRx getAllEventRxObj = GetAllEventRx(
  empty: EventsModel(),
  dataFetcher: BehaviorSubject<EventsModel>(),
);

EventDetailsRx eventDetailsRxObj = EventDetailsRx(
  empty: EventDetailsModel(),
  dataFetcher: BehaviorSubject<EventDetailsModel>(),
);

AutoSaveNoteRx autoSaveNoteRxObj = AutoSaveNoteRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);

GetAllNotesRx getAllNotesRxObj = GetAllNotesRx(
  empty: AllNotesModel(),
  dataFetcher: BehaviorSubject<AllNotesModel>(),
);

NoteDetailsRx noteDetailsRxObj = NoteDetailsRx(
  empty: NoteDetailsModel(),
  dataFetcher: BehaviorSubject<NoteDetailsModel>(),
);

DeleteNotesRx deleteNotesRxObj = DeleteNotesRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);

PolicyRx policyRxObj = PolicyRx(
  empty: PrivacyPolicyModel(),
  dataFetcher: BehaviorSubject<PrivacyPolicyModel>(),
);

TermsRx termsRxObj = TermsRx(
  empty: TarmConditionModel(),
  dataFetcher: BehaviorSubject<TarmConditionModel>(),
);

DeleteAccountRx deleteAccountRxObj = DeleteAccountRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
SocialLoginRx socialLoginRxObj = SocialLoginRx(
  empty: LoginResponse(),
  dataFetcher: BehaviorSubject<LoginResponse>(),
);
