import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Selectgender extends StatefulWidget {
  const Selectgender({super.key});

  @override
  State<Selectgender> createState() => _SelectgenderState();
}

class _SelectgenderState extends State<Selectgender> {
  String selectedGender = "ذكر";

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildGenderOption("female"),
        SizedBox(width: 150.w),

        _buildGenderOption("male"),
      ],
    );
  }

  Widget _buildGenderOption(String value) {
    bool isSelected = selectedGender == value;

    return Row(
      children: [
        CustomText(value, type: AppTextType.bodyMedium),
        SizedBox(width: 5.w),
        GestureDetector(
          onTap: () {
            setState(() {
              selectedGender = value;
            });
          },
          child: Container(
            width: 35.w,
            height: 35.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // color: const Color(0xFFF2F2F2),
              border: Border.all(color: AppColors.main1, width: 1),
            ),
            child: Center(
              child: isSelected
                  ? Container(
                      width: 10.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF1595C7),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ],
    );
  }
}
