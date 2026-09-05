import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/gen/colors.gen.dart';
import 'package:size_matter_swt/helpers/helpers_method.dart';
import 'package:size_matter_swt/helpers/navigation_service.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';
import 'package:size_matter_swt/networks/api_access.dart';

class AddNotes extends StatefulWidget {
  final int? noteId;
  const AddNotes({super.key, this.noteId});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  Color _selectedColor = AppColors.c2196F3;
  int? _noteId;
  Timer? _debounceTimer;
  StreamSubscription? _autoSaveSubscription;
  StreamSubscription? _detailsSubscription;
  bool _isSaving = false;
  bool _isLoadingDetails = false;

  @override
  void initState() {
    super.initState();

    // Clear previous note states to prevent cached data flashing
    autoSaveNoteRxObj.clean();
    noteDetailsRxObj.clean();

    _titleController.addListener(_onTextChanged);
    _contentController.addListener(_onTextChanged);

    // Listen to AutoSaveRx stream to capture the Note ID on success (for a newly created note)
    _autoSaveSubscription = autoSaveNoteRxObj.dataFetcher.listen((data) {
      if (data != null && data.isNotEmpty) {
        log("AutoSave response received: $data");
        int? responseId;

        // Extract note ID safely from the JSON response
        if (data['data'] != null) {
          if (data['data']['note'] != null &&
              data['data']['note']['id'] != null) {
            responseId = int.tryParse(data['data']['note']['id'].toString());
          } else if (data['data']['id'] != null) {
            responseId = int.tryParse(data['data']['id'].toString());
          }
        }
        if (responseId == null && data['id'] != null) {
          responseId = int.tryParse(data['id'].toString());
        }

        // Lock in the note ID on the first successful API response
        if (responseId != null && _noteId == null) {
          setState(() {
            _noteId = responseId;
          });
          log("Note ID successfully captured and set to: $_noteId");
        }
      }
    });

    // If an existing note ID is passed, fetch its details and pre-populate the fields
    if (widget.noteId != null) {
      _noteId = widget.noteId;
      _isLoadingDetails = true; // Trigger details loading shimmer

      _detailsSubscription = noteDetailsRxObj.dataFetcher.listen(
        (details) {
          if (details.data != null && details.data!.note != null) {
            final note = details.data!.note!;

            // Temporary remove listeners to prevent triggering immediate auto-save during population
            _titleController.removeListener(_onTextChanged);
            _contentController.removeListener(_onTextChanged);

            _titleController.text = note.title ?? '';
            _contentController.text = note.content ?? '';

            // Parse color safely
            if (note.color != null && note.color!.isNotEmpty) {
              try {
                String hexColor = note.color!.replaceAll("#", "");
                if (hexColor.length == 6) {
                  _selectedColor = Color(int.parse("0xFF$hexColor"));
                } else if (hexColor.length == 8) {
                  _selectedColor = Color(int.parse("0x$hexColor"));
                } else {
                  _selectedColor = Color(int.parse(hexColor));
                }
              } catch (_) {
                _selectedColor = AppColors.c2196F3;
              }
            }

            // Restore listeners
            _titleController.addListener(_onTextChanged);
            _contentController.addListener(_onTextChanged);

            setState(() {
              _isLoadingDetails = false; // Hide details loading shimmer
            });
          }
        },
        onError: (err) {
          setState(() {
            _isLoadingDetails = false;
          });
        },
      );
      noteDetailsRxObj.fetchNoteDetails(widget.noteId!.toString());
    }
  }

  @override
  void dispose() {
    _titleController.removeListener(_onTextChanged);
    _contentController.removeListener(_onTextChanged);
    _titleController.dispose();
    _contentController.dispose();
    _debounceTimer?.cancel();
    _autoSaveSubscription?.cancel();
    _detailsSubscription?.cancel();
    autoSaveNoteRxObj.clean();
    noteDetailsRxObj.clean();
    super.dispose();
  }

  void _onTextChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 1000), () {
      _autoSaveNote();
    });
  }

  String _colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  void _autoSaveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    // The backend requires the content field to be present and non-empty.
    // We only auto-save if some content has been entered to prevent 422 validation errors.
    if (content.isEmpty) {
      return;
    }

    if (_isSaving) return;
    _isSaving = true;

    try {
      final colorHex = _colorToHex(_selectedColor);
      log(
        "Triggering auto-save. ID: $_noteId, Title: $title, Content: $content, Color: $colorHex",
      );
      await autoSaveNoteRxObj.post(
        id: _noteId,
        title: title,
        content: content,
        color: colorHex,
      );
    } catch (e) {
      log("Error during auto-save: $e");
    } finally {
      _isSaving = false;
    }
  }

  void _goBackAndRefresh() {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
      _autoSaveNote();
    }
    getAllNotesRxObj.getAllNotesData();
    NavigationService.goBack();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: _goBackAndRefresh,
              child: SvgPicture.asset(Assets.icons.arrowBack),
            ),
            Spacer(),
            Text("Add Notes", style: TextFontStyle.headline24w700c303030Inter),
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
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.scaffoldColor, AppColors.cE6FFF1],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isLoadingDetails
            ? const _AddNoteShimmer()
            : Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Title',
                      hintStyle: TextStyle(fontSize: 20.sp, color: Colors.grey),
                      border: InputBorder.none,
                      suffixIcon: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5.h,
                          horizontal: 6.w,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            _showMoreOptions(context);
                          },
                          child: SvgPicture.asset(
                            Assets.icons.threeDot,
                            width: 5.w,
                            height: 5.h,
                            colorFilter: ColorFilter.mode(
                              AppColors.c34A853,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                    style: TextFontStyle.headline20w500c303030Inter,
                  ),
                  Divider(color: Colors.black12.withValues(alpha: 0.2)),
                  Expanded(
                    child: TextField(
                      controller: _contentController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        hintText: 'Note',
                        hintStyle: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setBottomSheetState) {
            return Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppColors.cE6FFF1,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Edited just now",
                    style: TextFontStyle.headline20w500c303030Inter.copyWith(
                      color: AppColors.cADADAD,
                    ),
                  ),
                  UIHelper.verticalSpace(20.h),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Color: ",
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        _buildColorOption(
                          AppColors.c34A853,
                          setBottomSheetState,
                        ),
                        SizedBox(width: 8.w),
                        _buildColorOption(
                          AppColors.c2196F3,
                          setBottomSheetState,
                        ),
                        SizedBox(width: 8.w),
                        _buildColorOption(
                          AppColors.c964BFF,
                          setBottomSheetState,
                        ),
                        SizedBox(width: 8.w),
                        _buildColorOption(
                          AppColors.cB16341,
                          setBottomSheetState,
                        ),
                      ],
                    ),
                  ),
                  UIHelper.verticalSpace(15.h),
                  GestureDetector(
                    onTap: () {
                      showCustomDialog(
                        context: context,
                        subTitile: "Are you sure you want to delete this note?",
                        confirmButtonName: "Delete",
                        cancleButtonName: "Cancel",
                        confirmTextColor: AppColors.cFF0000,
                        yesTap: () async {
                          if (_noteId != null) {
                            bool success = await deleteNotesRxObj.post(
                              id: _noteId!.toString(),
                            );
                            if (success) {
                              getAllNotesRxObj.getAllNotesData();
                              NavigationService.goBack();
                              NavigationService.goBack();
                            } else {
                              NavigationService.goBack();
                              NavigationService.goBack();
                            }
                          }
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            Assets.icons.deleted,
                            height: 24.h,
                            width: 24.w,
                          ),
                          UIHelper.horizontalSpace(10.w),
                          Text(
                            "Delete",
                            style: TextFontStyle.headline20w500c303030Inter
                                .copyWith(color: AppColors.cFF0000),
                          ),
                        ],
                      ),
                    ),
                  ),
                  UIHelper.verticalSpace(20.h),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildColorOption(Color color, StateSetter setBottomSheetState) {
    final isSelected = _selectedColor == color;
    return GestureDetector(
      onTap: () {
        setBottomSheetState(() {
          _selectedColor = color;
        });
        setState(() {});
        _autoSaveNote();
      },
      child: Container(
        width: 40.w,
        height: 25.h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5.r),
          border: isSelected
              ? Border.all(
                  color: Colors.black54,
                  width: 2,
                  style: BorderStyle.solid,
                )
              : null,
        ),
      ),
    );
  }
}

// Private Shimmer details placeholder
class _AddNoteShimmer extends StatelessWidget {
  const _AddNoteShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Line Shimmer Box
          Container(
            width: 150.w,
            height: 26.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.r),
            ),
          ),
          UIHelper.verticalSpace(25.h),
          // Content Line 1 Shimmer Box
          Container(
            width: double.infinity,
            height: 16.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.r),
            ),
          ),
          UIHelper.verticalSpace(12.h),
          // Content Line 2 Shimmer Box
          Container(
            width: double.infinity,
            height: 16.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.r),
            ),
          ),
          UIHelper.verticalSpace(12.h),
          // Content Line 3 Shimmer Box
          Container(
            width: 200.w,
            height: 16.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.r),
            ),
          ),
        ],
      ),
    );
  }
}
