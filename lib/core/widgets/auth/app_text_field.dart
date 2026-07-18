import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

OutlineInputBorder appInputBorder({Color? color, double width = 1}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(AuthUiConstants.fieldRadius.r),
    borderSide: BorderSide(
      color: color ?? AuthUiConstants.fieldBorder,
      width: width,
    ),
  );
}

InputDecoration appFieldDecoration(
  BuildContext context, {
  required String hintKey,
  required Widget prefixIcon,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    hintText: AppTranslations.getText(context, hintKey),
    hintStyle: TextStyle(
      fontSize: 13.sp,
      color: AuthUiConstants.hintColor,
      fontWeight: FontWeight.w500,
    ),
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: AuthUiConstants.fieldFill,
    contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
    border: appInputBorder(),
    enabledBorder: appInputBorder(),
    focusedBorder: appInputBorder(color: AppColors.main1, width: 1.5),
    errorBorder: appInputBorder(color: Colors.red),
    focusedErrorBorder: appInputBorder(color: Colors.red, width: 1.5),
  );
}

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.hintKey,
    required this.icon,
    required this.validator,
    this.focusNode,
    this.nextFocus,
    this.keyboardType,
    this.textDirection,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
    this.suffix,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String hintKey;
  final IconData icon;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType? keyboardType;
  final TextDirection? textDirection;
  final bool obscureText;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffix;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      validator: validator,
      obscureText: obscureText,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      textDirection: textDirection,
      maxLines: obscureText ? 1 : maxLines,
      textInputAction:
          nextFocus != null ? TextInputAction.next : TextInputAction.done,
      onFieldSubmitted: (_) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        } else {
          FocusScope.of(context).unfocus();
        }
      },
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AuthUiConstants.textPrimary,
      ),
      decoration: appFieldDecoration(
        context,
        hintKey: hintKey,
        prefixIcon: Icon(icon, color: AppColors.main1, size: 20.sp),
        suffixIcon: suffix,
      ),
    );
  }
}

class AppPhoneField extends StatelessWidget {
  const AppPhoneField({
    super.key,
    required this.controller,
    required this.validator,
    this.focusNode,
    this.nextFocus,
    this.hintKey = 'phone_number',
    this.icon = Icons.phone_outlined,
    this.textInputAction = TextInputAction.next,
    this.readOnly = false,
    this.onTap,
    this.suffix,
  });

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final String hintKey;
  final IconData icon;
  final TextInputAction textInputAction;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      validator: validator,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: TextInputType.phone,
      textDirection: TextDirection.ltr,
      textInputAction: textInputAction,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      onFieldSubmitted: (_) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        } else {
          FocusScope.of(context).unfocus();
        }
      },
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AuthUiConstants.textPrimary,
        letterSpacing: 0.4,
      ),
      decoration: appFieldDecoration(
        context,
        hintKey: hintKey,
        prefixIcon: SizedBox(
          width: 86.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.main1, size: 18.sp),
              SizedBox(width: 6.w),
              Text(
                '+963',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.blue,
                ),
              ),
            ],
          ),
        ),
        suffixIcon: suffix,
      ).copyWith(
        prefixIconConstraints: BoxConstraints(minWidth: 86.w, minHeight: 0),
      ),
    );
  }
}

class AppPickerField extends StatelessWidget {
  const AppPickerField({
    super.key,
    required this.controller,
    required this.hintKey,
    required this.icon,
    required this.onTap,
    required this.validator,
  });

  final TextEditingController controller;
  final String hintKey;
  final IconData icon;
  final VoidCallback onTap;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      validator: validator,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AuthUiConstants.textPrimary,
      ),
      decoration: appFieldDecoration(
        context,
        hintKey: hintKey,
        prefixIcon: Icon(icon, color: AppColors.main1, size: 20.sp),
        suffixIcon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AuthUiConstants.iconMuted,
          size: 24.sp,
        ),
      ),
    );
  }
}
