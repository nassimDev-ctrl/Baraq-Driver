import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/model/wallat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatisticsSection extends StatelessWidget {
  const StatisticsSection({
    super.key,
    required this.operations,
  });

  final List<WalletOperationModel> operations;

  static const _arMonths = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];

  static const _enMonths = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  num get _totalEarnings {
    return operations
        .where((op) => op.type == 'charge')
        .fold<num>(0, (sum, op) => sum + op.amount);
  }

  DateTime? get _lastDate {
    if (operations.isEmpty) return null;
    final sorted = [...operations]..sort((a, b) => b.date.compareTo(a.date));
    final raw = sorted.first.date;
    if (raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  String _formatDate(BuildContext context, DateTime date) {
    final lang = Localizations.localeOf(context).languageCode;
    if (lang == 'ar') {
      return '${date.day} ${_arMonths[date.month - 1]} ${date.year}';
    }
    return '${date.day} ${_enMonths[date.month - 1]} ${date.year}';
  }

  String _relativeDays(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final days = today.difference(target).inDays;
    if (days <= 0) {
      return AppTranslations.getText(context, 'today');
    }
    if (days == 1) {
      return AppTranslations.getText(context, 'day_ago');
    }
    return AppTranslations.getText(context, 'days_ago')
        .replaceAll('{n}', '$days');
  }

  String _formatAmount(num value) {
    final text = value.toStringAsFixed(value % 1 == 0 ? 0 : 2);
    final parts = text.split('.');
    final chars = parts[0].replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    if (parts.length == 1) return chars;
    return '$chars.${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    final currency = AppTranslations.getText(context, 'currency_syp');
    final last = _lastDate;
    final count = operations.length;

    final columns = [
      _StatColumnData(
        icon: Icons.calendar_today_outlined,
        iconColor: AppColors.main1,
        labelKey: 'last_payment',
        value: last != null ? _formatDate(context, last) : '—',
        subtitle: last != null ? _relativeDays(context, last) : '—',
      ),
      _StatColumnData(
        icon: Icons.directions_car_outlined,
        iconColor: AppColors.main1,
        labelKey: 'operations_count',
        value: '$count',
        subtitle: count == 1
            ? AppTranslations.getText(context, 'operation_unit')
            : AppTranslations.getText(context, 'operations_unit'),
      ),
      _StatColumnData(
        icon: Icons.trending_up_rounded,
        iconColor: AppColors.button,
        labelKey: 'total_earnings',
        value: _formatAmount(_totalEarnings),
        subtitle: currency,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE8ECF1)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            for (var i = 0; i < columns.length; i++) ...[
              if (i > 0)
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: const Color(0xFFE8ECF1),
                  indent: 4.h,
                  endIndent: 4.h,
                ),
              Expanded(child: _StatColumn(data: columns[i])),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatColumnData {
  const _StatColumnData({
    required this.icon,
    required this.iconColor,
    required this.labelKey,
    required this.value,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final String labelKey;
  final String value;
  final String subtitle;
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.data});

  final _StatColumnData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(data.icon, size: 14.sp, color: data.iconColor),
              SizedBox(width: 4.w),
              Flexible(
                child: Text(
                  AppTranslations.getText(context, data.labelKey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AuthUiConstants.mutedText,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            data.value,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AuthUiConstants.textPrimary,
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AuthUiConstants.mutedText,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
