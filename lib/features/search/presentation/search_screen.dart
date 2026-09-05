import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:size_matter_swt/common/custom_form_field.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/features/search/model/search_model.dart';
import 'package:size_matter_swt/features/home/model/ranche_model.dart';
import 'package:size_matter_swt/features/event_list/model/events_model.dart';
import 'package:size_matter_swt/features/search/presentation/widget/search_filter.dart';
import 'package:size_matter_swt/features/search/presentation/widget/search_list.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/navigation_service.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';
import 'package:size_matter_swt/networks/api_access.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:size_matter_swt/features/home/presentation/widgets/home_controller.dart';
import 'package:size_matter_swt/helpers/di.dart';

import 'package:size_matter_swt/constants/location_category.dart';

class SearchScreen extends StatefulWidget {
  final LocationCategory category;
  const SearchScreen({super.key, this.category = LocationCategory.farms});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  bool _isSearching = false;
  List<Map<String, dynamic>> _recentSearches = [];
  int _selectedPlacesFilter = -1;

  static const String _kRecentSearchesKey = 'recent_searches';

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
    _selectedPlacesFilter = homeController.selectedPlacesFilter.value;
  }

  void _loadRecentSearches() {
    final List<dynamic>? stored = appData.read<List<dynamic>>(
      _kRecentSearchesKey,
    );
    if (stored != null) {
      final allRecent = stored.cast<Map<String, dynamic>>().toList();
      setState(() {
        _recentSearches = allRecent
            .where(
              (item) =>
                  item['type']?.toString().toLowerCase() ==
                  widget.category.apiType.toLowerCase(),
            )
            .toList();
      });
    }
  }

  void _saveToRecent(Map<String, dynamic> itemData) {
    if (itemData['itemId'] == null) return;

    final List<dynamic>? stored = appData.read<List<dynamic>>(
      _kRecentSearchesKey,
    );
    List<Map<String, dynamic>> allRecent =
        stored?.cast<Map<String, dynamic>>().toList() ?? [];

    allRecent.removeWhere((element) => element['itemId'] == itemData['itemId']);

    allRecent.insert(0, itemData);

    if (allRecent.length > 50) {
      allRecent = allRecent.sublist(0, 50);
    }

    appData.write(_kRecentSearchesKey, allRecent);

    setState(() {
      _recentSearches = allRecent
          .where(
            (item) =>
                item['type']?.toString().toLowerCase() ==
                widget.category.apiType.toLowerCase(),
          )
          .take(10)
          .toList();
    });
  }

  void _clearRecentSearches() {
    final List<dynamic>? stored = appData.read<List<dynamic>>(
      _kRecentSearchesKey,
    );
    if (stored == null) return;

    List<Map<String, dynamic>> allRecent = stored
        .cast<Map<String, dynamic>>()
        .toList();

    allRecent.removeWhere(
      (item) =>
          item['type']?.toString().toLowerCase() ==
          widget.category.apiType.toLowerCase(),
    );

    appData.write(_kRecentSearchesKey, allRecent);
    setState(() {
      _recentSearches = [];
    });
  }

  void _removeFromRecent(String itemId) {
    final List<dynamic>? stored = appData.read<List<dynamic>>(
      _kRecentSearchesKey,
    );
    if (stored == null) return;

    List<Map<String, dynamic>> allRecent = stored
        .cast<Map<String, dynamic>>()
        .toList();

    allRecent.removeWhere((item) => item['itemId'] == itemId);

    appData.write(_kRecentSearchesKey, allRecent);
    setState(() {
      _recentSearches = allRecent
          .where(
            (item) =>
                item['type']?.toString().toLowerCase() ==
                widget.category.apiType.toLowerCase(),
          )
          .take(10)
          .toList();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        setState(() {
          _isSearching = true;
        });

        if (widget.category == LocationCategory.farms) {
          searchFarmsRxObj.searchFarms(query).then((_) {
            if (mounted) setState(() => _isSearching = false);
          });
        } else if (widget.category == LocationCategory.ranches) {
          searchRanchesRxObj.searchRanches(query).then((_) {
            if (mounted) setState(() => _isSearching = false);
          });
        } else if (widget.category == LocationCategory.events) {
          searchEventsRxObj.searchEvents(query).then((_) {
            if (mounted) setState(() => _isSearching = false);
          });
        }
      } else {
        setState(() {
          _isSearching = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UIHelper.verticalSpace(20.h),
              CustomFormField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                prefixIcon: GestureDetector(
                  onTap: () {
                    NavigationService.goBack();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    child: SvgPicture.asset(Assets.icons.arrowBack),
                  ),
                ),
                suffixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  child: GestureDetector(
                    onTap: () async {
                      final result = await showModalBottomSheet<int>(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        builder: (context) {
                          return SearchFilter(
                            initialSelectedPlaces: _selectedPlacesFilter,
                          );
                        },
                      );

                      if (result != null) {
                        setState(() {
                          _selectedPlacesFilter = result;
                        });
                        homeController.selectedPlacesFilter.value = result;
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: SvgPicture.asset(Assets.icons.filter),
                  ),
                ),
                focusBorderColor: AppColors.cADADAD,
                hintText: "Search farm, ranch or address",
              ),
              UIHelper.verticalSpace(20.h),
              if (_searchController.text.isEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recent search",
                          style: TextFontStyle.headline16w500c303030Inter,
                        ),
                        GestureDetector(
                          onTap: _clearRecentSearches,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                Assets.icons.clear,
                                height: 12.h,
                                width: 12.w,
                              ),
                              Text(
                                " Clear All",
                                style: TextFontStyle.headline12w500c7C7C7CInter,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    UIHelper.verticalSpaceMedium,
                    // Note: Here we'd typically have a persistent list of recent searches.
                    // Using placeholder for now as per static design.
                  ],
                ),
              if (_isSearching)
                const Center(
                  child: CircularProgressIndicator(color: AppColors.c34A853),
                ),
              Expanded(
                child: StreamBuilder<dynamic>(
                  stream: widget.category == LocationCategory.farms
                      ? searchFarmsRxObj.fillData
                      : widget.category == LocationCategory.ranches
                      ? searchRanchesRxObj.fillData
                      : searchEventsRxObj.fillData,
                  builder: (context, snapshot) {
                    if (_searchController.text.isEmpty) {
                      if (_recentSearches.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return ListView.builder(
                        itemCount: _recentSearches.length,
                        itemBuilder: (context, index) {
                          final item = _recentSearches[index];
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  final latLng = LatLng(
                                    item['lat'],
                                    item['lng'],
                                  );
                                  homeController.pendingJump = (
                                    position: latLng,
                                    name: item['name'],
                                    address: item['address'],
                                    type: item['type'],
                                    ownerName: item['ownerName'],
                                    phone: item['phone'],
                                    itemId: item['itemId'],
                                    initialIsFavourite: item['isFavorite'],
                                    initialIsVisited: item['isVisited'],
                                  );
                                  Navigator.pop(context);
                                },
                                child: SearchList(
                                  title: item['name'],
                                  subtitle: item['address'],
                                  onRemove: () =>
                                      _removeFromRecent(item['itemId']),
                                ),
                              ),
                              UIHelper.verticalSpace(26.h),
                            ],
                          );
                        },
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting &&
                        _isSearching) {
                      return const SizedBox.shrink();
                    }

                    final List<dynamic> results = [];
                    if (snapshot.hasData) {
                      final data = snapshot.data;
                      List<dynamic> allItems = [];
                      if (data is SeachModel) {
                        allItems = data.data?.farms ?? [];
                      } else if (data is RancheModel) {
                        allItems = data.data?.ranches ?? [];
                      } else if (data is EventsModel) {
                        allItems = data.data?.events ?? [];
                      }

                      if (_selectedPlacesFilter == 0) {
                        // Visited Places
                        results.addAll(
                          allItems.where((item) {
                            if (item is Farm) return item.isVisited == true;
                            if (item is Ranch) return item.isVisited == true;
                            if (item is Event) return item.isVisited == true;
                            return false;
                          }),
                        );
                      } else if (_selectedPlacesFilter == 1) {
                        // Not Visited
                        results.addAll(
                          allItems.where((item) {
                            if (item is Farm) return item.isVisited != true;
                            if (item is Ranch) return item.isVisited != true;
                            if (item is Event) return item.isVisited != true;
                            return false;
                          }),
                        );
                      } else {
                        results.addAll(allItems);
                      }
                    }

                    if (results.isEmpty && !_isSearching) {
                      return Center(
                        child: Text(
                          "No results found",
                          style: TextFontStyle.headline16w500c303030Inter,
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final item = results[index];
                        String title = "";
                        String subtitle = "";
                        String id = "";
                        bool? isFav;
                        bool? isVisited;
                        String oName = "";
                        String pNo = "";

                        if (item is Farm) {
                          title = item.name ?? "";
                          subtitle = item.address ?? "";
                          id = item.id?.toString() ?? "";
                          isFav = item.isFavorite;
                          isVisited = item.isVisited;
                          oName = item.ownerName ?? "";
                          pNo = item.phone ?? item.ownerPhone ?? "";
                        } else if (item is Ranch) {
                          title = item.name ?? "";
                          subtitle = item.address ?? "";
                          id = item.id?.toString() ?? "";
                          isFav = item.isFavorite;
                          isVisited = item.isVisited;
                          oName = item.ownerName ?? "";
                          pNo = item.phone ?? item.ownerPhone ?? "";
                        } else if (item is Event) {
                          title = item.title ?? "";
                          subtitle = item.address ?? "";
                          id = item.id?.toString() ?? "";
                          isFav = item.isFavorite;
                          isVisited = item.isVisited;
                          oName = item.owner?.name ?? "";
                          pNo = item.phone?.isNotEmpty == true
                              ? item.phone!
                              : item.owner?.phone ?? "";
                        }

                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (item.latitude != null &&
                                    item.longitude != null) {
                                  final latLng = LatLng(
                                    item.latitude!,
                                    item.longitude!,
                                  );
                                  final typeStr = widget.category.apiType;

                                  homeController.pendingJump = (
                                    position: latLng,
                                    name: title,
                                    address: subtitle,
                                    type: typeStr,
                                    ownerName: oName,
                                    phone: pNo,
                                    itemId: id,
                                    initialIsFavourite: isFav,
                                    initialIsVisited: isVisited,
                                  );

                                  _saveToRecent({
                                    'lat': latLng.latitude,
                                    'lng': latLng.longitude,
                                    'name': title,
                                    'address': subtitle,
                                    'type': typeStr,
                                    'ownerName': oName,
                                    'phone': pNo,
                                    'itemId': id,
                                    'isFavorite': isFav,
                                    'isVisited': isVisited,
                                  });

                                  Navigator.pop(context);
                                }
                              },
                              child: SearchList(
                                title: title,
                                subtitle: subtitle,
                              ),
                            ),
                            UIHelper.verticalSpace(26.h),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
