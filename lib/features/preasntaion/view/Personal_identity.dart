 
import 'dart:io';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/widgets/customButton.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/core/widgets/logo_app.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_car_image/cubit.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_car_image/cubit_stat.dart';
import 'package:drever_warr/features/preasntaion/view/CarRegistrationScreen.dart';
import 'package:drever_warr/features/preasntaion/widhets/icon_bak.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class Personalidentity extends StatefulWidget {
  const Personalidentity({super.key});

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
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        if (isFront) {
          context.read<UploadIdCubit>().frontImage = File(pickedFile.path);
        } else {
          context.read<UploadIdCubit>().backImage = File(pickedFile.path);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<UploadIdCubit, UploadIdState>(
        listener: (context, state) {
          if (state is UploadIdSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("تم رفع صور الهوية بنجاح"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CarRegistrationScreen(),
              ),
            );
          } else if (state is UploadIdFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              const IconBak(),
              Center(child: LogoSection()),
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
                          "Register",
                          type: AppTextType.bodyLarge,
                          color: AppColors.main1,
                        ),
                        SizedBox(height: 35.h),
                        _buildIdCaptureBox(
                          label: "add_front_id_photo",
                          imageFile: context.read<UploadIdCubit>().frontImage,
                          onTap: () =>
                              _pickIdImage(context, ImageSource.gallery, true),
                        ),
                        SizedBox(height: 30.h),
                        _buildIdCaptureBox(
                          label: "add_back_id_photo",
                          imageFile: context.read<UploadIdCubit>().backImage,
                          onTap: () =>
                              _pickIdImage(context, ImageSource.gallery, false),
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
                              title: "next",
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
  }) {
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
              border: Border.all(color: const Color(0xFF1595C7), width: 2.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                if (imageFile != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
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
                ),
                _buildCornerPositioned(
                  top: 8,
                  right: 8,
                  isTop: true,
                  isLeft: false,
                ),
                _buildCornerPositioned(
                  bottom: 8,
                  left: 8,
                  isTop: false,
                  isLeft: true,
                ),
                _buildCornerPositioned(
                  bottom: 8,
                  right: 8,
                  isTop: false,
                  isLeft: false,
                ),
              ],
            ),
          ),
        ),
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
                ? const BorderSide(color: Color(0xFF1595C7), width: 3)
                : BorderSide.none,
            bottom: !isTop
                ? const BorderSide(color: Color(0xFF1595C7), width: 3)
                : BorderSide.none,
            left: isLeft
                ? const BorderSide(color: Color(0xFF1595C7), width: 3)
                : BorderSide.none,
            right: !isLeft
                ? const BorderSide(color: Color(0xFF1595C7), width: 3)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
