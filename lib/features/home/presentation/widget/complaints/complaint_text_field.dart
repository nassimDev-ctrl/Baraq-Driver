import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/home/presentation/widget/complaints/complaints_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ComplaintTextField extends StatelessWidget {
  const ComplaintTextField({
    super.key,
    required this.controller,
    required this.charCount,
  });

  final TextEditingController controller;
  final int charCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppTranslations.getText(context, 'complaint_section_title'),
          style: TextStyle(
            color: AuthUiConstants.textPrimary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 10.h),
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(ComplaintsUiConstants.fieldRadius.r),
            border: Border.all(color: AuthUiConstants.fieldBorder),
            boxShadow: ComplaintsUiConstants.cardShadow,
          ),
          child: Column(
            children: [
              TextField(
                controller: controller,
                maxLines: 7,
                minLines: 6,
                maxLength: ComplaintsUiConstants.maxComplaintLength,
                style: TextStyle(
                  color: AuthUiConstants.textPrimary,
                  fontSize: 14.5.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.45,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: AppTranslations.getText(
                    context,
                    'complaint_details_hint',
                  ),
                  hintStyle: TextStyle(
                    color: AuthUiConstants.hintColor,
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  contentPadding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                  border: InputBorder.none,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 12.h),
                child: Row(
                  children: [
                    _UtilityIcon(icon: Icons.attach_file_rounded),
                    SizedBox(width: 8.w),
                    _UtilityIcon(icon: Icons.text_fields_rounded),
                    const Spacer(),
                    Text(
                      '$charCount / ${ComplaintsUiConstants.maxComplaintLength}',
                      style: TextStyle(
                        color: AuthUiConstants.iconMuted,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UtilityIcon extends StatelessWidget {
  const _UtilityIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.r,
      height: 30.r,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5F8),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 15.sp, color: AuthUiConstants.iconMuted),
    );
  }
}
