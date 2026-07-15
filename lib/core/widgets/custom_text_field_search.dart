import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/transleat/app_translat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
 

class CustomTextFieldsearch extends StatefulWidget {
  const CustomTextFieldsearch({
    super.key,
    this.h = 15,
    this.w = 15,
    required this.hintText,
    required this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.onTap,  
    this.readOnly = false,
    this.keyboardType,
    this.textInputAction = TextInputAction.search,
    this.autofocus = false,
  });

  final String hintText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final VoidCallback? onTap; 
  final bool readOnly;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final int? h;
  final int? w;

  @override
  State<CustomTextFieldsearch> createState() => _CustomTextFieldsearchState();
}

class _CustomTextFieldsearchState extends State<CustomTextFieldsearch> {
  late FocusNode _internalFocusNode;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = widget.focusNode ?? FocusNode();
    _internalFocusNode.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          focusNode: _internalFocusNode,
          onTap: widget.onTap,  
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          textAlign: TextAlign.end,
          controller: widget.controller,
          readOnly: widget.readOnly,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          autofocus: widget.autofocus,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          style: TextStyle(color: AppColors.secondary2, fontSize: 13.sp),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.only(
              bottom: 5.h,
              top: 10.h,
              right: 5.w,
              left: 15.w,
            ),
            hintText: AppTranslations.getText(context, widget.hintText),
            hintStyle: TextStyle(fontSize: 12.sp, color: AppColors.secondary2),
            filled: false,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _internalFocusNode.hasFocus ? 1.0 : 0.0,
          child: Container(
            height: 1.5,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 0, left: 15, right: 5),
            color: AppColors.secondary2,
          ),
        ),
      ],
    );
  }
}