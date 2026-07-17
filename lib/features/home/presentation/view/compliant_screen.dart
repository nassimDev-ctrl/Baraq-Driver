import 'dart:io';

import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/app_snack_bar.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/complain_cubit/cubit.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/complain_cubit/cubit_state.dart';
import 'package:drever_warr/features/home/presentation/widget/complaints/complaint_text_field.dart';
import 'package:drever_warr/features/home/presentation/widget/complaints/complaint_tips_section.dart';
import 'package:drever_warr/features/home/presentation/widget/complaints/complaints_header.dart';
import 'package:drever_warr/features/home/presentation/widget/complaints/complaints_ui_constants.dart';
import 'package:drever_warr/features/home/presentation/widget/complaints/image_upload_card.dart';
import 'package:drever_warr/features/home/presentation/widget/complaints/privacy_card.dart';
import 'package:drever_warr/features/home/presentation/widget/complaints/submit_complaint_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({super.key});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<File> _images = [];
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _descriptionController
      ..removeListener(_onTextChanged)
      ..dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() => _charCount = _descriptionController.text.length);
  }

  Future<void> _showImageSourceSheet() async {
    if (_images.length >= ComplaintsUiConstants.maxImages) {
      AppSnackBar.info(
        context,
        AppTranslations.getText(context, 'max_images_reached'),
      );
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          child: Container(
            margin: EdgeInsets.all(16.w),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: ComplaintsUiConstants.softShadow,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  AppTranslations.getText(context, 'add_photo'),
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                    color: AuthUiConstants.textPrimary,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  AppTranslations.getText(context, 'choose_how_add_image'),
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AuthUiConstants.mutedText,
                  ),
                ),
                SizedBox(height: 16.h),
                _SourceTile(
                  icon: Icons.photo_library_rounded,
                  title: AppTranslations.getText(context, 'gallery'),
                  subtitle: AppTranslations.getText(
                    context,
                    'pick_image_from_device',
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickFromGallery();
                  },
                ),
                SizedBox(height: 10.h),
                _SourceTile(
                  icon: Icons.photo_camera_rounded,
                  title: AppTranslations.getText(context, 'camera'),
                  subtitle: AppTranslations.getText(
                    context,
                    'take_new_picture',
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickFromGallery() async {
    try {
      final remaining =
          ComplaintsUiConstants.maxImages - _images.length;
      if (remaining <= 0) return;

      final pickedFiles = await _picker.pickMultiImage(imageQuality: 85);
      if (pickedFiles.isEmpty) return;

      final accepted = <File>[];
      for (final picked in pickedFiles.take(remaining)) {
        final file = File(picked.path);
        final size = await file.length();
        if (size > ComplaintsUiConstants.maxImageSizeBytes) {
          if (!mounted) return;
          AppSnackBar.error(
            context,
            AppTranslations.getText(context, 'image_too_large'),
          );
          continue;
        }
        accepted.add(file);
      }

      if (accepted.isEmpty) return;
      setState(() => _images.addAll(accepted));
    } catch (_) {
      if (!mounted) return;
      AppSnackBar.error(
        context,
        AppTranslations.getText(context, 'could_not_pick_image'),
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      if (_images.length >= ComplaintsUiConstants.maxImages) return;

      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (pickedFile == null) return;

      final file = File(pickedFile.path);
      final fileSize = await file.length();

      if (fileSize > ComplaintsUiConstants.maxImageSizeBytes) {
        if (!mounted) return;
        AppSnackBar.error(
          context,
          AppTranslations.getText(context, 'image_too_large'),
        );
        return;
      }

      setState(() => _images.add(file));
    } catch (_) {
      if (!mounted) return;
      AppSnackBar.error(
        context,
        AppTranslations.getText(context, 'could_not_pick_image'),
      );
    }
  }

  void _removeImage(int index) {
    setState(() => _images.removeAt(index));
  }

  void _handleSend() {
    final description = _descriptionController.text.trim();

    if (description.isEmpty) {
      AppSnackBar.error(
        context,
        AppTranslations.getText(context, 'please_write_your_complaint'),
      );
      return;
    }

    // Keep existing API contract: single optional image.
    context.read<AddComplainCubit>().sendComplain(
          description: description,
          image: _images.isEmpty ? null : _images.first,
        );
  }

  Widget _fadeSlide({
    required int index,
    required Widget child,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 320 + (index * 60)),
      curve: Curves.easeOutCubic,
      builder: (context, value, animatedChild) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 16),
            child: animatedChild,
          ),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddComplainCubit, AddComplainState>(
      listener: (context, state) {
        if (state is AddComplainSuccess) {
          AppSnackBar.success(context, state.message);
          Navigator.pop(context);
        } else if (state is AddComplainFailure) {
          AppSnackBar.error(context, state.errMessage);
        }
      },
      builder: (context, state) {
        final isSending = state is AddComplainLoading;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FB),
          body: Column(
            children: [
              const Hero(
                tag: 'complaints_header',
                child: Material(
                  color: Colors.transparent,
                  child: ComplaintsHeader(),
                ),
              ),
              Expanded(
                child: Transform.translate(
                  offset: Offset(0, -22.h),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(
                          ComplaintsUiConstants.bodyTopRadius.r,
                        ),
                      ),
                      boxShadow: ComplaintsUiConstants.softShadow,
                    ),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        ComplaintsUiConstants.horizontalPadding.w,
                        22.h,
                        ComplaintsUiConstants.horizontalPadding.w,
                        28.h,
                      ),
                      children: [
                        _fadeSlide(
                          index: 0,
                          child: ImageUploadCard(
                            images: _images,
                            onAdd: _showImageSourceSheet,
                            onRemove: _removeImage,
                          ),
                        ),
                        SizedBox(
                          height: ComplaintsUiConstants.sectionSpacing.h,
                        ),
                        _fadeSlide(
                          index: 1,
                          child: ComplaintTextField(
                            controller: _descriptionController,
                            charCount: _charCount,
                          ),
                        ),
                        SizedBox(height: 14.h),
                        _fadeSlide(
                          index: 2,
                          child: const PrivacyCard(),
                        ),
                        SizedBox(
                          height: ComplaintsUiConstants.sectionSpacing.h,
                        ),
                        _fadeSlide(
                          index: 3,
                          child: const ComplaintTipsSection(),
                        ),
                        SizedBox(height: 22.h),
                        _fadeSlide(
                          index: 4,
                          child: SubmitComplaintButton(
                            isLoading: isSending,
                            onPressed: _handleSend,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SourceTile extends StatelessWidget {
  const _SourceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF8F8FB),
      borderRadius: BorderRadius.circular(18.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          child: Row(
            children: [
              Container(
                width: 46.r,
                height: 46.r,
                decoration: BoxDecoration(
                  color: AppColors.main1.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.main1, size: 22.sp),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.5.sp,
                        fontWeight: FontWeight.w700,
                        color: AuthUiConstants.textPrimary,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AuthUiConstants.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20.sp,
                color: AuthUiConstants.iconMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
