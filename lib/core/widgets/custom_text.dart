import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/transleat/app_translat.dart';
import 'package:flutter/material.dart';
 
   

enum AppTextType {
  display,
  titleSmall,
  titleMedium,
  body,
  small,
  caption,
  titleLarge,
  bodyLarge,
  bodyMedium,
  bodySmall,
  displayLarge,
  
  titlelarge

}

class CustomText extends StatelessWidget {
  final String text;
  final AppTextType type;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  const CustomText(
    this.text, {
    required this.type,
    this.color,
    this.maxLines,
    this.overflow,
    super.key,
    this.textAlign,
  });

  TextStyle _resolveStyle(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    switch (type) {
        case AppTextType.displayLarge:
        return theme.displayLarge!;
         case AppTextType.bodyLarge:
        return theme.bodyLarge!;
        case AppTextType.bodySmall:
        return theme.bodySmall!;
      case AppTextType.bodyMedium:
        return theme.bodyMedium!;
      case AppTextType.titleLarge:
        return theme.titleLarge!;
      case AppTextType.display:
        return theme.displayLarge!;
      case AppTextType.titleMedium:
        return theme.titleMedium!;
      case AppTextType.body:
        return theme.bodyMedium!;
      case AppTextType.small:
        return theme.bodySmall!;
      case AppTextType.caption:
        return theme.labelSmall!;
      case AppTextType.titleSmall:
        return theme.titleSmall!;
      case AppTextType.titlelarge:
        return theme.titleLarge!;
        
    }
  }

  @override
  Widget build(BuildContext context) {
    final String data = AppTranslations.getText(context, text);
    return Text(
      data,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      style: _resolveStyle(
        context,
      ).copyWith(color: color ?? TextColors.textPrimary),
    );
  }
}
