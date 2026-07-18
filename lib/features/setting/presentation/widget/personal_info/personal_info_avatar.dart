import 'dart:io';

import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/api_constants.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/features/setting/presentation/widget/personal_info/personal_info_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonalInfoAvatar extends StatelessWidget {
  const PersonalInfoAvatar({
    super.key,
    required this.networkImagePath,
    required this.pickedImagePath,
    required this.onEdit,
  });

  final String? networkImagePath;
  final String? pickedImagePath;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final resolvedUrl = ApiConstants.resolveMediaUrl(networkImagePath);
    final size = PersonalInfoUiConstants.avatarSize.r;

    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: PersonalInfoUiConstants.softShadow,
            ),
            child: ClipOval(
              child: pickedImagePath != null
                  ? Image.file(File(pickedImagePath!), fit: BoxFit.cover)
                  : resolvedUrl != null
                      ? Image.network(
                          resolvedUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.main1,
                                value: progress.expectedTotalBytes != null
                                    ? progress.cumulativeBytesLoaded /
                                        progress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) => Image.asset(
                            ImageAssets.imageprofail,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          ImageAssets.imageprofail,
                          fit: BoxFit.cover,
                        ),
            ),
          ),
          Positioned(
            right: 2.w,
            bottom: 2.h,
            child: Material(
              color: AppColors.main1,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onEdit,
                child: SizedBox(
                  width: 34.r,
                  height: 34.r,
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
