import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

 
class Selectgender extends StatefulWidget {
  final Function(String) onGenderSelected; // إضافة callback
  const Selectgender({super.key, required this.onGenderSelected});

  @override
  State<Selectgender> createState() => _SelectgenderState();
}

class _SelectgenderState extends State<Selectgender> {
  String selectedGender =
      "male"; 

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildGenderOption("female", "female"),
        SizedBox(width: 150.w),
        _buildGenderOption("male", "male"),
      ],
    );
  }

  Widget _buildGenderOption(String value, String label) {
    bool isSelected = selectedGender == value;

    return Row(
      children: [
        CustomText(label, type: AppTextType.bodyMedium),  
        SizedBox(width: 5.w),
        GestureDetector(
          onTap: () {
            setState(() {
              selectedGender = value;
            });
            widget.onGenderSelected(value);  
          },
          child: Container(
            width: 35.w,
            height: 35.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.main1, width: 1),
            ),
            child: Center(
              child: isSelected
                  ? Container(
                      width: 10.w,
                      height: 10.h,
                      decoration: const BoxDecoration(
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
