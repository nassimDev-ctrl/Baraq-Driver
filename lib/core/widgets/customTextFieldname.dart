import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/style/text_style.dart';
import 'package:drever_warr/core/transleat/app_translat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
 

class CustomTextFieldname extends StatelessWidget {
  const CustomTextFieldname({
    super.key,
    required this.hintText,

    this.isPassword = false,

    required this.controller,
    this.focusNode,
    this.compareWith,
    this.obscure = false,
    this.onToggleObscure,
    required this.validator,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.done,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.onChanged,
    this.readOnly = false,
    this.keyboardType,
    this.autofocus = false,
  });

  final String hintText;

  final bool isPassword;

  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextEditingController? compareWith;
  final bool obscure;
  final VoidCallback? onToggleObscure;
  final String? Function(String?)? validator;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final AutovalidateMode? autovalidateMode;
  final void Function(String)? onChanged;
  final bool readOnly;
  final TextInputType? keyboardType;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      autofocus: autofocus,
      textDirection: TextDirection.rtl, // استخدام الخاصية هنا
      textAlign: TextAlign.start,
      readOnly: readOnly,
      onChanged: onChanged,
      textInputAction: textInputAction,
      controller: controller,
      obscureText: obscure,
      cursorColor: Colors.black,
      cursorWidth: 1,
      textCapitalization: textCapitalization,
      autovalidateMode: autovalidateMode,

      style: AppTextStyles.bodySmall,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: AppColors.secondary1,

        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),

        hintText: AppTranslations.getText(context, hintText),
        hintStyle: TextStyle(fontSize: 12.sp),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(width: 0.5, color: AppColors.main1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(width: 1, color: AppColors.main1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(width: 0.8, color: AppColors.main1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(width: 0.8, color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(width: 0.8, color: Colors.red),
        ),

        errorMaxLines: 2,
        errorStyle: TextStyle(fontSize: 11.sp),
      ),

      keyboardType: keyboardType,
      validator: validator,
      onFieldSubmitted: (value) {},
    );
  }
}
