import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Selectgender extends StatefulWidget {
  const Selectgender({
    super.key,
    required this.onGenderSelected,
    this.initialValue = 'male',
  });

  final ValueChanged<String> onGenderSelected;
  final String initialValue;

  @override
  State<Selectgender> createState() => _SelectgenderState();
}

class _SelectgenderState extends State<Selectgender> {
  late String _selected;

  static const _options = [
    _GenderData(value: 'male', labelKey: 'male', icon: Icons.male_rounded),
    _GenderData(value: 'female', labelKey: 'female', icon: Icons.female_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
  }

  void _select(String value) {
    if (_selected == value) return;
    setState(() => _selected = value);
    widget.onGenderSelected(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.wc_rounded,
              size: 18.sp,
              color: AppColors.button,
            ),
            SizedBox(width: AppSpacing.xs.w),
            Text(
              AppTranslations.getText(context, 'gender'),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF374151),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.sm.h),
        Row(
          children: [
            for (var i = 0; i < _options.length; i++) ...[
              if (i > 0) SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: _GenderCard(
                  data: _options[i],
                  isSelected: _selected == _options[i].value,
                  onTap: () => _select(_options[i].value),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _GenderData {
  const _GenderData({
    required this.value,
    required this.labelKey,
    required this.icon,
  });

  final String value;
  final String labelKey;
  final IconData icon;
}

class _GenderCard extends StatelessWidget {
  const _GenderCard({
    required this.data,
    required this.isSelected,
    required this.onTap,
  });

  final _GenderData data;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      height: 88.h,
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.button.withValues(alpha: 0.08)
            : const Color(0xFFF1F3F6),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isSelected ? AppColors.button : const Color(0xFFE2E5EB),
          width: 1.8,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.button.withValues(alpha: 0.14),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18.r),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? AppColors.button : Colors.white,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.button
                              : const Color(0xFFE2E5EB),
                        ),
                      ),
                      child: Icon(
                        data.icon,
                        size: 22.sp,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF8A94A6),
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs.h),
                    Text(
                      AppTranslations.getText(context, data.labelKey),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        color: isSelected
                            ? AppColors.blue
                            : const Color(0xFF5A6475),
                      ),
                    ),
                  ],
                ),
              ),
              PositionedDirectional(
                top: 8.h,
                start: 8.w,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 220),
                  opacity: isSelected ? 1 : 0,
                  child: Container(
                    width: 20.r,
                    height: 20.r,
                    decoration: BoxDecoration(
                      color: AppColors.button,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      size: 13.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
