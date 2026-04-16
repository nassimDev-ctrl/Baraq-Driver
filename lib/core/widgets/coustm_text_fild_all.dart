 
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/style/text_style.dart';
import 'package:drever_warr/core/transleat/app_translat.dart';
import 'package:drever_warr/core/transleat/lunguesh_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class AppCustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? iconImage;
  final bool isPassword;
  final bool obscure;
  final VoidCallback? onToggleObscure;
  final String? toggleImage;
  final TextInputType? keyboardType;
  final bool readOnly;
  final bool autofocus;
  final double iconSize;
  final TextAlign textAlign;
  final VoidCallback? onIconTap;
  final VoidCallback? onTap;  
  final void Function(String)? onChanged;
  final String? countryCode;
  final EdgeInsetsGeometry? contentPadding;

  const AppCustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.validator,
    this.iconImage,
    this.isPassword = false,
    this.obscure = false,
    this.onToggleObscure,
    this.toggleImage,
    this.keyboardType,
    this.readOnly = false,
    this.autofocus = false,
    this.iconSize = 15,
    this.textAlign = TextAlign.start,
    this.onIconTap,
    this.onTap,
    this.onChanged,
    this.countryCode,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    bool isArabic = context.read<LanguageCubit>().state == Language.arabic;

    return FormField<String>(
      validator: validator,
      // نربط القيمة الأولية بنص التحكم
      initialValue: controller.text,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 38.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (countryCode != null) ...[
                    Container(
                      width: 70.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBFBFB),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: state.hasError ? Colors.red : AppColors.main1,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        countryCode!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                  ],

                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      obscureText: obscure,
                      readOnly: readOnly,
                      autofocus: autofocus,
                      onTap: onTap, 
                      onChanged: (value) {
                        state.didChange(
                          value,
                        ); // تحديث حالة FormField فوراً للتحقق
                        if (onChanged != null) onChanged!(value);
                      },
                      keyboardType: keyboardType,
                      textDirection: isArabic
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      textAlign: isArabic ? TextAlign.right : TextAlign.left,
                      onTapOutside: (_) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 13.sp,
                        height: 1.2,
                      ),
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: const Color(0xFFFBFBFB),
                        hintText: AppTranslations.getText(context, hintText),
                        hintStyle: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                        errorStyle: const TextStyle(height: 0, fontSize: 0),
                        prefixIconConstraints: BoxConstraints(minWidth: 35.w),
                        prefixIcon: iconImage != null
                            ? GestureDetector(
                                onTap: onIconTap,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                  ),
                                  child: SvgPicture.asset(
                                    iconImage!,
                                    height: iconSize.h,
                                    width: iconSize.w,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              )
                            : null,
                        suffixIconConstraints: BoxConstraints(minWidth: 35.w),
                        suffixIcon: isPassword && toggleImage != null
                            ? GestureDetector(
                                onTap: onToggleObscure,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                  ),
                                  child: SvgPicture.asset(
                                    toggleImage!,
                                    width: 18.w,
                                    height: 18.h,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              )
                            : null,
                        contentPadding:
                            contentPadding ??
                            EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 12.h,
                            ),
                        border: _buildBorder(
                          color: state.hasError ? Colors.red : AppColors.main1,
                        ),
                        enabledBorder: _buildBorder(
                          color: state.hasError ? Colors.red : AppColors.main1,
                        ),
                        focusedBorder: _buildBorder(
                          color: state.hasError ? Colors.red : AppColors.main1,
                          width: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            
            if (state.hasError)
              Padding(
                padding: EdgeInsets.only(top: 4.h, left: 8.w, right: 8.w),
                child: Text(
                  state.errorText ?? '',
                  style: TextStyle(color: Colors.red, fontSize: 10.sp),
                ),
              )
            else
              SizedBox(height: 12.h),  
          ],
        );
      },
    );
  }

  OutlineInputBorder _buildBorder({Color? color, double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: color ?? AppColors.main1, width: width),
    );
  }
}
