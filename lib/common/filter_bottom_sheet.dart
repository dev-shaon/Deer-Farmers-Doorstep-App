import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:size_matter_swt/common/custom_form_field.dart';
import 'package:size_matter_swt/common/row_widget.dart';
import 'package:size_matter_swt/common/two_button.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/navigation_service.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';


class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  int sort = 0;
  int price = 0;
  int category = 0;
  bool delivery = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 12.h),
      decoration: BoxDecoration(
        color: Color(0xFFFFFDF8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            UIHelper.verticalSpace(16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Filter and sort',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  UIHelper.horizontalSpace(80.w),
                  GestureDetector(
                    onTap: () {
                      NavigationService.goBack;
                    },
                    child: Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            UIHelper.verticalSpace(16.h),
            Divider(),

            FilterSection(
              title: 'Sort by',
              child: RadioGroup<int>(
                groupValue: sort,
                onChanged: (v) => setState(() => sort = v!),
                child: Column(
                  children: [
                    radioTile(
                      'Price: Low - High',
                      0,
                    ),
                    radioTile(
                      'Price: High - Low',
                      1,
                    ),
                  ],
                ),
              ),
            ),
            FilterSection(
              title: 'Delivery',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      UIHelper.horizontalSpace(6.w),
                      Text(
                        '⚡ 24 hour delivery',
                        style: TextFontStyle.headline16w600c303030Inter,
                      ),
                    ],
                  ),
                  Switch(
                    activeTrackColor: AppColors.c4C956C,
                    activeThumbColor: AppColors.c34A853,
                    value: delivery,
                    onChanged: (v) => setState(() => delivery = v),
                  ),
                ],
              ),
            ),
            FilterSection(
              title: 'Price',
              child: RadioGroup<int>(
                groupValue: price,
                onChanged: (v) => setState(() => price = v!),
                child: Column(
                  children: [
                    radioTile(
                      '\$0 - \$99',
                      0,
                    ),
                    radioTile(
                      '\$100 - \$199',
                      1,
                    ),
                    radioTile(
                      '\$200 - \$299',
                      2,
                    ),
                    radioTile(
                      '\$300 - \$399',
                      3,
                    ),
                    radioTile(
                      '\$500+',
                      4,
                    ),
                  ],
                ),
              ),
            ),
            FilterSection(
              title: 'Subcategories',
              child: RadioGroup<int>(
                groupValue: category,
                onChanged: (v) => setState(() => category = v!),
                child: Column(
                  children: [
                    CustomFormField(
                      hintText: 'Search ',
                      prefixIcon: SvgPicture.asset(
                        Assets.icons.person,
                        height: 16.h,
                        width: 16.w,
                      ),
                    ),
                    UIHelper.verticalSpace(8.h),
                    radioTile(
                      'Featured',
                      0,
                    ),
                    radioTile(
                      'Actors',
                      1,
                    ),
                    radioTile(
                      'Reality TV',
                      2,
                    ),
                    radioTile(
                      'Creators',
                      3,
                    ),
                    radioTile(
                      'Professionals',
                      4,
                    ),
                  ],
                ),
              ),
            ),
            UIHelper.verticalSpace(150.h),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColors.c34A853.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: TwoButton(),
            ),

            UIHelper.verticalSpaceMedium,
          ],
        ),
      ),
    );
  }

  Widget radioTile(String text, int value) {
    return RadioListTile<int>(
      value: value,
      title: Text(text),
      activeColor: AppColors.c2C6E49,
      controlAffinity: ListTileControlAffinity.trailing,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }
}
