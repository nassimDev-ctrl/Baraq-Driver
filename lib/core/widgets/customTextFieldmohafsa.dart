import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/style/text_style.dart';
import 'package:drever_warr/core/transleat/app_translat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
 

class CustomTextFieldmohafsa extends StatelessWidget {
  const CustomTextFieldmohafsa({
    super.key,
    this.h = 15,
    this.w = 15,
    required this.hintText,
    required this.iconImage,
    this.isPassword = false,
    this.toggleImage,
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
    this.onIconTap,
  });
  final VoidCallback? onIconTap;
  final String hintText;
  final String iconImage;
  final bool isPassword;
  final String? toggleImage;
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
  final int? h;
  final int? w;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      textDirection: TextDirection.rtl, // استخدام الخاصية هنا
      textAlign: TextAlign.start,
      autofocus: autofocus,
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
        constraints: BoxConstraints(minHeight: 40.h),
        contentPadding: EdgeInsets.symmetric(vertical: 0),
        filled: true,
        fillColor: AppColors.secondary1,
        prefixIconConstraints: const BoxConstraints(minHeight: 0, minWidth: 0),
        // prefixIcon: Padding(
        //   padding: const EdgeInsets.all(14.0),
        //   child: SvgPicture.asset(iconImage, height: h!.h, width: w!.w),
        // ),
        prefixIcon: GestureDetector(
          onTap: onIconTap, // تمرير الوظيفة هنا
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
            child: SvgPicture.asset(iconImage, height: h!.h, width: w!.w),
          ),
        ),
        suffixIcon: isPassword && toggleImage != null
            ? GestureDetector(
                onTap: onToggleObscure,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: SvgPicture.asset(
                    toggleImage ?? "",
                    width: 20,
                    height: 20,
                  ),
                ),
              )
            : null,
        hintText: AppTranslations.getText(context, hintText),
        hintStyle: TextStyle(fontSize: 12),
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
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(width: 0.8),
        ),
        errorMaxLines: 4,
        errorStyle: TextStyle(fontSize: 11, overflow: TextOverflow.visible),
      ),
      keyboardType: keyboardType,
      validator: validator,
      onFieldSubmitted: (value) {},
    );
  }
}
