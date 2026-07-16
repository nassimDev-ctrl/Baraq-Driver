import 'dart:io';

import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/custom_button.dart';
import 'package:drever_warr/core/widgets/custom_text.dart';
import 'package:drever_warr/core/widgets/logo_app.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_car_image/cubit.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_car_image/cubit_stat.dart';
import 'package:drever_warr/features/presentation/view/car_registration_screen.dart';
import 'package:drever_warr/features/presentation/view/waiting_review_screen.dart';
import 'package:drever_warr/features/presentation/widgets/icon_bak.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:drever_warr/core/widgets/app_snack_bar.dart';

class Personalidentity extends StatefulWidget {
  final bool isUpdate;

  /// External error for the front image.
  /// Example: "Make sure to display your face in the page"
  final String? frontImageError;

  /// External error for the back image.
  final String? backImageError;

  const Personalidentity({
    super.key,
    required this.isUpdate,
    this.frontImageError,
    this.backImageError,
  });

  @override
  State<Personalidentity> createState() => _PersonalidentityState();
}

class _PersonalidentityState extends State<Personalidentity> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickIdImage(
      BuildContext context,
      ImageSource source,
      bool isFront,
      ) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 95,
    );

    if (pickedFile == null) return;

    final File originalFile = File(pickedFile.path);
    final File finalFile = await _compressImageToMax5Mb(originalFile);

    if (!mounted) return;

    setState(() {
      if (isFront) {
        context.read<UploadIdCubit>().frontImage = finalFile;
      } else {
        context.read<UploadIdCubit>().backImage = finalFile;
      }
    });
  }
  Future<File> _compressImageToMax5Mb(File file) async {
    const int maxBytes = 5 * 1024 * 1024;

    if (await file.length() <= maxBytes) {
      return file;
    }

    final Directory tempDir = await Directory.systemTemp.createTemp('id_images');
    final String outPath =
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    int quality = 90;
    File currentFile = file;

    while (quality >= 10) {
      final List<int>? compressedBytes =
      await FlutterImageCompress.compressWithFile(
        currentFile.path,
        quality: quality,
        minWidth: 1920,
        minHeight: 1920,
        keepExif: true,
        format: CompressFormat.jpeg,
      );

      if (compressedBytes == null) break;

      final File compressedFile = File(outPath);
      await compressedFile.writeAsBytes(compressedBytes, flush: true);

      if (await compressedFile.length() <= maxBytes) {
        return compressedFile;
      }

      currentFile = compressedFile;
      quality -= 10;
    }

    return currentFile;
  }

  @override
  Widget build(BuildContext context) {
    final uploadCubit = context.watch<UploadIdCubit>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<UploadIdCubit, UploadIdState>(
        listener: (context, state) {
          if (state is UploadIdSuccess) {
            AppSnackBar.success(context, AppTranslations.getText(context, "id_upload_success"));

            if (!widget.isUpdate) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CarRegistrationScreen(
                    isUpdate: false,
                  ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WaitingReviewScreen(),
                ),
              );
            }
          } else if (state is UploadIdFailure) {
            AppSnackBar.error(context, state.errMessage);
          }
        },
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              const IconBak(),
              const Center(child: LogoSection()),
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    border: Border.all(color: AppColors.main1, width: 1.5),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: 25.h),
                        CustomText(
                          "register_title",
                          type: AppTextType.bodyLarge,
                          color: AppColors.main1,
                        ),
                        SizedBox(height: 35.h),

                        _buildIdCaptureBox(
                          label: "add_front_id_photo",
                          imageFile: uploadCubit.frontImage,
                          errorMessage: widget.frontImageError,
                          onTap: () => _pickIdImage(
                            context,
                            ImageSource.gallery,
                            true,
                          ),
                        ),

                        SizedBox(height: 30.h),

                        _buildIdCaptureBox(
                          label: "add_back_id_photo",
                          imageFile: uploadCubit.backImage,
                          errorMessage: widget.backImageError,
                          onTap: () => _pickIdImage(
                            context,
                            ImageSource.gallery,
                            false,
                          ),
                        ),

                        SizedBox(height: 50.h),
                        BlocBuilder<UploadIdCubit, UploadIdState>(
                          builder: (context, state) {
                            if (state is UploadIdLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return CustomButton(
                              title: AppTranslations.getText(context, "next"),
                              onTap: () {
                                context.read<UploadIdCubit>().uploadIdImages();
                              },
                            );
                          },
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIdCaptureBox({
    required String label,
    File? imageFile,
    required VoidCallback onTap,
    String? errorMessage,
  }) {
    final bool hasError =
        errorMessage != null && errorMessage.trim().isNotEmpty;
    final Color borderColor = hasError ? Colors.red : AppColors.blue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomText(
          label,
          type: AppTextType.bodyMedium,
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 12.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 150.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),
              border: Border.all(color: borderColor, width: 2.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                if (imageFile != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      imageFile,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                _buildCornerPositioned(
                  top: 8,
                  left: 8,
                  isTop: true,
                  isLeft: true,
                  color: borderColor,
                ),
                _buildCornerPositioned(
                  top: 8,
                  right: 8,
                  isTop: true,
                  isLeft: false,
                  color: borderColor,
                ),
                _buildCornerPositioned(
                  bottom: 8,
                  left: 8,
                  isTop: false,
                  isLeft: true,
                  color: borderColor,
                ),
                _buildCornerPositioned(
                  bottom: 8,
                  right: 8,
                  isTop: false,
                  isLeft: false,
                  color: borderColor,
                ),
              ],
            ),
          ),
        ),
        if (hasError) ...[
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: CustomText(
              errorMessage,
              type: AppTextType.bodySmall,
              color: Colors.red,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCornerPositioned({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required bool isTop,
    required bool isLeft,
    required Color color,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: 18.w,
        height: 18.h,
        decoration: BoxDecoration(
          border: Border(
            top: isTop
                ? BorderSide(color: color, width: 3)
                : BorderSide.none,
            bottom: !isTop
                ? BorderSide(color: color, width: 3)
                : BorderSide.none,
            left: isLeft
                ? BorderSide(color: color, width: 3)
                : BorderSide.none,
            right: !isLeft
                ? BorderSide(color: color, width: 3)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}