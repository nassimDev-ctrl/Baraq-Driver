import 'dart:io';

import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/transleat/app_translat.dart';
import 'package:drever_warr/core/utiles/faledtor.dart';
import 'package:drever_warr/core/widgets/coustm_text_fild_all.dart';
import 'package:drever_warr/core/widgets/custom_button.dart';
import 'package:drever_warr/core/widgets/custom_text.dart';
import 'package:drever_warr/core/widgets/custom_text_field_name.dart';
import 'package:drever_warr/core/widgets/logo_app.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_category/cubit.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_category/cubit_stat.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_information_car/cubit.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_information_car/cubit_stat.dart';
import 'package:drever_warr/features/preasntaion/view/waiting_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';


class CarRegistrationScreen extends StatefulWidget {
  final bool isUpdate;

  /// External errors for each field.
  final String? carTypeError;
  final String? carModelError;
  final String? carColorError;
  final String? carImageError;
  final String? carPlateImageError;
  final String? carPlateNumberError;
  final String? carCategoryError;
  final String? termsError;

  const CarRegistrationScreen({
    super.key,
    required this.isUpdate,
    this.carTypeError,
    this.carModelError,
    this.carColorError,
    this.carImageError,
    this.carPlateImageError,
    this.carPlateNumberError,
    this.carCategoryError,
    this.termsError,
  });

  @override
  State<CarRegistrationScreen> createState() => _CarRegistrationScreenState();
}

class _CarRegistrationScreenState extends State<CarRegistrationScreen> {
  final TextEditingController _carTypeController = TextEditingController();
  final TextEditingController _carModelController = TextEditingController();
  final TextEditingController _plateNumberController = TextEditingController();
  final TextEditingController _color = TextEditingController();
  final GlobalKey _categoryKey = GlobalKey();
  final TextEditingController _categoryController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _acceptTerms = false;
  String? _selectedCategoryId;

  @override
  void dispose() {
    _carTypeController.dispose();
    _carModelController.dispose();
    _plateNumberController.dispose();
    _color.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source, bool isCar) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 95,
    );

    if (pickedFile == null) return;

    final File originalFile = File(pickedFile.path);
    final File finalFile = await _compressImageToMax5Mb(originalFile);

    if (!mounted) return;

    setState(() {
      if (isCar) {
        context.read<CarInfoCubit>().carImage = finalFile;
      } else {
        context.read<CarInfoCubit>().carPlateImage = finalFile;
      }
    });
  }

  Future<File> _compressImageToMax5Mb(File file) async {
    const int maxBytes = 5 * 1024 * 1024;

    // Already within limit
    if (await file.length() <= maxBytes) {
      return file;
    }

    final Directory tempDir = await Directory.systemTemp.createTemp('car_images');
    final String outPath =
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    int quality = 90;
    File currentFile = file;

    while (quality >= 10) {
      final List<int>? compressedBytes = await FlutterImageCompress.compressWithFile(
        currentFile.path,
        quality: quality,
        minWidth: 1920,
        minHeight: 1920,
        keepExif: true,
        format: CompressFormat.jpeg,
      );

      if (compressedBytes == null) {
        break;
      }

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

  bool get _hasTermsError =>
      widget.termsError != null && widget.termsError!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final carCubit = context.watch<CarInfoCubit>();

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
                              "register_title",
                              type: AppTextType.bodyLarge,
                              color: AppColors.main1,
                            ),
                          ),
                          SizedBox(height: 20.h),

                          _buildFieldSection(
                            label: "car_type",
                            errorMessage: widget.carTypeError,
                            child: CustomTextFieldname(
                              validator: (val) => val!.isEmpty
                                  ? AppTranslations.getText(
                                  context, "validate_empty")
                                  : null,
                              controller: _carTypeController,
                              hintText: AppTranslations.getText(
                                  context, "example_car_type"),
                            ),
                          ),

                          SizedBox(height: 15.h),

                          _buildFieldSection(
                            label: "car_model_year",
                            errorMessage: widget.carModelError,
                            child: CustomTextFieldname(
                              validator: (val) => val!.isEmpty
                                  ? AppTranslations.getText(
                                  context, "validate_empty")
                                  : null,
                              controller: _carModelController,
                              hintText: AppTranslations.getText(
                                  context, "example_car_year"),
                              keyboardType: TextInputType.number,
                            ),
                          ),

                          SizedBox(height: 15.h),

                          _buildFieldSection(
                            label: "car_color",
                            errorMessage: widget.carColorError,
                            child: AppCustomTextField(
                              controller: _color,
                              hintText: "",
                              validator: (val) =>
                                  Validators.isEmptyValue(val, context),
                            ),
                          ),

                          SizedBox(height: 20.h),

                          _buildFieldSection(
                            label: "add_car_photo",
                            errorMessage: widget.carImageError,
                            child: _buildImagePickerBox(
                              image: carCubit.carImage,
                              errorMessage: widget.carImageError,
                              onTap: () => _pickImage(ImageSource.gallery, true),
                            ),
                          ),

                          SizedBox(height: 20.h),

                          _buildFieldSection(
                            label: "add_plate_photo",
                            errorMessage: widget.carPlateImageError,
                            child: _buildImagePickerBox(
                              image: carCubit.carPlateImage,
                              errorMessage: widget.carPlateImageError,
                              onTap: () => _pickImage(ImageSource.gallery, false),
                            ),
                          ),

                          SizedBox(height: 15.h),

                          _buildFieldSection(
                            label: "plate_number",
                            errorMessage: widget.carPlateNumberError,
                            child: CustomTextFieldname(
                              validator: (val) => val!.isEmpty
                                  ? AppTranslations.getText(
                                  context, "validate_empty")
                                  : null,
                              controller: _plateNumberController,
                              hintText: AppTranslations.getText(
                                  context, "plate_number"),
                            ),
                          ),

                          SizedBox(height: 15.h),

                          _buildFieldSection(
                            label: "category",
                            errorMessage: widget.carCategoryError,
                            child: BlocBuilder<CarCategoryCubit, CarCategoryState>(
                              builder: (context, state) {
                                return GestureDetector(
                                  onTap: () async {
                                    final cubit = context.read<CarCategoryCubit>();

                                    if (state is! CarCategorySuccess) {
                                      await cubit.getCarCategories();
                                    }

                                    if (!mounted) return;
                                    if (cubit.state is! CarCategorySuccess) return;

                                    final categoryState =
                                    cubit.state as CarCategorySuccess;

                                    final RenderBox button =
                                    _categoryKey.currentContext!
                                        .findRenderObject() as RenderBox;
                                    if (!context.mounted) return;
                                    final RenderBox overlay = Overlay.of(context)
                                          .context
                                          .findRenderObject() as RenderBox;

                                      final Offset position = button.localToGlobal(
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
                                          minWidth: button.size.width,
                                          maxWidth: button.size.width,
                                        ),
                                        items: categoryState.categories.map((category) {
                                          return PopupMenuItem<String>(
                                            value: category.id,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(category.name ?? ""),
                                            ),
                                          );
                                        }).toList(),
                                      );

                                      if (!context.mounted) return;
                                      if (selected != null) {
                                        setState(() {
                                          _selectedCategoryId = selected;
                                          _categoryController.text = categoryState
                                              .categories
                                              .firstWhere(
                                                (element) =>
                                            element.id == selected,
                                          )
                                              .name ??
                                              "";
                                        });
                                      }
                                  },
                                  child: AbsorbPointer(
                                    child: Container(
                                      key: _categoryKey,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: widget.carCategoryError != null &&
                                              widget.carCategoryError!
                                                  .trim()
                                                  .isNotEmpty
                                              ? Colors.red
                                              : AppColors.main1,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: AppCustomTextField(
                                        iconImage: IconsAssets.drowpdawn,
                                        controller: _categoryController,
                                        hintText: AppTranslations.getText(
                                            context, "select_car_category"),
                                        validator: (val) => val!.isEmpty
                                            ? AppTranslations.getText(
                                            context, "validate_empty")
                                            : null,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          if (widget.carCategoryError != null &&
                              widget.carCategoryError!.trim().isNotEmpty) ...[
                            SizedBox(height: 6.h),
                            CustomText(
                              widget.carCategoryError!,
                              type: AppTextType.bodySmall,
                              color: Colors.red,
                              textAlign: TextAlign.right,
                            ),
                          ],

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
                                "accept_terms",
                                type: AppTextType.bodyMedium,
                              ),
                            ],
                          ),

                          if (_hasTermsError) ...[
                            SizedBox(height: 4.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.w),
                              child: CustomText(
                                widget.termsError!,
                                type: AppTextType.bodySmall,
                                color: Colors.red,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],

                          SizedBox(height: 20.h),

                          BlocBuilder<CarInfoCubit, CarInfoState>(
                            builder: (context, state) {
                              if (state is CarInfoLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return CustomButton(
                                title: "confirm",
                                onTap: () {
                                  if (_formKey.currentState!.validate() &&
                                      _acceptTerms) {
                                    if (_selectedCategoryId == null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            AppTranslations.getText(
                                                context, "please_select_category"),
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    context.read<CarInfoCubit>().submitCarInfo(
                                      carName: _carTypeController.text,
                                      category: _selectedCategoryId!,
                                      carPlateNumber: _plateNumberController.text,
                                      carYearMade: _carModelController.text,
                                      carColor: _color.text,
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

  Widget _buildFieldSection({
    required String label,
    required Widget child,
    String? errorMessage,
  }) {
    final bool hasError =
        errorMessage != null && errorMessage.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildLabel(label),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: hasError
                ? Border.all(color: Colors.red, width: 1.5)
                : Border.all(color: Colors.transparent, width: 0),
          ),
          child: child,
        ),
        if (hasError) ...[
          SizedBox(height: 6.h),
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

  Widget _buildImagePickerBox({
    File? image,
    required VoidCallback onTap,
    String? errorMessage,
  }) {
    final bool hasError =
        errorMessage != null && errorMessage.trim().isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          border: Border.all(
            color: hasError ? Colors.red : const Color(0xFF1595C7),
            width: 2.5,
          ),
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
            _corner(
              top: 5,
              left: 5,
              isTop: true,
              isLeft: true,
              color: hasError ? Colors.red : const Color(0xFF1595C7),
            ),
            _corner(
              top: 5,
              right: 5,
              isTop: true,
              isLeft: false,
              color: hasError ? Colors.red : const Color(0xFF1595C7),
            ),
            _corner(
              bottom: 5,
              left: 5,
              isTop: false,
              isLeft: true,
              color: hasError ? Colors.red : const Color(0xFF1595C7),
            ),
            _corner(
              bottom: 5,
              right: 5,
              isTop: false,
              isLeft: false,
              color: hasError ? Colors.red : const Color(0xFF1595C7),
            ),
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
    required Color color,
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
            top: isTop ? BorderSide(color: color, width: 2) : BorderSide.none,
            bottom: !isTop ? BorderSide(color: color, width: 2) : BorderSide.none,
            left: isLeft ? BorderSide(color: color, width: 2) : BorderSide.none,
            right: !isLeft ? BorderSide(color: color, width: 2) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}