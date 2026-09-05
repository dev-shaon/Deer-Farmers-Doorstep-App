import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/features/home/model/event_details_model.dart';
import 'package:size_matter_swt/features/home/model/farms_model.dart';
import 'package:size_matter_swt/features/home/model/ranche_model.dart';
import 'package:size_matter_swt/features/event_list/model/events_model.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/toast.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';
import 'package:size_matter_swt/networks/api_access.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationDetailsBottomSheet extends StatefulWidget {
  final VoidCallback onStartNavigation;
  final VoidCallback onStopNavigation;
  final String name;
  final String address;
  final String type;
  final String ownerName;
  final String phone;
  final String? email;
  final String? website;
  final double distanceKm;
  final String itemId;
  final String apiType;
  final bool? initialIsFavourite;
  final bool? initialIsVisited;
  final bool isNavigatingCurrently;
  final Stream<double>? remainingDistanceStream;
  final Function(bool)? onFavouriteChanged;
  final Function(bool)? onVisitedChanged;

  const LocationDetailsBottomSheet({
    super.key,
    required this.onStartNavigation,
    required this.onStopNavigation,
    required this.name,
    required this.address,
    required this.type,
    required this.ownerName,
    required this.phone,
    this.email,
    this.website,
    required this.distanceKm,
    required this.itemId,
    required this.apiType,
    this.initialIsFavourite,
    this.initialIsVisited,
    this.isNavigatingCurrently = false,
    this.remainingDistanceStream,
    this.onFavouriteChanged,
    this.onVisitedChanged,
  });

  @override
  State<LocationDetailsBottomSheet> createState() =>
      _LocationDetailsBottomSheetState();
}

class _LocationDetailsBottomSheetState
    extends State<LocationDetailsBottomSheet> {
  bool _visitedLoading = false;
  bool _favLoading = false;
  late bool _visitedHighlighted;
  late bool _favHighlighted;
  late double _currentDisplayedDistance;
  StreamSubscription<double>? _distanceSub;
  StreamSubscription? _syncSub;

  @override
  void initState() {
    super.initState();
    _favHighlighted = widget.initialIsFavourite ?? false;
    _visitedHighlighted = widget.initialIsVisited ?? false;
    _currentDisplayedDistance = widget.distanceKm;

    if (widget.apiType.toLowerCase() == 'event') {
      eventDetailsRxObj.fetchEventDetails(widget.itemId);
    }

    if (widget.isNavigatingCurrently &&
        widget.remainingDistanceStream != null) {
      _distanceSub = widget.remainingDistanceStream!.listen((dist) {
        if (mounted) {
          setState(() {
            _currentDisplayedDistance = dist;
          });
        }
      });
    }
    _startSyncListener();
  }

  void _startSyncListener() {
    final stream = widget.apiType.toLowerCase() == 'farm'
        ? getFarmsRxObj.fillData
        : widget.apiType.toLowerCase() == 'ranch'
        ? getRanchesRxObj.fillData
        : getEventsRxObj.fillData;

    _syncSub = stream.listen((model) {
      if (!mounted) return;

      bool? newFav;
      bool? newVisited;

      if (model is FarmsModel) {
        final farm = model.data?.farms?.firstWhere(
          (f) => f.id.toString() == widget.itemId,
          orElse: () => Farm(),
        );
        if (farm?.id != null) {
          newFav = farm!.isFavorite;
          newVisited = farm.isVisited;
        }
      } else if (model is RancheModel) {
        final ranch = model.data?.ranches?.firstWhere(
          (r) => r.id.toString() == widget.itemId,
          orElse: () => Ranch(),
        );
        if (ranch?.id != null) {
          newFav = ranch!.isFavorite;
          newVisited = ranch.isVisited;
        }
      } else if (model is EventsModel) {
        final event = model.data?.events?.firstWhere(
          (e) => e.id.toString() == widget.itemId,
          // orElse: () => Event(),
        );
        if (event?.id != null) {
          newFav = event!.isFavorite;
          newVisited = event.isVisited;
        }
      }

      if (newFav != null || newVisited != null) {
        setState(() {
          if (newFav != null && !_favLoading) {
            _favHighlighted = newFav;
          }
          if (newVisited != null && !_visitedLoading) {
            _visitedHighlighted = newVisited;
          }
        });
      }
    });
  }

  @override
  void didUpdateWidget(LocationDetailsBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIsFavourite != oldWidget.initialIsFavourite) {
      _favHighlighted = widget.initialIsFavourite ?? false;
    }
    if (widget.initialIsVisited != oldWidget.initialIsVisited) {
      _visitedHighlighted = widget.initialIsVisited ?? false;
    }
  }

  @override
  void dispose() {
    _distanceSub?.cancel();
    _syncSub?.cancel();
    super.dispose();
  }

  Future<void> _postVisited() async {
    if (widget.itemId.isEmpty) {
      ToastUtil.showErrorMessage('Missing place id');
      return;
    }
    if (_visitedLoading || _visitedHighlighted) return;

    final oldState = _visitedHighlighted;
    setState(() {
      _visitedLoading = true;
      _visitedHighlighted = true;
    });
    widget.onVisitedChanged?.call(true);

    final ok = await postVisitedRxObj.postVisited(
      type: widget.apiType,
      id: widget.itemId,
    );

    if (!mounted) return;
    setState(() => _visitedLoading = false);

    if (ok) {
      getVisitedRxObj.fetchVisitedData();
      ToastUtil.showSuccessMessage('Marked as visited');
    } else {
      setState(() => _visitedHighlighted = oldState);
      widget.onVisitedChanged?.call(oldState);
    }
  }

  Future<void> _postFavorite() async {
    if (widget.itemId.isEmpty) {
      ToastUtil.showErrorMessage('Missing place id');
      return;
    }
    if (_favLoading) return;

    final oldState = _favHighlighted;
    setState(() {
      _favLoading = true;
      _favHighlighted = !_favHighlighted;
    });
    widget.onFavouriteChanged?.call(_favHighlighted);

    final result = await postFavouritesRxObj.postFavourites(
      type: widget.apiType,
      id: widget.itemId,
    );

    if (!mounted) return;
    setState(() => _favLoading = false);

    if (result != null) {
      setState(() => _favHighlighted = result.isFavorite);
      widget.onFavouriteChanged?.call(result.isFavorite);
      getFavouriteRxObj.fetchFavoritesData();
      final msg = result.message.isNotEmpty
          ? result.message
          : (result.isFavorite
                ? 'Added to favorites'
                : 'Removed from favorites');
      ToastUtil.showSuccessMessage(msg);
    } else {
      setState(() => _favHighlighted = oldState);
      widget.onFavouriteChanged?.call(oldState);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,

        top: 12.h,
        bottom: 12.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.cFFFFFF,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 4.h,
                width: 48.w,
                decoration: BoxDecoration(
                  color: AppColors.cADADAD.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            UIHelper.verticalSpace(16.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: TextFontStyle.headline20w600c303030Inter,
                      ),
                      UIHelper.verticalSpace(4.h),
                      if (widget.apiType.toLowerCase() == 'event')
                        StreamBuilder<EventDetailsModel>(
                          stream: eventDetailsRxObj.eventdetails,
                          builder: (context, snapshot) {
                            final description =
                                snapshot.data?.data?.event?.description;
                            if (description == null || description.isEmpty)
                              return SizedBox();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  description,
                                  style: TextFontStyle
                                      .headline14w400cADADADInter
                                      .copyWith(color: AppColors.c7C7C7C),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            );
                          },
                        ),
                      UIHelper.verticalSpace(4.h),
                      Divider(color: AppColors.cADADAD.withValues(alpha: 0.4)),
                      Text(
                        widget.address,
                        style: TextFontStyle.headline14w400cADADADInter
                            .copyWith(color: AppColors.c7C7C7C),
                      ),
                    ],
                  ),
                ),
                UIHelper.horizontalSpace(8.w),
                _actionIcon(
                  loading: _visitedLoading,
                  isSelected: _visitedHighlighted == true,
                  defaultAsset: _visitedHighlighted == true
                      ? Assets.icons.visitedGreen
                      : Assets.icons.unselcteLocation,
                  onTap: _visitedLoading || _visitedHighlighted
                      ? () {}
                      : _postVisited,
                ),
                UIHelper.horizontalSpace(12.w),
                _actionIcon(
                  loading: _favLoading,
                  isSelected: _favHighlighted,
                  defaultAsset: _favHighlighted
                      ? Assets.icons.favoriteSelect
                      : Assets.icons.favoriteUnselect,
                  onTap: _favLoading ? () {} : _postFavorite,
                ),
              ],
            ),
            UIHelper.verticalSpace(16.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: widget.type.toLowerCase() == 'farm'
                        ? AppColors.c34A853
                        : widget.type.toLowerCase() == 'ranch'
                        ? AppColors.cB16341
                        : AppColors.c964BFF,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Text(
                    widget.type,
                    style: TextFontStyle.headline12w400cFFFFFFInter,
                  ),
                ),
                UIHelper.horizontalSpace(12.w),
                Text(
                  '(${_currentDisplayedDistance.toStringAsFixed(1)} KM)',
                  //'(${_currentDisplayedDistance.toStringAsFixed(1)} KM approx)'
                  style: TextFontStyle.headline14w400cADADADInter.copyWith(
                    color: widget.isNavigatingCurrently
                        ? AppColors.c2C6E49
                        : AppColors.c7C7C7C,
                    fontWeight: widget.isNavigatingCurrently
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                if (widget.isNavigatingCurrently) ...[
                  UIHelper.horizontalSpace(8.w),
                  Text(
                    'REMAINING',
                    style: TextFontStyle.headline12w400cFFFFFFInter.copyWith(
                      color: AppColors.c2C6E49,
                      fontSize: 10.sp,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ],
            ),
            UIHelper.verticalSpace(16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      Assets.icons.person,
                      height: 16.sp,
                      colorFilter: const ColorFilter.mode(
                        AppColors.c7C7C7C,
                        BlendMode.srcIn,
                      ),
                    ),
                    UIHelper.horizontalSpace(8.w),
                    Text(
                      widget.ownerName.isNotEmpty ? widget.ownerName : 'N/A',
                      style: TextFontStyle.headline14w400cADADADInter.copyWith(
                        color: AppColors.c7C7C7C,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      Assets.icons.phoneIcon,
                      height: 16.sp,
                      colorFilter: const ColorFilter.mode(
                        AppColors.c7C7C7C,
                        BlendMode.srcIn,
                      ),
                    ),
                    UIHelper.horizontalSpace(8.w),
                    widget.apiType.toLowerCase() == 'event'
                        ? StreamBuilder<EventDetailsModel>(
                            stream: eventDetailsRxObj.eventdetails,
                            builder: (context, snapshot) {
                              final phone =
                                  snapshot.data?.data?.event?.phone ??
                                  widget.phone;
                              return GestureDetector(
                                onTap: () async {
                                  if (phone.isNotEmpty) {
                                    final uri = Uri(scheme: 'tel', path: phone);
                                    if (await canLaunchUrl(uri)) {
                                      await launchUrl(uri);
                                    } else {
                                      ToastUtil.showErrorMessage(
                                        'Could not open dialer',
                                      );
                                    }
                                  }
                                },
                                child: Text(
                                  phone.isNotEmpty ? phone : 'N/A',
                                  style: TextFontStyle
                                      .headline14w400cADADADInter
                                      .copyWith(color: AppColors.c7C7C7C),
                                ),
                              );
                            },
                          )
                        : GestureDetector(
                            onTap: () async {
                              if (widget.phone.isNotEmpty) {
                                final uri = Uri(
                                  scheme: 'tel',
                                  path: widget.phone,
                                );
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                } else {
                                  ToastUtil.showErrorMessage(
                                    'Could not open dialer',
                                  );
                                }
                              }
                            },
                            child: Text(
                              widget.phone.isNotEmpty ? widget.phone : 'N/A',
                              style: TextFontStyle.headline14w400cADADADInter
                                  .copyWith(color: AppColors.c7C7C7C),
                            ),
                          ),
                  ],
                ),
              ],
            ),
            UIHelper.verticalSpace(16.h),
            widget.apiType.toLowerCase() == 'event'
                ? StreamBuilder<EventDetailsModel>(
                    stream: eventDetailsRxObj.eventdetails,
                    builder: (context, snapshot) {
                      final event = snapshot.data?.data?.event;
                      final email = event?.email ?? widget.email;
                      final website = event?.website ?? widget.website;
                      return Column(
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                Assets.icons.email,
                                height: 16.sp,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.c7C7C7C,
                                  BlendMode.srcIn,
                                ),
                              ),
                              UIHelper.horizontalSpace(8.w),
                              SizedBox(
                                child: GestureDetector(
                                  onTap: () {
                                    if (email != null && email.isNotEmpty) {
                                      Clipboard.setData(
                                        ClipboardData(text: email),
                                      );
                                      ToastUtil.showSuccessMessage(
                                        'Email copied',
                                      );
                                    }
                                  },
                                  child: Text(
                                    (email?.isNotEmpty ?? false)
                                        ? email!
                                        : 'N/A',
                                    style: TextFontStyle
                                        .headline14w400cADADADInter
                                        .copyWith(color: AppColors.c7C7C7C),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          UIHelper.verticalSpace(12.h),
                          Row(
                            children: [
                              Icon(
                                Icons.language,
                                size: 16.sp,
                                color: AppColors.c7C7C7C,
                              ),
                              UIHelper.horizontalSpace(8.w),
                              SizedBox(
                                // width: 80.w,
                                child: GestureDetector(
                                  onTap: () async {
                                    if (website?.isNotEmpty ?? false) {
                                      String url = website!.trim();
                                      if (!url.startsWith('http://') &&
                                          !url.startsWith('https://')) {
                                        url = 'https://$url';
                                      }
                                      final uri = Uri.parse(url);
                                      try {
                                        await launchUrl(
                                          uri,
                                          mode: LaunchMode.externalApplication,
                                        );
                                      } catch (e) {
                                        ToastUtil.showErrorMessage(
                                          'Could not open website',
                                        );
                                      }
                                    }
                                  },
                                  child: Text(
                                    (website?.isNotEmpty ?? false)
                                        ? website!
                                        : 'N/A',
                                    style: TextFontStyle
                                        .headline14w400cADADADInter
                                        .copyWith(
                                          color: (website?.isNotEmpty ?? false)
                                              ? AppColors.c2C6E49
                                              : AppColors.c7C7C7C,
                                          decoration:
                                              (website?.isNotEmpty ?? false)
                                              ? TextDecoration.underline
                                              : TextDecoration.none,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            Assets.icons.email,
                            height: 16.sp,
                            colorFilter: const ColorFilter.mode(
                              AppColors.c7C7C7C,
                              BlendMode.srcIn,
                            ),
                          ),
                          UIHelper.horizontalSpace(8.w),
                          SizedBox(
                            width: 100.w,
                            child: Text(
                              (widget.email?.isNotEmpty ?? false)
                                  ? widget.email!
                                  : 'N/A',
                              style: TextFontStyle.headline14w400cADADADInter
                                  .copyWith(color: AppColors.c7C7C7C),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.language,
                            size: 16.sp,
                            color: AppColors.c7C7C7C,
                          ),
                          UIHelper.horizontalSpace(8.w),
                          SizedBox(
                            width: 100.w,
                            child: Text(
                              (widget.website?.isNotEmpty ?? false)
                                  ? widget.website!
                                  : 'N/A',
                              style: TextFontStyle.headline14w400cADADADInter
                                  .copyWith(color: AppColors.c7C7C7C),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
            UIHelper.verticalSpace(24.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.isNavigatingCurrently
                    ? widget.onStopNavigation
                    : widget.onStartNavigation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.isNavigatingCurrently
                      ? AppColors.cEA4335
                      : AppColors.c2C6E49,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      widget.isNavigatingCurrently
                          ? Assets.icons.deleted
                          : Assets.icons.start,
                      height: 18.sp,
                      colorFilter: const ColorFilter.mode(
                        AppColors.cFFFFFF,
                        BlendMode.srcIn,
                      ),
                    ),
                    UIHelper.horizontalSpace(8.w),
                    Text(
                      widget.isNavigatingCurrently
                          ? 'Stop Navigation'
                          : 'Start Navigation',
                      style: TextFontStyle.headline16w700cFFFFFFInter,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionIcon({
    required bool loading,
    required bool isSelected,
    required String defaultAsset,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.cF0F0F0,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: loading ? null : onTap,
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: loading
              ? SizedBox(
                  width: 20.sp,
                  height: 20.sp,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.c4C956C,
                  ),
                )
              : SvgPicture.asset(
                  defaultAsset,
                  height: 20.sp,
                  colorFilter: ColorFilter.mode(
                    isSelected ? AppColors.c4C956C : AppColors.cADADAD,
                    BlendMode.srcIn,
                  ),
                ),
        ),
      ),
    );
  }
}
