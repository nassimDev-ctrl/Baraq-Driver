import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
 
 


 

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    Color? color,
    this.coloricon,
  }) : color = color ?? Colors.white;

  final String title;
  final Color? coloricon;
  final Color? color;

  static final double _topPadding = AppSpacing.spaceAboveAppBar.h;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: _topPadding),
      child: AppBar(
        surfaceTintColor: Colors.white,
        scrolledUnderElevation: 0,
        backgroundColor: color,
        elevation: 0,

        title: CustomText(
          title,
          type: AppTextType.titleLarge,
          color: coloricon,
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>  Container(),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SvgPicture.asset(
              "",
            //  IconsAssets.leftArrow,
              width: 24.w,
              height: 24.h,
              matchTextDirection: true,
              colorFilter: coloricon != null
                  ? ColorFilter.mode(coloricon!, BlendMode.srcIn)
                  : null,
            ),
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Container()),
                );
              },
              child: SvgPicture.asset(
                "",
            //    IconsAssets.bell,
                width: 24.w,
                height: 24.h,
                colorFilter: coloricon != null
                    ? ColorFilter.mode(coloricon!, BlendMode.srcIn)
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + _topPadding);
}
