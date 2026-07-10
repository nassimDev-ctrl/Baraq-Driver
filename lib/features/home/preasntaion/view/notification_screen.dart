import 'package:drever_warr/core/cash/preferences_servis.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/transleat/app_translat.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/cubit_notification/cubit.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/cubit_notification/cubit_stat.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/model/notification_model.dart';
import 'package:drever_warr/features/preasntaion/widhets/icon_bak.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'notification_detail_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _lang = 'ar';
  List<NotificationItemModel> _items = [];

  @override
  void initState() {
    super.initState();
    _loadLang();
    context.read<NotificationCubit>().fetchNotifications();
  }

  Future<void> _loadLang() async {
    final lang = await CacheManager.getData('app_language');
    if (mounted && lang != null) {
      setState(() => _lang = lang);
    }
  }

  void _confirmDelete(NotificationItemModel item) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          AppTranslations.getText(context, "delete_notification"),
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
        ),
        content: Text(
          AppTranslations.getText(context, "delete_notification_confirm"),
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              AppTranslations.getText(context, "cancel"),
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<NotificationCubit>().deleteNotification(item.id);
            },
            child: Text(
              AppTranslations.getText(context, "delete"),
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
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
                  AppTranslations.getText(context, "notifications"),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F1F1F),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: BlocConsumer<NotificationCubit, NotificationState>(
                listener: (context, state) {
                  if (state is NotificationSuccess) {
                    setState(() => _items = List.from(state.data.notifications));
                  }
                  if (state is NotificationDeleteSuccess) {
                    setState(() {
                      _items.removeWhere((e) => e.id == state.deletedId);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppTranslations.getText(
                              context, "notification_deleted"),
                        ),
                        backgroundColor: AppColors.main1,
                      ),
                    );
                  }
                  if (state is NotificationDeleteFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errMessage),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                buildWhen: (prev, curr) =>
                    curr is NotificationLoading ||
                    curr is NotificationSuccess ||
                    curr is NotificationFailure,
                builder: (context, state) {
                  if (state is NotificationLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.main1,
                      ),
                    );
                  }

                  if (state is NotificationFailure) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48.sp,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              AppTranslations.getText(
                                  context, "error_occurred"),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            TextButton(
                              onPressed: () {
                                context
                                    .read<NotificationCubit>()
                                    .fetchNotifications();
                              },
                              child: Text(
                                AppTranslations.getText(context, "retry"),
                                style: TextStyle(
                                  color: AppColors.main1,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (_items.isEmpty && state is NotificationSuccess) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.notifications_off_outlined,
                            size: 48.sp,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            AppTranslations.getText(
                                context, "no_notifications"),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: AppColors.main1,
                    onRefresh: () => context
                        .read<NotificationCubit>()
                        .fetchNotifications(),
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      itemCount: _items.length,
                      separatorBuilder: (_, __) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return Dismissible(
                          key: ValueKey(item.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 20.w),
                            decoration: BoxDecoration(
                              color: Colors.red.shade400,
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                              size: 26.sp,
                            ),
                          ),
                          confirmDismiss: (_) async {
                            _confirmDelete(item);
                            return false;
                          },
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NotificationDetailScreen(
                                    notificationId: item.id,
                                  ),
                                ),
                              );
                            },
                            child: _NotificationCard(
                              item: item,
                              lang: _lang,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationItemModel item;
  final String lang;

  const _NotificationCard({required this.item, required this.lang});

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
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppColors.main1.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_rounded,
                  size: 20.sp,
                  color: AppColors.main1,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  item.getTitle(lang),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F1F1F),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            item.getMessage(lang),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.sp,
              height: 1.5,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 8.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _formatDate(item.createdAt),
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.grey.shade500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
