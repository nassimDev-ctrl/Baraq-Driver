import 'package:drever_warr/core/transleat/app_translat.dart';
import 'package:flutter/material.dart';
  
class Validators {
  static String? validatePhone(String? value,BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppTranslations.getStaticText(context,  'Please enter your phone number');
       
    }
    final phoneRegExp = RegExp(r'^[0-9]{8,15}$');
    if (!phoneRegExp.hasMatch(value)) {
      return AppTranslations.getStaticText(context,    'Invalid phone number');
     
    }
    return null;
  }

  
  static String? validateEmail(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppTranslations.getStaticText(context,  'This Feild is Empty');
 
    }

    final cleanedValue = value.trim().replaceAll(
      RegExp(r'[\u200F\u200E\u202A-\u202E]'),
      '',
    );

    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegExp.hasMatch(cleanedValue)) {
      return AppTranslations.getStaticText(context,   'Invaild Email');
     
    }
    return null;
  }

   
  static String? validateURL(String? value,BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppTranslations.getStaticText(context, 'Please enter the URL');
    }
    final urlRegExp = RegExp(
      r'^(https?:\/\/)?([\w\-])+\.{1}([a-zA-Z]{2,63})([\/\w\-.]*)*\/?$',
    );
    if (!urlRegExp.hasMatch(value)) {
      return  AppTranslations.getStaticText(  context , 'Invalid URL');
       
    }
    return null;
  }

  static String? isEmptyValue(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppTranslations.getStaticText(context,  "This Feild is Empty");
 
    }
    return null;
  }

  static String? validatePassword(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppTranslations.getStaticText(context,  'This Feild is Empty');
     
    }

    final regex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&_\-#^])[A-Za-z\d@$!%*?&_\-#^]{8,}$',
    );

    if (!regex.hasMatch(value)) {
      return 1 == 1
          ? AppTranslations.getStaticText(context,  'Must be 8+ characters with uppercase, lowercase, number, and special character.')
          : "يجب أن تتكوّن كلمة المرور من 8 أحرف على الأقل، وتحتوي على حرف كبير وصغير ورقم ورمز خاص.";
    }

    return null;
  }

  static String? validateConfirmPassword(
    String? password,
    String? confirmPassword,
    BuildContext context,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return AppTranslations.getStaticText(context,  
      "This Feild is Empty");
      
    } else if (confirmPassword != password) {
      return 
      AppTranslations.getStaticText(context,  'Password does not match');
      
    }
    return null;
  }
}
