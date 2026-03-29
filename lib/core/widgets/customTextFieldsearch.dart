import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/transleat/app_translat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
 
class CustomTextFieldsearch extends StatelessWidget {
  const CustomTextFieldsearch({
    super.key,
    this.h = 15,
    this.w = 15,
    required this.hintText,

    required this.controller,
    this.focusNode,
    this.compareWith,
    this.obscure = false,
    this.onToggleObscure,

    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.done,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.onChanged,
    this.readOnly = false,
    this.keyboardType,
    this.autofocus = false,
  });

  final String hintText;

  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextEditingController? compareWith;
  final bool obscure;
  final VoidCallback? onToggleObscure;

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
    return Column(
      children: [
        TextFormField(
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          textAlign: TextAlign.end,
          controller: controller,
          style: TextStyle(color: AppColors.secondary1, fontSize: 13.sp),
          decoration: InputDecoration(
            isDense: true,

            contentPadding: EdgeInsets.only(
              bottom: 0.h,
              top: 10.h,
              right: 5.w,
              left: 15.w,
            ),

            hintText: AppTranslations.getText(context, hintText),
            hintStyle: TextStyle(fontSize: 15.sp, color: Color(0xFF778BAB)),
            filled: false,

            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),

        Container(
          height: 1.5,
          width: double.infinity,
          margin: EdgeInsets.only(top: 0, left: 15, right: 5),
          color: AppColors.secondary2,
        ),
      ],
    );
  }
}
