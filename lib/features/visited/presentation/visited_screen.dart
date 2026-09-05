import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:size_matter_swt/constants/location_category.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/features/home/presentation/widgets/home_controller.dart';
import 'package:size_matter_swt/features/visited/model/visited_model.dart';
import 'package:size_matter_swt/features/visited/presentation/widget/three_filter.dart';
import 'package:size_matter_swt/features/visited/presentation/widget/visited_list.dart';
import 'package:size_matter_swt/helpers/all_routes.dart';
import 'package:size_matter_swt/helpers/navigation_service.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';
import 'package:size_matter_swt/networks/api_access.dart';

class VisitedScreen extends StatefulWidget {
  final LocationCategory category;
  final VoidCallback? onJumpToMap;

  const VisitedScreen({
    super.key,
    this.category = LocationCategory.farms,
    this.onJumpToMap,
  });

  @override
  State<VisitedScreen> createState() => _VisitedScreenState();
}

class _VisitedScreenState extends State<VisitedScreen> {
  int _selectedFilterIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize based on the initial category if desired,
    // or just default to 0 (Events).
    if (widget.category == LocationCategory.events) _selectedFilterIndex = 0;
    if (widget.category == LocationCategory.ranches) _selectedFilterIndex = 1;
    if (widget.category == LocationCategory.farms) _selectedFilterIndex = 2;
    _loadVisited();
  }

  String get _typeFilter {
    switch (_selectedFilterIndex) {
      case 0:
        return 'event';
      case 1:
        return 'ranch';
      case 2:
        return 'farm';
      default:
        return 'event';
    }
  }

  String get _screenTitle {
    switch (_selectedFilterIndex) {
      case 0:
        return 'Visited events';
      case 1:
        return 'Visited ranches';
      case 2:
        return 'Visited farms';
      default:
        return 'Visited events';
    }
  }

  LocationCategory get _selectedCategory {
    switch (_selectedFilterIndex) {
      case 0:
        return LocationCategory.events;
      case 1:
        return LocationCategory.ranches;
      case 2:
        return LocationCategory.farms;
      default:
        return LocationCategory.events;
    }
  }

  Future<void> _loadVisited() async {
    try {
      await getVisitedRxObj.fetchVisitedData();
    } catch (e) {
      debugPrint("Visited Error: $e");
    }
  }

  void _onVisitedTap(Visited entry) {
    final item = entry.item;
    if (item?.latitude == null || item?.longitude == null) return;

    homeController.pendingJump = (
      position: LatLng(item!.latitude!, item.longitude!),
      name: item.name ?? '',
      address: item.resolvedAddress ?? item.address ?? '',
      type: item.type ?? '',
      ownerName: item.ownerName ?? '',
      phone: item.phone?.isNotEmpty == true
          ? item.phone!
          : item.ownerPhone ?? '',
      itemId: item.id?.toString() ?? '',
      initialIsFavourite: null,
      initialIsVisited: null,
    );

    if (widget.onJumpToMap != null) {
      widget.onJumpToMap!.call();
      return;
    }

    NavigationService.navigateToWithArgs(Routes.navberScreen, {
      'category': _selectedCategory,
      'jumpPosition': LatLng(item.latitude!, item.longitude!),
      'jumpName': item.name ?? '',
      'jumpAddress': item.resolvedAddress ?? item.address ?? '',
      'jumpType': item.type ?? '',
      'jumpOwnerName': item.ownerName ?? '',
      'jumpPhone': item.phone?.isNotEmpty == true
          ? item.phone!
          : item.ownerPhone ?? '',
      'jumpItemId': item.id?.toString() ?? '',
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<VisitedModel>(
        stream: getVisitedRxObj.fillData.cast<VisitedModel>(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data;
          final all = data?.data?.visited ?? [];
          final visitedEntries = all
              .where((v) => v.item?.type == _typeFilter)
              .toList();

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                UIHelper.verticalSpace(8.h),
                Text(
                  _screenTitle,
                  style: TextFontStyle.headline24w700c303030Inter,
                ),
                UIHelper.verticalSpace(20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ThreeFilter(
                      title: "Events",
                      isSelected: _selectedFilterIndex == 0,
                      ontap: () {
                        setState(() {
                          _selectedFilterIndex = 0;
                        });
                      },
                    ),
                    ThreeFilter(
                      title: "Ranches",
                      isSelected: _selectedFilterIndex == 1,
                      ontap: () {
                        setState(() {
                          _selectedFilterIndex = 1;
                        });
                      },
                    ),
                    ThreeFilter(
                      title: "Farms",
                      isSelected: _selectedFilterIndex == 2,
                      ontap: () {
                        setState(() {
                          _selectedFilterIndex = 2;
                        });
                      },
                    ),
                  ],
                ),
                UIHelper.verticalSpace(16.h),
                Expanded(
                  child: visitedEntries.isEmpty
                      ? Center(
                          child: Text(
                            "No ${_screenTitle.toLowerCase()} yet",
                            style: TextFontStyle.headline16w500c303030Inter,
                          ),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: visitedEntries.length,
                          itemBuilder: (context, index) {
                            final entry = visitedEntries[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: VisitedList(
                                visited: entry,
                                onTitleTap: () => _onVisitedTap(entry),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(
    //       _screenTitle,
    //       style: TextFontStyle.headline24w700c303030Inter,
    //     ),
    //     centerTitle: true,
    //     automaticallyImplyLeading: false,
    //   ),
    //   body: SafeArea(
    //     child: StreamBuilder<VisitedModel>(
    //       stream: getVisitedRxObj.fillData.cast<VisitedModel>(),
    //       builder: (context, snapshot) {
    //         if (snapshot.connectionState == ConnectionState.waiting &&
    //             !snapshot.hasData) {
    //           return const Center(child: CircularProgressIndicator());
    //         }

    //         final data = snapshot.data;
    //         final all = data?.data?.visited ?? [];
    //         final visitedEntries = all
    //             .where((v) => v.item?.type == _typeFilter)
    //             .toList();

    //         return Padding(
    //           padding: EdgeInsets.symmetric(horizontal: 16.w),
    //           child: Column(
    //             children: [
    //               UIHelper.verticalSpace(8.h),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   ThreeFilter(
    //                     title: "Events",
    //                     isSelected: _selectedFilterIndex == 0,
    //                     ontap: () {
    //                       setState(() {
    //                         _selectedFilterIndex = 0;
    //                       });
    //                     },
    //                   ),
    //                   ThreeFilter(
    //                     title: "Ranches",
    //                     isSelected: _selectedFilterIndex == 1,
    //                     ontap: () {
    //                       setState(() {
    //                         _selectedFilterIndex = 1;
    //                       });
    //                     },
    //                   ),
    //                   ThreeFilter(
    //                     title: "Farms",
    //                     isSelected: _selectedFilterIndex == 2,
    //                     ontap: () {
    //                       setState(() {
    //                         _selectedFilterIndex = 2;
    //                       });
    //                     },
    //                   ),
    //                 ],
    //               ),
    //               UIHelper.verticalSpace(16.h),
    //               Expanded(
    //                 child: visitedEntries.isEmpty
    //                     ? Center(
    //                         child: Text(
    //                           "No ${_screenTitle.toLowerCase()} yet",
    //                           style: TextFontStyle.headline16w500c303030Inter,
    //                         ),
    //                       )
    //                     : ListView.builder(
    //                         physics: const BouncingScrollPhysics(),
    //                         itemCount: visitedEntries.length,
    //                         itemBuilder: (context, index) {
    //                           final entry = visitedEntries[index];
    //                           return Padding(
    //                             padding: EdgeInsets.only(bottom: 10.h),
    //                             child: VisitedList(
    //                               visited: entry,
    //                               onTitleTap: () => _onVisitedTap(entry),
    //                             ),
    //                           );
    //                         },
    //                       ),
    //               ),
    //             ],
    //           ),
    //         );
    //       },
    //     ),
    //   ),
    // );
  }
}
