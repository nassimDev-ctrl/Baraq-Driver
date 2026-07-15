import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

 
class IconBak extends StatelessWidget {
  const IconBak({super.key, this.image});
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, top: 60.h, right: 16.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: SvgPicture.asset(
              image ?? IconsAssets.back,
              colorFilter: ColorFilter.mode(
                AppColors.secondary2,
                BlendMode.srcIn,
              ),
              matchTextDirection: true, //
            ),
          ),
        ],
      ),
    );
  }
}
