 
import 'dart:io';
import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/utiles/faledtor.dart';
import 'package:drever_warr/core/widgets/coustm_text_fild_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

 
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/widgets/customButton.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/core/widgets/customTextFieldname.dart';
import 'package:drever_warr/core/widgets/logo_app.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_category/cubit.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_category/cubit_stat.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_information_car/cubit.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_information_car/cubit_stat.dart';
import 'package:drever_warr/features/preasntaion/view/WaitingReviewScreen.dart';

class CarRegistrationScreen extends StatefulWidget {
  const CarRegistrationScreen({super.key});

  @override
  State<CarRegistrationScreen> createState() => _CarRegistrationScreenState();
}

class _CarRegistrationScreenState extends State<CarRegistrationScreen> {
  final TextEditingController _carTypeController = TextEditingController();
  final TextEditingController _carModelController = TextEditingController();
  final TextEditingController _plateNumberController = TextEditingController();
  final TextEditingController _color = TextEditingController();
  final GlobalKey _categoryKey = GlobalKey();  
  final TextEditingController _categoryController =
      TextEditingController();  
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _acceptTerms = false;
  String? _selectedColor;
  String? _selectedCategoryId;

  Future<void> _pickImage(ImageSource source, bool isCar) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        if (isCar) {
          context.read<CarInfoCubit>().carImage = File(pickedFile.path);
        } else {
          context.read<CarInfoCubit>().carPlateImage = File(pickedFile.path);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<CarInfoCubit, CarInfoState>(
        listener: (context, state) {
          if (state is CarInfoSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const WaitingReviewScreen(),
              ),
            );
          } else if (state is CarInfoFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  const LogoSection(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.main1, width: 1.5),
                        borderRadius: BorderRadius.circular(15),
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

                          _buildLabel("نوع السيارة"),
                          CustomTextFieldname(
                            validator: (val) => val!.isEmpty ? "مطلوب" : null,
                            controller: _carTypeController,
                            hintText: "مثلاً: Kia Rio",
                          ),

                          SizedBox(height: 15.h),

                          _buildLabel("سنة الصنع"),
                          CustomTextFieldname(
                            validator: (val) => val!.isEmpty ? "مطلوب" : null,
                            controller: _carModelController,
                            hintText: "مثلاً: 2020",
                            keyboardType: TextInputType.number,
                          ),

                          SizedBox(height: 15.h),

                          _buildLabel("لون السيارة"),
                          AppCustomTextField(
                            controller: _color,
                            hintText: "",
                            validator: (val) =>
                                Validators.isEmptyValue(val, context),
                          ),

                           
                          SizedBox(height: 20.h),

                          _buildLabel("صورة السيارة"),
                          _buildImagePickerBox(
                            image: context.watch<CarInfoCubit>().carImage,
                            onTap: () => _pickImage(ImageSource.gallery, true),
                          ),

                          SizedBox(height: 20.h),

                          _buildLabel("صورة اللوحة"),
                          _buildImagePickerBox(
                            image: context.watch<CarInfoCubit>().carPlateImage,
                            onTap: () => _pickImage(ImageSource.gallery, false),
                          ),

                          SizedBox(height: 15.h),

                          _buildLabel("رقم اللوحة"),
                          CustomTextFieldname(
                            validator: (val) => val!.isEmpty ? "مطلوب" : null,
                            controller: _plateNumberController,
                            hintText: "رقم اللوحة",
                          ),

                          SizedBox(height: 15.h),

                          _buildLabel("فئة السيارة"),

                          BlocBuilder<CarCategoryCubit, CarCategoryState>(
                            builder: (context, state) {
                              return GestureDetector(
                                onTap: () async {
                                  final cubit = context
                                      .read<CarCategoryCubit>();

                                 
                                  if (state is! CarCategorySuccess) {
                                    await cubit.getCarCategories();
                                  }

                                  if (cubit.state is CarCategorySuccess) {
                                    final categoryState =
                                        cubit.state as CarCategorySuccess;

                                    
                                    final RenderBox button =
                                        _categoryKey.currentContext!
                                                .findRenderObject()
                                            as RenderBox;
                                    final RenderBox overlay =
                                        Overlay.of(
                                              context,
                                            ).context.findRenderObject()
                                            as RenderBox;

                                    final Offset position = button
                                        .localToGlobal(
                                          Offset.zero,
                                          ancestor: overlay,
                                        );

                                    
                                    final selected = await showMenu<String>(
                                      context: context,
                                      position: RelativeRect.fromLTRB(
                                        position.dx,
                                        position.dy + button.size.height,
                                        position.dx + button.size.width,
                                        0,
                                      ),
                                      constraints: BoxConstraints(
                                        maxHeight: 180.h,
                                        minWidth: button
                                            .size
                                            .width,  
                                        maxWidth: button.size.width,
                                      ),
                                      items: categoryState.categories.map((
                                        category,
                                      ) {
                                        return PopupMenuItem<String>(
                                          value: category.id,
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(category.name ?? ""),
                                          ),
                                        );
                                      }).toList(),
                                    );

                                    if (selected != null) {
                                      setState(() {
                                        _selectedCategoryId = selected;
                                      
                                        _categoryController.text =
                                            categoryState.categories
                                                .firstWhere(
                                                  (element) =>
                                                      element.id == selected,
                                                )
                                                .name ??
                                            "";
                                      });
                                    }
                                  }
                                },
                                child: AbsorbPointer(
                                  child: AppCustomTextField(
                                    key: _categoryKey,  
                                    iconImage: IconsAssets
                                        .drowpdawn, 
                                    controller: _categoryController,
                                    hintText: "اختر فئة السيارة",
                                    validator: (val) =>
                                        val!.isEmpty ? "مطلوب" : null,
                                  ),
                                ),
                              );
                            },
                          ),

                          SizedBox(height: 20.h),

                          CustomText(
                            "disclaimer",
                            type: AppTextType.caption,
                            textAlign: TextAlign.left,
                          ),

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
                                "الموافقة على الشروط",
                                type: AppTextType.bodyMedium,
                              ),
                            ],
                          ),

                          SizedBox(height: 20.h),

                          BlocBuilder<CarInfoCubit, CarInfoState>(
                            builder: (context, state) {
                              if (state is CarInfoLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return CustomButton(
                                title: "تأكيد",
                                onTap: () {
                                  if (_formKey.currentState!.validate() &&
                                      _acceptTerms) {
                                    if (_selectedCategoryId == null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text("يرجى اختيار الفئة"),
                                        ),
                                      );
                                      return;
                                    }

                                    context.read<CarInfoCubit>().submitCarInfo(
                                      carName: _carTypeController.text,
                                      
                                      category: _selectedCategoryId!,
                                      carPlateNumber:
                                          _plateNumberController.text,
                                      carYearMade: _carModelController.text,
                                    );
                                  }
                                },
                              );
                            },
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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

  Widget _buildImagePickerBox({File? image, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          border: Border.all(color: const Color(0xFF1595C7), width: 2.5),
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
                  height: double.infinity,
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
