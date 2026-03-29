import 'dart:io';
import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/widgets/customButton.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/core/widgets/logo_app.dart';
import 'package:drever_warr/features/preasntaion/view/CarRegistrationScreen.dart';
import 'package:drever_warr/features/preasntaion/widhets/icon_bak.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class Personalidentity extends StatefulWidget {
  const Personalidentity({super.key});

  @override
  State<Personalidentity> createState() => _PersonalidentityState();
}

class _PersonalidentityState extends State<Personalidentity> {
  File? _idFrontImage;
  File? _idBackImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickIdImage(ImageSource source, bool isFront) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        if (isFront) {
          _idFrontImage = File(pickedFile.path);
        } else {
          _idBackImage = File(pickedFile.path);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const IconBak(),

            Center(child: LogoSection()),

            // SizedBox(height: 40.h),
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
                        imageFile: _idFrontImage,
                        onTap: () => _pickIdImage(ImageSource.gallery, true),
                      ),

                      SizedBox(height: 30.h),

                      _buildIdCaptureBox(
                        label: "add_back_id_photo",
                        imageFile: _idBackImage,
                        onTap: () => _pickIdImage(ImageSource.gallery, false),
                      ),

                      SizedBox(height: 50.h),

                      CustomButton(
                        title: "next",
                        onTap:
                            //(_idFrontImage != null && _idBackImage != null)
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CarRegistrationScreen(),
                                ),
                              );
                            },
                        // الزر يكون معطلاً حتى تُرفع الهوية بالكامل
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
    );
  }

  // ويجيت بناء مربع رفع الهوية
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
                // عرض الصورة إذا تم اختيارها
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

                // رسم زوايا التركيز (Corners)
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

  // دالة مساعدة لتحديد مكان الزوايا
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
