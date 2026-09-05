import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:size_matter_swt/common/custom_button.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/features/search/presentation/widget/role_seleted.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';

class SearchFilter extends StatefulWidget {
  final int initialSelectedPlaces;
  const SearchFilter({super.key, this.initialSelectedPlaces = -1});

  @override
  State<SearchFilter> createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  int selectedIndex = -1;
  late int selectedPlaces;
  List<String> roleNames = [
    "Show Farms Only",
    "Show Ranches Only",
    "Show Events Only",
  ];
  List<String> placesNames = ["Visited Places", "Not Visited"];

  @override
  void initState() {
    super.initState();
    selectedPlaces = widget.initialSelectedPlaces;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 12.h),
      decoration: BoxDecoration(
        color: Color(0xFFFFFDF8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
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
          Container(
            decoration: BoxDecoration(
              color: AppColors.c2C6E49.withValues(alpha: 0.04),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
              child: Row(
                children: [
                  Spacer(),
                  Text(
                    'Filter',
                    style: TextFontStyle.headline20w600c303030Inter.copyWith(
                      color: AppColors.c303030.withValues(alpha: 0.8),
                    ),
                  ),
                  UIHelper.horizontalSpace(105.w),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context, -1);
                    },
                    child: Text(
                      'Reset',
                      style: TextFontStyle.headline14w400cADADADInter.copyWith(
                        color: AppColors.c34A853,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          UIHelper.verticalSpace(16.h),

          GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 3.4,
            ),
            itemCount: placesNames.length,
            itemBuilder: (context, index) {
              return RoleSeleted(
                text: placesNames[index],
                isSelected: selectedPlaces == index,
                onTap: () {
                  setState(() {
                    selectedPlaces = index;
                  });
                },
              );
            },
          ),
          UIHelper.verticalSpace(20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CustomButton(
              onTap: () {
                Navigator.pop(context, selectedPlaces);
              },
              btnName: "Apply Filter",
            ),
          ),
          UIHelper.verticalSpace(40.h),
        ],
      ),
    );
  }
}

