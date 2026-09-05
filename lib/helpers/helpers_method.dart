import 'dart:math';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';

import '../constants/app_constants.dart';
import 'di.dart';
import 'navigation_service.dart';

Container bgImage({String? bgImage}) {
  return Container(
    height: MediaQuery.of(NavigationService.context).size.height,
    width: MediaQuery.of(NavigationService.context).size.width,
    decoration: BoxDecoration(
      // image: DecorationImage(
      //   image: AssetImage(bgImage ?? Assets.images.loginBgCopy.path),
      //   fit: BoxFit.cover,
      // ),
    ),
  );
}

String formatTimeOfDay(TimeOfDay time) {
  final hour = time.hourOfPeriod == 0
      ? 12
      : time.hourOfPeriod; // Convert 0 to 12 for AM/PM format
  final period = time.period == DayPeriod.am ? "AM" : "PM";
  final minute = time.minute.toString().padLeft(
    2,
    '0',
  ); // Add leading zero to minutes if needed
  return "$hour:$minute $period";
}

Future<String?> pickDate({
  required BuildContext context,
  required DateTime startDate,
  required DateTime endDate,
  String dateFormat = "yyyy-MM-dd",
}) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: startDate,
    firstDate: startDate,
    lastDate: endDate,
  );

  if (pickedDate != null) {
    return DateFormat(dateFormat).format(pickedDate);
  }
  return null;
}

Future<void> showCustomDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  required Function(DateTime) onDatePicked,
}) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );

  if (pickedDate != null) {
    onDatePicked(pickedDate);
  }
}

String formatDate(DateTime date) {
  return DateFormat('MM/dd/yyyy').format(date);
}

String formatDateYear(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

String dashFormatDate(DateTime date) {
  return DateFormat('MM-dd-yyyy').format(date);
}

DateTime formatStringIntoDate(String date) {
  return DateFormat("MM/dd/yyyy").parse(date);
}

Future<void> showCustomTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
  required Function(TimeOfDay) onTimePicked,
}) async {
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: initialTime,
  );

  if (pickedTime != null) {
    onTimePicked(pickedTime);
  }
}

String formatTime(TimeOfDay time, BuildContext context) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  return TimeOfDay.fromDateTime(dt).format(context);
}

String formatedTime(TimeOfDay time) {
  final hour = time.hourOfPeriod == 0
      ? 12
      : time.hourOfPeriod; // Adjusts for 12-hour format
  final minute = time.minute.toString().padLeft(
    2,
    '0',
  ); // Pads minutes with a leading zero if needed
  final period = time.period == DayPeriod.am ? 'AM' : 'PM';

  return '$hour:$minute $period';
}

String formatTimeOfDay24Hour(TimeOfDay time) {
  final int hour = time.hour;
  final int minute = time.minute;
  return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}

TimeOfDay convertToTimeOfDay(String timeString) {
  DateFormat dateFormat = DateFormat("hh:mm a");
  DateTime dateTime = dateFormat.parse(timeString);
  return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
}

TimeOfDay formatStringToTime(String timeString) {
  try {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  } catch (e) {
    throw FormatException("Invalid time format: $timeString");
  }
}

TimeOfDay parseTime(String timeString) {
  // Example parsing format: "9:00 AM"
  // Adjust this based on your app's time format (e.g., "hh:mm a")
  final timeParts = timeString.split(':');
  if (timeParts.length == 2) {
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1].split(' ')[0]);
    final isPM = timeString.contains('PM');

    // Adjust hour for AM/PM
    final adjustedHour = isPM && hour != 12 ? hour + 12 : hour;
    return TimeOfDay(hour: adjustedHour, minute: minute);
  }
  return TimeOfDay.now(); // Default to current time if parsing fails
}

Future<void> setInitValue() async {
  await appData.writeIfNull(kKeyIsLoggedIn, false);
  await appData.writeIfNull(kKeyIsFirstTime, true);

  // var deviceInfo = DeviceInfoPlugin();
  // if (Platform.isIOS) {
  //   var iosDeviceInfo = await deviceInfo.iosInfo;
  //   appData.writeIfNull(kKeyDeviceID, iosDeviceInfo.identifierForVendor);
  // } else if (Platform.isAndroid) {
  //   var androidDeviceInfo = await deviceInfo.androidInfo;
  //   appData.writeIfNull(kKeyDeviceID, androidDeviceInfo.id);
  // }
  await Future.delayed(Duration(seconds: 3));
}

void rotation() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

void showCustomDialog({
  required BuildContext context,
  required String subTitile,
  required String confirmButtonName,
  required String cancleButtonName,
  String text = '',
  VoidCallback? noTap,
  required VoidCallback yesTap,
  Color? confirmBorderColor,
  Color? confirmTextColor,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: AppColors.scaffoldColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: AppColors.scaffoldColor,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                subTitile,
                textAlign: TextAlign.center,
                style: TextFontStyle.headline20w500c303030Inter,
              ),
              if (text.isNotEmpty) ...[
                UIHelper.verticalSpace(8.h),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextFontStyle.headline16w600c303030Inter,
                ),
              ],
              UIHelper.verticalSpace(24.h),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20.r),
                      onTap:
                          noTap ??
                          () {
                            NavigationService.goBack();
                          },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: AppColors.c2C6E49,
                          border: Border.all(
                            color: confirmBorderColor ?? AppColors.c303030,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            cancleButtonName,
                            style: TextFontStyle.headline16w600c303030Inter
                                .copyWith(color: AppColors.cFFFFFF),
                          ),
                        ),
                      ),
                    ),
                  ),
                  UIHelper.horizontalSpace(12.w),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20.r),
                      onTap: () {
                        NavigationService.goBack();
                        yesTap();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color:
                                confirmBorderColor ??
                                AppColors.cADADAD.withValues(alpha: 0.9),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            confirmButtonName,
                            style: TextFontStyle.headline16w600c303030Inter
                                .copyWith(
                                  color: confirmTextColor ?? AppColors.cFFBB00,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Future<String> getAddressFromLatLng(LatLng position) async {
  try {
    final dio = Dio();
    final response = await dio.get(
      "https://maps.googleapis.com/maps/api/geocode/json",
      queryParameters: {
        'latlng': '${position.latitude},${position.longitude}',
        'key': googleApiKeyy,
      },
    );

    if (response.statusCode == 200 && response.data['status'] == 'OK') {
      final results = response.data['results'] as List;
      if (results.isNotEmpty) {
        return results[0]['formatted_address'] ?? '';
      }
    }
  } catch (e) {
    debugPrint("Reverse Geocode Error: $e");
  }
  return '';
}

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const R = 6371000.0; // Radius of Earth in meters
  final dLat = _toRad(lat2 - lat1);
  final dLon = _toRad(lon2 - lon1);
  final a =
      sin(dLat / 2) * sin(dLat / 2) +
      cos(_toRad(lat1)) * cos(_toRad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return R * c;
}

double _toRad(double deg) => deg * pi / 180;
