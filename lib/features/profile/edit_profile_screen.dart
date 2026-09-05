import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:size_matter_swt/common/custom_button.dart';
import 'package:size_matter_swt/common/custom_form_field.dart';
import 'package:size_matter_swt/constants/text_font_style.dart';
import 'package:size_matter_swt/features/profile/presentation/widget/profile_card.dart';
import 'package:size_matter_swt/gen/assets.gen.dart';
import 'package:size_matter_swt/helpers/loading_helper.dart';
import 'package:size_matter_swt/helpers/navigation_service.dart';
import 'package:size_matter_swt/helpers/toast.dart';
import 'package:size_matter_swt/helpers/ui_helpers.dart';
import 'package:size_matter_swt/networks/api_access.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = true; // ✅ নতুন loading state

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    await getProfileRxobj.getProfile();
    if (!mounted) return;
    nameController.text = getProfileRxobj.name ?? '';
    emailController.text = getProfileRxobj.email ?? '';
    phoneController.text = getProfileRxobj.phone ?? '';
    setState(() {
      _isLoading = false; // ✅ data আসলে loading বন্ধ
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      await editProfileRxobj
          .updateAvatar(image: File(pickedFile.path))
          .waitingForSucess()
          .then((success) {
            if (success) {
              if (!mounted) return;
              ToastUtil.showSuccessMessage("Profile updated successfully");
              getProfileRxobj.getProfile();
              setState(() {
                _selectedImage = null;
              });
            }
          });
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Select Image",
                  style: TextFontStyle.headline16w600c303030Inter,
                ),
                UIHelper.verticalSpace(16.h),
                GestureDetector(
                  onTap: () {
                    NavigationService.goBack();
                    _pickImage(ImageSource.camera);
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(Assets.icons.cameraIcon),
                      UIHelper.horizontalSpace(12.w),
                      Text(
                        "Camera",
                        style: TextFontStyle.headline16w500cADADADInter,
                      ),
                    ],
                  ),
                ),
                UIHelper.verticalSpace(16.h),
                GestureDetector(
                  onTap: () {
                    NavigationService.goBack();
                    _pickImage(ImageSource.gallery);
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(Assets.icons.photoLibrary),
                      UIHelper.horizontalSpace(12.w),
                      Text(
                        "Gallery",
                        style: TextFontStyle.headline16w500cADADADInter,
                      ),
                    ],
                  ),
                ),
                UIHelper.verticalSpace(10.h),
              ],
            ),
          ),
        );
      },
    );
  }

  // ✅ Shimmer field — আসল field এর মতো একই height/shape
  Widget _shimmerField() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 52.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
          child: GestureDetector(
            onTap: () {
              NavigationService.goBack();
            },
            child: SvgPicture.asset(Assets.icons.arrowBack),
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.r),
        child: SingleChildScrollView(
          child: Column(
            children: [
              UIHelper.verticalSpace(_isLoading ? 20.h : 55.h),
              ProfileCard(
                isLoading: _isLoading,
                showEditIcon: true,
                selectedImage: _selectedImage,
                onTap: _showImagePickerOptions,
              ),

              UIHelper.verticalSpace(20.h),

              if (_isLoading) ...[
                _shimmerField(),
                UIHelper.verticalSpace(12.h),
                _shimmerField(),
                UIHelper.verticalSpace(12.h),
                _shimmerField(),
              ] else ...[
                CustomFormField(
                  controller: nameController,
                  prefixIcon: SvgPicture.asset(Assets.icons.person),
                  hintText: "Name",
                ),
                UIHelper.verticalSpace(12.h),
                CustomFormField(
                  controller: emailController,
                  prefixIcon: SvgPicture.asset(Assets.icons.email),
                  hintText: "Email",
                  isRead: true,
                ),
                UIHelper.verticalSpace(12.h),
                CustomFormField(
                  controller: phoneController,
                  prefixIcon: SvgPicture.asset(Assets.icons.phoneIcon),
                  hintText: "Add phone number",
                  inputType: TextInputType.phone,
                ),
              ],

              UIHelper.verticalSpace(250.h),

              CustomButton(
                onTap: _isLoading
                    ? () {}
                    : () async {
                        await updateProfileRx
                            .updateProfile(
                              name: nameController.text,
                              phone: phoneController.text,
                            )
                            .waitingForSucess()
                            .then((success) {
                              if (success) {
                                if (!mounted) return;
                                ToastUtil.showSuccessMessage(
                                  "Profile updated successfully",
                                );
                                getProfileRxobj.getProfile();
                                NavigationService.goBack();
                              }
                            });
                      },
                btnName: "Save",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
