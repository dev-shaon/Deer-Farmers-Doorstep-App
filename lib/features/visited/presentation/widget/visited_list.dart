import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/features/visited/model/visited_model.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/helpers_method.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';
import 'package:size_matter_swt/networks/api_access.dart';

class VisitedList extends StatefulWidget {
  final Visited visited;
  final VoidCallback onTitleTap;

  const VisitedList({
    super.key,
    required this.visited,
    required this.onTitleTap,
  });

  @override
  State<VisitedList> createState() => _VisitedListState();
}

class _VisitedListState extends State<VisitedList> {
  bool isExpanded = false;
  String? _address;

  Item? get item => widget.visited.item;

  @override
  void initState() {
    super.initState();
    _fetchAddress();
  }

  Future<void> _fetchAddress() async {
    if (item?.resolvedAddress != null && item!.resolvedAddress!.isNotEmpty) {
      if (mounted) setState(() => _address = item!.resolvedAddress);
      return;
    }

    final apiAddress = item?.address;
    if (apiAddress != null && apiAddress.isNotEmpty) {
      if (mounted) setState(() => _address = apiAddress);
      return;
    }

    if (item?.latitude != null && item?.longitude != null) {
      final latLng = LatLng(item!.latitude!, item!.longitude!);
      final resolved = await getAddressFromLatLng(latLng);
      if (mounted) {
        setState(() {
          _address = resolved;
          item?.resolvedAddress = resolved;
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
          color: AppColors.cE6FFF1.withValues(alpha: 04),
          border: Border.all(color: AppColors.cADADAD),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                        Assets.icons.unselcteLocation,
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
                              'You want to delete this \nlocation from your \nvisited list?',
                          confirmButtonName: 'Delete',
                          confirmBorderColor: AppColors.cADADAD.withValues(
                            alpha: 0.2,
                          ),
                          confirmTextColor: AppColors.cEA4335,
                          cancleButtonName: 'Cancel',
                          yesTap: () async {
                            await postVisitedRxObj.deleteVisited(
                              widget.visited.id.toString(),
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
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isExpanded
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
