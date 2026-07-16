import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_governorates/cubit.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_governorates/cubit_state.dart';
import 'package:drever_warr/features/presentation/data/repo/model/model_governorates.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GovernoratesPickerSheet extends StatefulWidget {
  const GovernoratesPickerSheet({
    super.key,
    required this.selectedName,
    required this.onSelected,
  });

  final String selectedName;
  final ValueChanged<GovernorateModel> onSelected;

  @override
  State<GovernoratesPickerSheet> createState() =>
      _GovernoratesPickerSheetState();
}

class _GovernoratesPickerSheetState extends State<GovernoratesPickerSheet> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<GovernorateModel> _filter(List<GovernorateModel> governorates) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return governorates;
    return governorates.where((gov) {
      final nameAr = gov.name.toLowerCase();
      final nameEn = gov.nameEn?.toLowerCase() ?? '';
      return nameAr.contains(query) || nameEn.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg.w,
        AppSpacing.md.h,
        AppSpacing.lg.w,
        AppSpacing.lg.h + MediaQuery.viewPaddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AuthUiConstants.fieldBorder,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          SizedBox(height: AppSpacing.md.h),
          Text(
            AppTranslations.getText(context, 'select_governorate'),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: AuthUiConstants.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.md.h),
          TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _query = value),
            decoration: InputDecoration(
              hintText: AppTranslations.getText(context, 'search_governorate'),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: AppColors.button,
                size: 22.sp,
              ),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                      icon: Icon(
                        Icons.close_rounded,
                        size: 20.sp,
                        color: AuthUiConstants.hintColor,
                      ),
                    )
                  : null,
              filled: true,
              fillColor: const Color(0xFFF1F3F6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: const BorderSide(
                  color: AuthUiConstants.fieldBorder,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: const BorderSide(
                  color: AuthUiConstants.fieldBorder,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide(color: AppColors.button, width: 1.4),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.md.h),
          SizedBox(
            height: 320.h,
            child: BlocBuilder<GovernoratesCubit, GovernoratesState>(
              builder: (context, state) {
                if (state is GovernoratesLoading) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.main1),
                  );
                }

                if (state is GovernoratesSuccess) {
                  final filtered = _filter(state.governorates);
                  if (filtered.isEmpty) {
                    return Center(
                      child: Text(
                        AppTranslations.getText(context, 'no_results'),
                        style: TextStyle(
                          color: AuthUiConstants.mutedText,
                          fontSize: 14.sp,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      color: AuthUiConstants.fieldBorder,
                    ),
                    itemBuilder: (context, index) {
                      final gov = filtered[index];
                      final isSelected = widget.selectedName == gov.name;

                      return ListTile(
                        tileColor: isSelected
                            ? AppColors.button.withValues(alpha: 0.08)
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        title: Text(
                          gov.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: isSelected
                                ? AppColors.button
                                : AuthUiConstants.textPrimary,
                          ),
                        ),
                        trailing: Icon(
                          isSelected
                              ? Icons.check_circle_rounded
                              : Icons.chevron_left_rounded,
                          color: AppColors.button,
                        ),
                        onTap: () {
                          widget.onSelected(gov);
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                }

                if (state is GovernoratesFailure) {
                  return Center(child: Text(state.errMessage));
                }

                return Center(
                  child: Text(AppTranslations.getText(context, 'no_data')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
