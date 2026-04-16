 
import 'dart:io';
import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/widgets/customButton.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/core/widgets/logo_app.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_personal_image/cubit.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_personal_image/cubit_stat.dart'; // تأكد من المسار الصحيح
import 'package:drever_warr/features/preasntaion/view/Personal_identity.dart';
import 'package:drever_warr/features/preasntaion/widhets/icon_bak.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPhotoScreen extends StatefulWidget {
  const RegisterPhotoScreen({super.key});

  @override
  State<RegisterPhotoScreen> createState() => _RegisterPhotoScreenState();
}

class _RegisterPhotoScreenState extends State<RegisterPhotoScreen> {
  final ImagePicker _picker = ImagePicker();

   
  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
       
      context.read<UploadImageCubit>().selectedImage = File(pickedFile.path);
     
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<UploadImageCubit, UploadImageState>(
        listener: (context, state) {
          if (state is UploadImageSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("تم رفع الصورة بنجاح"),
                backgroundColor: Colors.green,
              ),
            );
           
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Personalidentity()),
            );
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
              Center(child: LogoSection()),
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
                          "Register",
                          type: AppTextType.bodyLarge,
                          color: AppColors.main1,
                        ),
                        SizedBox(height: 10.h),
                        CustomText(
                          "add_clear_profile_photo",
                          type: AppTextType.bodyLarge,
                        ),
                        SizedBox(height: 40.h),

                        // منطقة عرض الصورة
                        Center(
                          child: GestureDetector(
                            onTap: () =>
                                _pickImage(context, ImageSource.gallery),
                            child: Container(
                              width: 200.w,
                              height: 200.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6F6F6),
                                border: Border.all(
                                  color: const Color(0xFF1595C7),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                              
                                  context
                                              .read<UploadImageCubit>()
                                              .selectedImage !=
                                          null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.file(
                                            context
                                                .read<UploadImageCubit>()
                                                .selectedImage!,
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
                                    child: _buildCorner(top: true, left: true),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: _buildCorner(top: true, left: false),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    left: 10,
                                    child: _buildCorner(top: false, left: true),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: _buildCorner(
                                      top: false,
                                      left: false,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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

  Widget _buildCorner({required bool top, required bool left}) {
    return Container(
      width: 20.w,
      height: 20.h,
      decoration: BoxDecoration(
        border: Border(
          top: top
              ? const BorderSide(color: Color(0xFF00AEEF), width: 3)
              : BorderSide.none,
          bottom: !top
              ? const BorderSide(color: Color(0xFF00AEEF), width: 3)
              : BorderSide.none,
          left: left
              ? const BorderSide(color: Color(0xFF00AEEF), width: 3)
              : BorderSide.none,
          right: !left
              ? const BorderSide(color: Color(0xFF00AEEF), width: 3)
              : BorderSide.none,
        ),
      ),
    );
  }
}
