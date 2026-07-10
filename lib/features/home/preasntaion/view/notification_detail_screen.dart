import 'package:drever_warr/core/cash/preferences_servis.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/transleat/app_translat.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/cubit_notification/cubit.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/cubit_notification/cubit_stat.dart';
import 'package:drever_warr/features/preasntaion/widhets/icon_bak.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class NotificationDetailScreen extends StatefulWidget {
  final String notificationId;

  const NotificationDetailScreen({super.key, required this.notificationId});

  @override
  State<NotificationDetailScreen> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  String _lang = 'ar';

  @override
  void initState() {
    super.initState();
    _loadLang();
    context.read<NotificationCubit>().fetchNotificationById(widget.notificationId);
  }

  Future<void> _loadLang() async {
    final lang = await CacheManager.getData('app_language');
    if (mounted && lang != null) {
      setState(() => _lang = lang);
    }
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr).toLocal();
      return DateFormat('yyyy/MM/dd  HH:mm').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const IconBak(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  AppTranslations.getText(context, "notification_details"),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F1F1F),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: BlocBuilder<NotificationCubit, NotificationState>(
                builder: (context, state) {
                  if (state is NotificationDetailLoading) {
                    return Center(
                      child: CircularProgressIndicator(color: AppColors.main1),
                    );
                  }

                  if (state is NotificationDetailFailure) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.error_outline, size: 48.sp, color: Colors.grey),
                          SizedBox(height: 12.h),
                          Text(
                            AppTranslations.getText(context, "error_occurred"),
                            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                          ),
                          SizedBox(height: 12.h),
                          TextButton(
                            onPressed: () {
                              context
                                  .read<NotificationCubit>()
                                  .fetchNotificationById(widget.notificationId);
                            },
                            child: Text(
                              AppTranslations.getText(context, "retry"),
                              style: TextStyle(color: AppColors.main1, fontSize: 14.sp),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is NotificationDetailSuccess) {
                    final item = state.item;
                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(18.w),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10.r),
                                  decoration: BoxDecoration(
                                    color: AppColors.main1.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.notifications_rounded,
                                    size: 24.sp,
                                    color: AppColors.main1,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    item.getTitle(_lang),
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1F1F1F),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              item.getMessage(_lang),
                              style: TextStyle(
                                fontSize: 14.sp,
                                height: 1.6,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Divider(color: Colors.grey.shade300),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 16.sp,
                                  color: Colors.grey.shade500,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  _formatDate(item.createdAt),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
