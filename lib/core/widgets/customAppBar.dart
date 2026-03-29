import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
 
 


 

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({super.key, required this.title, this.color, this.coloricon});
  final String title;
  final Color? coloricon;
  Color? color = Colors.white;

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
              color: coloricon,
              "",
            //  IconsAssets.leftArrow,
              width: 24.w,
              height: 24.h,
              matchTextDirection: true,
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
                color: coloricon,
                "",
            //    IconsAssets.bell,
                width: 24.w,
                height: 24.h,
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
