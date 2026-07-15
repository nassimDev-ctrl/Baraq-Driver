import 'package:flutter/material.dart';

import '../cash/preferences_service.dart';
import 'custom_text_field_all.dart';

class PasswordTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String iconImage;

  const PasswordTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.validator,
    required this.iconImage,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscure = true;
  bool isArabic = false;

  void _toggle() {
    setState(() {
      _obscure = !_obscure;
    });
  }
  @override
  void initState() {
    super.initState();
    _loadLang();
  }

  Future<void> _loadLang() async {
    final savedLang = await CacheManager.getData("app_language");

    if (savedLang == 'ar') {
      setState(() {
        isArabic = true;
      });
    } else {
      setState(() {
        isArabic = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      alignment: Alignment.centerRight,
      children: [
        AppCustomTextField(
          hintText: widget.hintText,
          controller: widget.controller,
          validator: widget.validator,
          isPassword: true,
          obscure: _obscure,
        ),
        isArabic?
        Positioned(
          left: 10,
          top: 10,
          child: GestureDetector(
            onTap: _toggle,
            child: Icon(
              _obscure ? Icons.visibility_off : Icons.visibility,
              size: 20,
              color: Colors.black,
            ),
          ),
        )
        :Positioned(
          right: 10,
          top: 10,
          child: GestureDetector(
            onTap: _toggle,
            child: Icon(
              _obscure ? Icons.visibility_off : Icons.visibility,
              size: 20,
              color: Colors.black,
            ),
          ),
        )
      ],
    );
  }
}