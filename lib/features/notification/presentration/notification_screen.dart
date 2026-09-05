import 'package:size_matter_swt/common/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/features/notification/model/notification_model.dart';
import 'package:size_matter_swt/features/notification/presentration/widget/activity_screen.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/navigation_service.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';
import 'package:size_matter_swt/networks/api_access.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchNotifications();
    });
  }

  Future<void> _fetchNotifications() async {
    setState(() => _isLoading = true);
    await notificationRxObj.getNotificationData();
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _onDeleteNotification(String id) async {
    debugPrint("Attempting to delete notification: $id");
    final success = await deleteNotificationRxObj.deleteNotificationApi(id: id);
    if (success && mounted) {
      debugPrint("Delete successful, refreshing list...");
      customToastMessage(
        "Delete successful",
        "Your notification has been deleted successfully",
      );
      await notificationRxObj.getNotificationData();
    } else {
      debugPrint("Delete failed or returned false");
    }
  }

  Future<void> _onReadNotification(String id) async {
    final success = await readNotificationRxObj.readNotificationFun(id: id);
    if (success && mounted) {
      await notificationRxObj.getNotificationData();
    }
  }

  Map<String, List<NotificationItem>> _groupNotifications(
    List<NotificationItem> notifications,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final todayList = <NotificationItem>[];
    final yesterdayList = <NotificationItem>[];
    final olderList = <NotificationItem>[];

    for (final item in notifications) {
      if (item.createdAt == null) continue;

      final itemDateLocal = item.createdAt!.toLocal();
      final itemDate = DateTime(
        itemDateLocal.year,
        itemDateLocal.month,
        itemDateLocal.day,
      );

      if (itemDate == today) {
        todayList.add(item);
      } else if (itemDate == yesterday) {
        yesterdayList.add(item);
      } else {
        olderList.add(item);
      }
    }

    return {'today': todayList, 'yesterday': yesterdayList, 'older': olderList};
  }

  Map<String, dynamic> _toActivityMap(NotificationItem item) {
    return {
      "id": item.id ?? "",
      "userName": item.data?.farmName ?? "Unknown",
      "actionText": item.data?.action ?? "",
      "title": item.data?.message ?? "",
      "timeText": _formatTime(item.createdAt),
      "isRead": item.isRead ?? false,
    };
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return "";
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 60) return "${diff.inMinutes} minutes ago";
    if (diff.inHours < 24) return "${diff.inHours} hours ago";
    return "${diff.inDays} days ago";
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: GestureDetector(
              onTap: NavigationService.goBack,
              child: SvgPicture.asset(Assets.icons.arrowBack),
            ),
          ),
          title: StreamBuilder<NotificationModel>(
            stream: notificationRxObj.fillData,
            builder: (context, snapshot) {
              final unreadCount = snapshot.data?.data?.unreadCount ?? 0;
              return Text(
                unreadCount > 0
                    ? "Notification ($unreadCount)"
                    : "Notification",
                style: TextFontStyle.headline20w700c303030Inter,
              );
            },
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0,
        ),
        body: _isLoading
            ? const _NotificationShimmer()
            : StreamBuilder<NotificationModel>(
                stream: notificationRxObj.fillData,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data?.data == null) {
                    return const Center(child: Text("No notifications found"));
                  }

                  final allNotifications =
                      snapshot.data!.data!.notifications ?? [];

                  if (allNotifications.isEmpty) {
                    return const Center(child: Text("No notifications found"));
                  }

                  final unreadNotifications = allNotifications
                      .where((item) => item.isRead == false)
                      .toList();

                  final groupedAll = _groupNotifications(allNotifications);
                  final groupedUnread = _groupNotifications(
                    unreadNotifications,
                  );

                  return Column(
                    children: [
                      TabBar(
                        indicatorColor: AppColors.c34A853,
                        labelColor: AppColors.c34A853,
                        unselectedLabelColor: AppColors.cADADAD,
                        labelStyle: TextFontStyle.headline16w600c303030Inter,
                        tabs: const [
                          Tab(text: "All"),
                          Tab(text: "Unread"),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            ActivityScreen(
                              todayTitle: "Today",
                              yesterdayTitle: "Yesterday",
                              olderTitle: "Older",
                              todayNotifications: groupedAll['today']!
                                  .map(_toActivityMap)
                                  .toList(),
                              yesterdayNotifications: groupedAll['yesterday']!
                                  .map(_toActivityMap)
                                  .toList(),
                              olderNotifications: groupedAll['older']!
                                  .map(_toActivityMap)
                                  .toList(),
                              onDelete: _onDeleteNotification,
                              onRead: _onReadNotification,
                            ),
                            ActivityScreen(
                              onMarkAllRead: () async {
                                final success = await markAllNotificationRxObj
                                    .post();
                                if (success) {
                                  await notificationRxObj.getNotificationData();
                                }
                              },
                              todayTitle: "Today",
                              yesterdayTitle: "Yesterday",
                              olderTitle: "Older",
                              todayNotifications: groupedUnread['today']!
                                  .map(_toActivityMap)
                                  .toList(),
                              yesterdayNotifications:
                                  groupedUnread['yesterday']!
                                      .map(_toActivityMap)
                                      .toList(),
                              olderNotifications: groupedUnread['older']!
                                  .map(_toActivityMap)
                                  .toList(),
                              onDelete: _onDeleteNotification,
                              onRead: _onReadNotification,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}

class _NotificationShimmer extends StatelessWidget {
  const _NotificationShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        children: [
          _ShimmerBox(width: 60.w, height: 14.h, radius: 6),
          UIHelper.verticalSpace(12.h),

          ...List.generate(3, (_) => const _NotificationItemShimmer()),

          UIHelper.verticalSpace(20.h),

          _ShimmerBox(width: 80.w, height: 14.h, radius: 6),
          UIHelper.verticalSpace(12.h),

          ...List.generate(3, (_) => const _NotificationItemShimmer()),
        ],
      ),
    );
  }
}

class _NotificationItemShimmer extends StatelessWidget {
  const _NotificationItemShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ShimmerBox(width: 46.w, height: 46.w, radius: 23.w),
          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UIHelper.verticalSpace(4.h),
                _ShimmerBox(width: double.infinity, height: 13.h, radius: 6),
                UIHelper.verticalSpace(8.h),
                _ShimmerBox(width: 140.w, height: 11.h, radius: 6),
                UIHelper.verticalSpace(8.h),
                _ShimmerBox(width: 80.w, height: 10.h, radius: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.cFFFFFF,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
