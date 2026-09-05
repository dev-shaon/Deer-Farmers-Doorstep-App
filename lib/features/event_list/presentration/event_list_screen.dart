import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:size_matter_swt/constants/location_category.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/features/event_list/model/events_model.dart';
import 'package:size_matter_swt/features/event_list/presentration/widget/event_card.dart';
import 'package:size_matter_swt/features/home/presentation/widgets/home_controller.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/helpers/all_routes.dart';
import 'package:size_matter_swt/helpers/navigation_service.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';
import 'package:size_matter_swt/networks/api_access.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchEvents();
    });
  }

  Future<void> _fetchEvents() async {
    setState(() => _isLoading = true);
    await getAllEventRxObj.fetchAllEvents();
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                NavigationService.goBack();
              },
              child: SvgPicture.asset(Assets.icons.arrowBack),
            ),
            const Spacer(),
            Text(
              "All event list",
              style: TextFontStyle.headline24w700c303030Inter,
            ),
            const Spacer(),
            SizedBox(width: 24.w),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: _isLoading
            ? const _EventListShimmer()
            : StreamBuilder<EventsModel>(
                stream: getAllEventRxObj.fillData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      _isLoading) {
                    return const _EventListShimmer();
                  }

                  if (!snapshot.hasData ||
                      snapshot.data?.data?.events == null ||
                      snapshot.data!.data!.events!.isEmpty) {
                    return const Center(child: Text("No events found"));
                  }

                  final events = snapshot.data!.data!.events!;

                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        UIHelper.verticalSpaceMedium,
                        ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: events.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 16.h),
                          itemBuilder: (context, index) {
                            final event = events[index];
                            final startDate = event.startDate ?? DateTime.now();
                            final endDate = event.endDate ?? DateTime.now();
                            final daysLeft = startDate
                                .difference(DateTime.now())
                                .inDays;

                            return EventCard(
                              imageUrl:
                                  event.image ??
                                  'https://imgs.search.brave.com/n-I88ToahTJiUIySFvWoCCfi6aDw4xTck3nJTfIVrgE/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS5nZXR0eWltYWdl/cy5jb20vaWQvMTE2/OTU5NTg4My9waG90/by95b3VuZy1hc2lh/bi13b21lbi1mZWVk/aW5nLWRlZXItaW4t/ZGVlci1mYXJtLmpw/Zz9zPTYxMng2MTIm/dz0wJms9MjAmYz1a/RmV1MG1BeHhyNXc4/Ql82UWpaY2dtZXgz/VXA3ZFg2MTg4VFpq/eFVsTkRNPQ',
                              daysLeft: daysLeft > 0
                                  ? '$daysLeft days left'
                                  : 'Today',
                              eventDay: DateFormat('dd').format(startDate),
                              eventMonth: DateFormat('MMMM').format(startDate),
                              eventYear: DateFormat('yyyy').format(startDate),
                              title: event.title ?? 'No Title',
                              location: event.address ?? 'Unknown Location',
                              duration:
                                  '${endDate.difference(startDate).inDays} days',
                              onMapViewTap: () {
                                if (event.latitude == null ||
                                    event.longitude == null) {
                                  return;
                                }

                                final latLng = LatLng(
                                  event.latitude!,
                                  event.longitude!,
                                );
                                final title = event.title ?? '';
                                final address = event.address ?? '';
                                final type = event.type ?? 'event';
                                final ownerName = event.owner?.name ?? '';
                                final phone = event.phone?.isNotEmpty == true
                                    ? event.phone!
                                    : event.owner?.phone ?? '';
                                final itemId = event.id?.toString() ?? '';

                                homeController.pendingJump = (
                                  position: latLng,
                                  name: title,
                                  address: address,
                                  type: type,
                                  ownerName: ownerName,
                                  phone: phone,
                                  itemId: itemId,
                                  initialIsFavourite: event.isFavorite,
                                  initialIsVisited: event.isVisited,
                                );

                                NavigationService.navigateToWithArgs(
                                  Routes.navberScreen,
                                  {
                                    'category': LocationCategory.events,
                                    'jumpPosition': latLng,
                                    'jumpName': title,
                                    'jumpAddress': address,
                                    'jumpType': type,
                                    'jumpOwnerName': ownerName,
                                    'jumpPhone': phone,
                                    'jumpItemId': itemId,
                                    'jumpIsFavorite': event.isFavorite,
                                    'jumpIsVisited': event.isVisited,
                                  },
                                );
                              },
                            );
                          },
                        ),
                        UIHelper.verticalSpaceMedium,
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _EventListShimmer extends StatelessWidget {
  const _EventListShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        itemCount: 5,
        separatorBuilder: (context, index) => SizedBox(height: 16.h),
        itemBuilder: (context, index) => const _EventCardShimmer(),
      ),
    );
  }
}

class _EventCardShimmer extends StatelessWidget {
  const _EventCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
    );
  }
}
