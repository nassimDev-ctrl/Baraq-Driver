import 'dart:io';

import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/home/presentation/widget/complaints/complaints_painters.dart';
import 'package:drever_warr/features/home/presentation/widget/complaints/complaints_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageUploadCard extends StatelessWidget {
  const ImageUploadCard({
    super.key,
    required this.images,
    required this.onAdd,
    required this.onRemove,
  });

  final List<File> images;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      width: double.infinity,
      padding: EdgeInsets.all(images.isEmpty ? 22.w : 14.w),
      decoration: BoxDecoration(
        color: ComplaintsUiConstants.uploadFill,
        borderRadius:
            BorderRadius.circular(ComplaintsUiConstants.cardRadius.r),
        boxShadow: ComplaintsUiConstants.cardShadow,
      ),
      child: DashedRoundedBorder(
        color: ComplaintsUiConstants.uploadBorder,
        radius: ComplaintsUiConstants.cardRadius.r,
        child: Padding(
          padding: EdgeInsets.all(2.w),
          child: images.isEmpty
              ? _EmptyUpload(onAdd: onAdd)
              : _ImagesGrid(
                  images: images,
                  onAdd: onAdd,
                  onRemove: onRemove,
                ),
        ),
      ),
    );
  }
}

class _EmptyUpload extends StatelessWidget {
  const _EmptyUpload({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onAdd,
      borderRadius: BorderRadius.circular(ComplaintsUiConstants.cardRadius.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 12.w),
        child: Column(
          children: [
            Container(
              width: 64.r,
              height: 64.r,
              decoration: BoxDecoration(
                color: AppColors.main1.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_a_photo_rounded,
                color: AppColors.main1,
                size: 28.sp,
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              AppTranslations.getText(context, 'tap_to_add_image'),
              style: TextStyle(
                color: AppColors.main1,
                fontSize: 15.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              AppTranslations.getText(context, 'upload_images_hint'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AuthUiConstants.mutedText,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagesGrid extends StatelessWidget {
  const _ImagesGrid({
    required this.images,
    required this.onAdd,
    required this.onRemove,
  });

  final List<File> images;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    final canAdd = images.length < ComplaintsUiConstants.maxImages;
    final itemCount = images.length + (canAdd ? 1 : 0);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        if (canAdd && index == images.length) {
          return InkWell(
            onTap: onAdd,
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: ComplaintsUiConstants.uploadBorder),
              ),
              child: Icon(
                Icons.add_rounded,
                color: AppColors.main1,
                size: 28.sp,
              ),
            ),
          );
        }

        return Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.file(images[index], fit: BoxFit.cover),
            ),
            Positioned(
              top: 6.h,
              right: 6.w,
              child: GestureDetector(
                onTap: () => onRemove(index),
                child: Container(
                  width: 26.r,
                  height: 26.r,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
