import 'dart:io';
import 'package:drever_warr/core/utiles/faledtor.dart';
import 'package:drever_warr/core/widgets/customTextFieldname.dart';
import 'package:drever_warr/core/widgets/logo_app.dart';
import 'package:drever_warr/features/preasntaion/view/WaitingReviewScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
// استيراد ملفاتك الخاصة (تأكد من صحة المسارات لديك)
import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/widgets/customButton.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/core/widgets/customTextField.dart'; // الملف الذي أرسلته

class CarRegistrationScreen extends StatefulWidget {
  const CarRegistrationScreen({super.key});

  @override
  State<CarRegistrationScreen> createState() => _CarRegistrationScreenState();
}

class _CarRegistrationScreenState extends State<CarRegistrationScreen> {
  // Controllers
  final TextEditingController _carTypeController = TextEditingController();
  final TextEditingController _carModelController = TextEditingController();
  final TextEditingController _plateNumberController = TextEditingController();

  // Images
  File? _carImage;
  File? _plateImage;
  final ImagePicker _picker = ImagePicker();

  // Settings
  bool _acceptTerms = false;
  String? _selectedColor;
  String? _selectedCategory;

  Future<void> _pickImage(ImageSource source, bool isCar) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        if (isCar) {
          _carImage = File(pickedFile.path);
        } else {
          _plateImage = File(pickedFile.path);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        //  bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10.h),
              LogoSection(),
              // SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    // نستخدم Border لتحديد الأضلاع بشكل منفصل
                    border: Border(
                      top: BorderSide(color: AppColors.main1, width: 1.5),
                      left: BorderSide(color: AppColors.main1, width: 1.5),
                      right: BorderSide(color: AppColors.main1, width: 1.5),
                      bottom: BorderSide.none,
                    ),

                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Center(
                        child: CustomText(
                          "Register",
                          type: AppTextType.bodyLarge,
                          color: AppColors.main1,
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // نوع السيارة
                      _buildLabel("car_type"),
                      CustomTextFieldname(
                        validator: (val) =>
                            Validators.validatePhone(val, context),
                        controller: _carTypeController,
                        hintText: "",
                        // يمكنك إضافة الأيقونة هنا حسب الـ Widget الخاص بك
                      ),

                      SizedBox(height: 15.h),

                      // موديل السنة
                      _buildLabel("car_model_year"),
                      CustomTextFieldname(
                        validator: (val) =>
                            Validators.validatePhone(val, context),
                        controller: _carModelController,
                        hintText: "",
                      ),

                      SizedBox(height: 15.h),

                      // لون السيارة (Dropdown)
                      _buildLabel("car_color"),
                      _buildDropdown(
                        value: _selectedColor,
                        items: ["أبيض", "أسود", "فضي", "أحمر"],
                        onChanged: (val) =>
                            setState(() => _selectedColor = val),
                      ),

                      SizedBox(height: 20.h),

                      // صورة السيارة
                      _buildLabel("add_plate_photo"),
                      _buildImagePickerBox(
                        image: _carImage,
                        onTap: () => _pickImage(ImageSource.gallery, true),
                      ),

                      SizedBox(height: 20.h),

                      // صورة اللوحة
                      _buildLabel("add_plate_photo"),
                      _buildImagePickerBox(
                        image: _plateImage,
                        onTap: () => _pickImage(ImageSource.gallery, false),
                      ),

                      SizedBox(height: 15.h),

                      // نمرة السيارة
                      _buildLabel("plate_number"),
                      CustomTextFieldname(
                        validator: (val) =>
                            Validators.validatePhone(val, context),
                        controller: _plateNumberController,
                        hintText: "",
                      ),

                      SizedBox(height: 15.h),

                      // الفئة (Dropdown)
                      _buildLabel("category"),
                      _buildDropdown(
                        value: _selectedCategory,
                        items: ["اقتصادية", "عائلية", "فاخرة"],
                        onChanged: (val) =>
                            setState(() => _selectedCategory = val),
                      ),

                      SizedBox(height: 20.h),

                      CustomText(
                        type: AppTextType.caption,
                        "disclaimer",
                        textAlign: TextAlign.left,
                        // اجعل الخط صغيراً كما في الصورة
                      ),

                      // الموافقة على الشروط
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Checkbox(
                            value: _acceptTerms,
                            activeColor: AppColors.main1,
                            onChanged: (val) =>
                                setState(() => _acceptTerms = val!),
                          ),
                          CustomText(
                            "accept_terms",
                            type: AppTextType.bodyMedium,
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      // زر تأكيد
                      CustomButton(
                        title: "confirm",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WaitingReviewScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ويجيت العنوان الصغير فوق الحقل
  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomText(
            text,

            textAlign: TextAlign.right,
            type: AppTextType.bodyMedium,
          ),
        ],
      ),
    );
  }

  // ويجيت القائمة المنسدلة بتصميم متناسق
  Widget _buildDropdown({
    String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.main1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  // ويجيت اختيار الصورة بنفس تصميمك السابق
  Widget _buildImagePickerBox({File? image, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100.h,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF1595C7), width: 2.5),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Stack(
          children: [
            if (image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Image.file(
                  image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            _corner(top: 5, left: 5, isTop: true, isLeft: true),
            _corner(top: 5, right: 5, isTop: true, isLeft: false),
            _corner(bottom: 5, left: 5, isTop: false, isLeft: true),
            _corner(bottom: 5, right: 5, isTop: false, isLeft: false),
          ],
        ),
      ),
    );
  }

  Widget _corner({
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
        width: 15.w,
        height: 15.h,
        decoration: BoxDecoration(
          border: Border(
            top: isTop
                ? const BorderSide(color: Color(0xFF1595C7), width: 2)
                : BorderSide.none,
            bottom: !isTop
                ? const BorderSide(color: Color(0xFF1595C7), width: 2)
                : BorderSide.none,
            left: isLeft
                ? const BorderSide(color: Color(0xFF1595C7), width: 2)
                : BorderSide.none,
            right: !isLeft
                ? const BorderSide(color: Color(0xFF1595C7), width: 2)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
