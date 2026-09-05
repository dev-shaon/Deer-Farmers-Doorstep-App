import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/features/favorites/model/favourite_model.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/helpers_method.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';
import 'package:size_matter_swt/networks/api_access.dart';

class FavoritesLists extends StatefulWidget {
  final Favorite favorite;
  final VoidCallback onTitleTap;

  const FavoritesLists({
    super.key,
    required this.favorite,
    required this.onTitleTap,
  });

  @override
  State<FavoritesLists> createState() => _FavoritesListsState();
}

class _FavoritesListsState extends State<FavoritesLists> {
  bool isExpanded = false;
  String? _address;

  Item? get item => widget.favorite.item;

  @override
  void initState() {
    super.initState();
    _fetchAddress();
  }

  Future<void> _fetchAddress() async {
    // If the model already has it, use it
    if (item?.resolvedAddress != null && item!.resolvedAddress!.isNotEmpty) {
      if (mounted) setState(() => _address = item!.resolvedAddress);
      return;
    }

    // Otherwise, convert lat/lon to address
    if (item?.latitude != null && item?.longitude != null) {
      final latLng = LatLng(item!.latitude!, item!.longitude!);
      final resolved = await getAddressFromLatLng(latLng);
      if (mounted) {
        setState(() {
          _address = resolved;
          item?.resolvedAddress = resolved; // Cache in model instance
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: () => setState(() => isExpanded = !isExpanded),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColors.cFFFFFF,
          border: Border.all(color: AppColors.cADADAD),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title + Action Buttons ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: widget.onTitleTap,
                    child: Text(
                      item?.name ?? '',
                      style: TextFontStyle.headline16w500c303030Inter.copyWith(
                        color: AppColors.c303030,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(7.r),
                      decoration: BoxDecoration(
                        color: AppColors.cADADAD.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      child: SvgPicture.asset(
                        Assets.icons.favoriteUnselect,
                        height: 18.h,
                        width: 18.w,
                      ),
                    ),
                    UIHelper.horizontalSpace(10.w),
                    GestureDetector(
                      onTap: () {
                        showCustomDialog(
                          context: context,
                          subTitile:
                              'You want to delete this \nlocation from saved \nfarm list?',
                          confirmButtonName: 'Delete',
                          confirmBorderColor: AppColors.cADADAD.withValues(
                            alpha: 0.2,
                          ),
                          confirmTextColor: AppColors.cEA4335,
                          cancleButtonName: 'Cancel',
                          yesTap: () async {
                            await postFavouritesRxObj.deleteFavourites(
                              widget.favorite.id.toString(),
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(7.r),
                        decoration: BoxDecoration(
                          color: AppColors.cADADAD.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(18.r),
                        ),
                        child: SvgPicture.asset(
                          Assets.icons.deleted,
                          height: 18.h,
                          width: 18.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // ── Display the converted address ──
            if (_address != null && _address!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Text(
                  _address!,
                  style: TextFontStyle.headline14w400cADADADInter.copyWith(
                    color: AppColors.c7C7C7C,
                  ),
                ),
              )
            else if (item?.latitude != null && item?.longitude != null)
              Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Text(
                  'Fetching address...',
                  style: TextFontStyle.headline14w400cADADADInter.copyWith(
                    color: AppColors.cADADAD,
                    fontSize: 12.sp,
                  ),
                ),
              ),

            // ── Expanded Details ──
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isExpanded
                  ? Column(
                      children: [
                        UIHelper.verticalSpace(16.h),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5.r),
                              decoration: BoxDecoration(
                                color: AppColors.cADADAD.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: SvgPicture.asset(
                                Assets.icons.person,
                                height: 16.h,
                                width: 16.w,
                              ),
                            ),
                            UIHelper.horizontalSpace(6.w),
                            Text(
                              item?.ownerName ?? 'N/A',
                              style: TextFontStyle.headline14w400cADADADInter
                                  .copyWith(color: AppColors.c7C7C7C),
                            ),
                            const Spacer(),
                            Container(
                              padding: EdgeInsets.all(5.r),
                              decoration: BoxDecoration(
                                color: AppColors.cADADAD.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: SvgPicture.asset(
                                Assets.icons.phoneIcon,
                                height: 16.h,
                                width: 16.w,
                              ),
                            ),
                            UIHelper.horizontalSpace(6.w),
                            Text(
                              item?.ownerPhone ?? 'N/A',
                              style: TextFontStyle.headline14w400cADADADInter
                                  .copyWith(color: AppColors.c7C7C7C),
                            ),
                          ],
                        ),
                      ],
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
