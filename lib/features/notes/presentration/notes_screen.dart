import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/all_routes.dart';
import 'package:size_matter_swt/helpers/navigation_service.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';
import 'package:size_matter_swt/networks/api_access.dart';
import 'package:size_matter_swt/features/notes/model/all_note_model.dart';
import 'package:size_matter_swt/features/notes/presentration/widget/custom_task_card.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  void initState() {
    super.initState();
    getAllNotesRxObj.getAllNotesData();
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
            Spacer(),
            Text("Take Notes", style: TextFontStyle.headline24w700c303030Inter),
            Spacer(),
            SizedBox(width: 24.w),
          ],
        ),
        elevation: 4,
        shadowColor: AppColors.cADADAD.withValues(alpha: 0.5),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.scaffoldColor, AppColors.cE6FFF1],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<AllNotesModel>(
          stream: getAllNotesRxObj.fillData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const _NotesGridShimmer();
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error loading notes: ${snapshot.error}",
                  style: TextStyle(fontSize: 16.sp, color: Colors.red),
                ),
              );
            }

            final model = snapshot.data;
            final notes = model?.data?.notes;

            if (notes == null || notes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(Assets.icons.emptyIcon),
                    UIHelper.verticalSpace(10.h),
                    Text(
                      "No note available to show.",
                      style: TextFontStyle.headline20w500c303030Inter.copyWith(
                        color: AppColors.cADADAD,
                      ),
                    ),
                  ],
                ),
              );
            }

            return GridView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(16.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 0.85,
              ),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];

                Color titleBgColor = AppColors.c2196F3;
                if (note.color != null && note.color!.isNotEmpty) {
                  try {
                    String hexColor = note.color!.replaceAll("#", "");
                    if (hexColor.length == 6) {
                      titleBgColor = Color(int.parse("0xFF$hexColor"));
                    } else if (hexColor.length == 8) {
                      titleBgColor = Color(int.parse("0x$hexColor"));
                    } else {
                      titleBgColor = Color(int.parse(hexColor));
                    }
                  } catch (_) {
                    titleBgColor = AppColors.c2196F3;
                  }
                }

                return GestureDetector(
                  onTap: () {
                    NavigationService.navigateToWithArgs(
                      Routes.addNotes,
                      {'noteId': note.id},
                    );
                  },
                  child: CustomTaskCard(
                    title: note.title ?? "Untitled",
                    description: note.content ?? "",
                    titleBgColor: titleBgColor,
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NavigationService.navigateTo(Routes.addNotes);
        },
        backgroundColor: AppColors.c4C956C,
        foregroundColor: AppColors.cFFFFFF,
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: SvgPicture.asset(Assets.icons.addIcon),
        ),
      ),
    );
  }
}

// Private Shimmer Grid widget to mimic note cards
class _NotesGridShimmer extends StatelessWidget {
  const _NotesGridShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: GridView.builder(
        padding: EdgeInsets.all(16.w),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 0.85,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
          );
        },
      ),
    );
  }
}
