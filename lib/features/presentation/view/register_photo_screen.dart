import 'dart:io';

import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/custom_button.dart';
import 'package:drever_warr/core/widgets/custom_text.dart';
import 'package:drever_warr/core/widgets/logo_app.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_personal_image/cubit.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_personal_image/cubit_stat.dart';
import 'package:drever_warr/features/presentation/view/personal_identity.dart';
import 'package:drever_warr/features/presentation/widgets/icon_bak.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import 'waiting_review_screen.dart';

class RegisterPhotoScreen extends StatefulWidget {
  final bool isUpdate;
  final String? imageError;

  const RegisterPhotoScreen({
    super.key,
    required this.isUpdate,
    this.imageError,
  });

  @override
  State<RegisterPhotoScreen> createState() => _RegisterPhotoScreenState();
}

class _RegisterPhotoScreenState extends State<RegisterPhotoScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 95,
    );

    if (pickedFile == null) return;

    final File originalFile = File(pickedFile.path);
    final File finalFile = await _compressImageToMax5Mb(originalFile);

    if (!context.mounted) return;

    context.read<UploadImageCubit>().selectedImage = finalFile;
    setState(() {});
  }

  Future<File> _compressImageToMax5Mb(File file) async {
    const int maxBytes = 5 * 1024 * 1024;

    if (await file.length() <= maxBytes) {
      return file;
    }

    final Directory tempDir =
    await Directory.systemTemp.createTemp('profile_images');

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
    final uploadCubit = context.watch<UploadImageCubit>();
    final bool hasError =
        widget.imageError != null && widget.imageError!.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<UploadImageCubit, UploadImageState>(
        listener: (context, state) {
          if (state is UploadImageSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppTranslations.getText(context, "image_upload_success"),
                ),
                backgroundColor: Colors.green,
              ),
            );

            if (!widget.isUpdate) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Personalidentity(isUpdate: false),
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
          } else if (state is UploadImageFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const IconBak(),
              const Center(child: LogoSection()),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      border: Border(
                        top: BorderSide(color: AppColors.main1, width: 1.5),
                        left: BorderSide(color: AppColors.main1, width: 1.5),
                        right: BorderSide(color: AppColors.main1, width: 1.5),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),
                        CustomText(
                          "register_title",
                          type: AppTextType.bodyLarge,
                          color: AppColors.main1,
                        ),
                        SizedBox(height: 10.h),
                        CustomText(
                          "add_clear_profile_photo",
                          type: AppTextType.bodyLarge,
                        ),
                        SizedBox(height: 40.h),
                        Center(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    _pickImage(context, ImageSource.gallery),
                                child: Container(
                                  width: 200.w,
                                  height: 200.h,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF6F6F6),
                                    border: Border.all(
                                      color: hasError
                                          ? Colors.red
                                          : const Color(0xFF1595C7),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      uploadCubit.selectedImage != null
                                          ? ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(8),
                                        child: Image.file(
                                          uploadCubit.selectedImage!,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                          : Image.asset(
                                        ImageAssets.profail,
                                        height: 200.h,
                                        width: 100.w,
                                      ),
                                      Positioned(
                                        top: 10,
                                        left: 10,
                                        child: _buildCorner(
                                          top: true,
                                          left: true,
                                          color: hasError
                                              ? Colors.red
                                              : const Color(0xFF00AEEF),
                                        ),
                                      ),
                                      Positioned(
                                        top: 10,
                                        right: 10,
                                        child: _buildCorner(
                                          top: true,
                                          left: false,
                                          color: hasError
                                              ? Colors.red
                                              : const Color(0xFF00AEEF),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        left: 10,
                                        child: _buildCorner(
                                          top: false,
                                          left: true,
                                          color: hasError
                                              ? Colors.red
                                              : const Color(0xFF00AEEF),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        right: 10,
                                        child: _buildCorner(
                                          top: false,
                                          left: false,
                                          color: hasError
                                              ? Colors.red
                                              : const Color(0xFF00AEEF),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (hasError) ...[
                                SizedBox(height: 8.h),
                                Padding(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 12.w),
                                  child: CustomText(
                                    widget.imageError!,
                                    type: AppTextType.bodySmall,
                                    color: Colors.red,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 45.w),
                          child: OutlinedButton.icon(
                            onPressed: () =>
                                _pickImage(context, ImageSource.camera),
                            icon: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.black,
                            ),
                            label: CustomText(
                              "take_photo_now",
                              type: AppTextType.bodyLarge,
                            ),
                            style: OutlinedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50.h),
                              side: const BorderSide(color: Color(0xFF9C4DB9)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        BlocBuilder<UploadImageCubit, UploadImageState>(
                          builder: (context, state) {
                            if (state is UploadImageLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return CustomButton(
                              title: "next",
                              onTap: () {
                                context.read<UploadImageCubit>().uploadImage();
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

  Widget _buildCorner({
    required bool top,
    required bool left,
    required Color color,
  }) {
    return Container(
      width: 20.w,
      height: 20.h,
      decoration: BoxDecoration(
        border: Border(
          top: top ? BorderSide(color: color, width: 3) : BorderSide.none,
          bottom: !top ? BorderSide(color: color, width: 3) : BorderSide.none,
          left: left ? BorderSide(color: color, width: 3) : BorderSide.none,
          right: !left ? BorderSide(color: color, width: 3) : BorderSide.none,
        ),
      ),
    );
  }
}