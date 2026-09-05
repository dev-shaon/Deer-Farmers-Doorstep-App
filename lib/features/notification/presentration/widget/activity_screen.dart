import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/features/notification/presentration/widget/custom_notification.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';

class ActivityScreen extends StatelessWidget {
  final String todayTitle;
  final String yesterdayTitle;
  final String? olderTitle;

  final List<Map<String, dynamic>> todayNotifications;
  final List<Map<String, dynamic>> yesterdayNotifications;
  final List<Map<String, dynamic>>? olderNotifications;
  final Function(String id)? onDelete;
  final Function(String id)? onRead;
  final VoidCallback? onMarkAllRead;

  const ActivityScreen({
    super.key,
    required this.todayTitle,
    required this.yesterdayTitle,
    this.olderTitle,
    required this.todayNotifications,
    required this.yesterdayNotifications,
    this.olderNotifications,
    this.onDelete,
    this.onRead,
    this.onMarkAllRead,
  });

  @override
  Widget build(BuildContext context) {
    Widget buildReadAllButton() {
      return GestureDetector(
        onTap: onMarkAllRead,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 6.h,
          ),
          decoration: BoxDecoration(
            color: AppColors.c34A853,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            "Read All",
            style: TextFontStyle.headline12w400cFFFFFFInter,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (todayNotifications.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    todayTitle,
                    style: TextFontStyle.headline16w500cADADADInter,
                  ),
                  if (onMarkAllRead != null) buildReadAllButton(),
                ],
              ),
            ),

          if (todayNotifications.isNotEmpty)
            Column(
              children: todayNotifications.map((item) {
                return Column(
                  children: [
                    CustomNotification(
                      userName: item['userName'] ?? '',
                      actionText: item['actionText'] ?? '',
                      title: item['title'] ?? '',
                      timeText: item['timeText'] ?? '',
                      isRead: item['isRead'] ?? false,
                      onTap: () {
                        if (onRead != null &&
                            item['id'] != null &&
                            item['isRead'] != true) {
                          onRead!(item['id']);
                        }
                      },
                      deleteonTap: () {
                        if (onDelete != null && item['id'] != null) {
                          onDelete!(item['id']);
                        }
                      },
                    ),
                    Divider(color: AppColors.cADADAD),
                  ],
                );
              }).toList(),
            ),

          if (yesterdayNotifications.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    yesterdayTitle,
                    style: TextFontStyle.headline16w500cADADADInter,
                  ),
                  if (onMarkAllRead != null && todayNotifications.isEmpty)
                    buildReadAllButton(),
                ],
              ),
            ),

          if (yesterdayNotifications.isNotEmpty)
            ListView.builder(
              itemCount: yesterdayNotifications.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = yesterdayNotifications[index];

                return Column(
                  children: [
                    CustomNotification(
                      userName: item['userName'] ?? '',
                      actionText: item['actionText'] ?? '',
                      title: item['title'] ?? '',
                      timeText: item['timeText'] ?? '',
                      isRead: item['isRead'] ?? false,
                      onTap: () {
                        if (onRead != null &&
                            item['id'] != null &&
                            item['isRead'] != true) {
                          onRead!(item['id']);
                        }
                      },
                      deleteonTap: () {
                        if (onDelete != null && item['id'] != null) {
                          onDelete!(item['id']);
                        }
                      },
                    ),
                    Divider(color: AppColors.cADADAD, height: 2.h),
                  ],
                );
              },
            ),

          if (olderNotifications != null && olderNotifications!.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    olderTitle ?? "Older",
                    style: TextFontStyle.headline16w500cADADADInter,
                  ),
                  if (onMarkAllRead != null &&
                      todayNotifications.isEmpty &&
                      yesterdayNotifications.isEmpty)
                    buildReadAllButton(),
                ],
              ),
            ),

          if (olderNotifications != null && olderNotifications!.isNotEmpty)
            ListView.builder(
              itemCount: olderNotifications!.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = olderNotifications![index];

                return Column(
                  children: [
                    CustomNotification(
                      userName: item['userName'] ?? '',
                      actionText: item['actionText'] ?? '',
                      title: item['title'] ?? '',
                      timeText: item['timeText'] ?? '',
                      isRead: item['isRead'] ?? false,
                      onTap: () {
                        if (onRead != null &&
                            item['id'] != null &&
                            item['isRead'] != true) {
                          onRead!(item['id']);
                        }
                      },
                      deleteonTap: () {
                        if (onDelete != null && item['id'] != null) {
                          onDelete!(item['id']);
                        }
                      },
                    ),
                    Divider(color: AppColors.cADADAD, height: 2.h),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
