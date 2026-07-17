import 'package:drever_warr/core/cash/preferences_service.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/app_snack_bar.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/cubit_notification/cubit.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/cubit_notification/cubit_stat.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/model/notification_model.dart';
import 'package:drever_warr/features/home/presentation/view/notification_detail_screen.dart';
import 'package:drever_warr/features/home/presentation/widget/notifications/notification_card.dart';
import 'package:drever_warr/features/home/presentation/widget/notifications/notifications_empty.dart';
import 'package:drever_warr/features/home/presentation/widget/notifications/notifications_header.dart';
import 'package:drever_warr/features/home/presentation/widget/notifications/notifications_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          AppTranslations.getText(context, 'delete_notification'),
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
        ),
        content: Text(
          AppTranslations.getText(context, 'delete_notification_confirm'),
          style: TextStyle(fontSize: 14.sp, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              AppTranslations.getText(context, 'cancel'),
              style: TextStyle(color: AuthUiConstants.mutedText),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<NotificationCubit>().deleteNotification(item.id);
            },
            child: Text(
              AppTranslations.getText(context, 'delete'),
              style: const TextStyle(color: Color(0xFFEF4444)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: Column(
        children: [
          NotificationsHeader(count: _items.length),
          Expanded(
            child: Transform.translate(
              offset: Offset(0, -14.h),
              child: BlocConsumer<NotificationCubit, NotificationState>(
                listener: (context, state) {
                  if (state is NotificationSuccess) {
                    setState(
                      () => _items = List.from(state.data.notifications),
                    );
                  }
                  if (state is NotificationDeleteSuccess) {
                    setState(() {
                      _items.removeWhere((e) => e.id == state.deletedId);
                    });
                    AppSnackBar.info(
                      context,
                      AppTranslations.getText(context, 'notification_deleted'),
                    );
                  }
                  if (state is NotificationDeleteFailure) {
                    AppSnackBar.error(context, state.errMessage);
                  }
                },
                buildWhen: (prev, curr) =>
                    curr is NotificationLoading ||
                    curr is NotificationSuccess ||
                    curr is NotificationFailure,
                builder: (context, state) {
                  if (state is NotificationLoading) {
                    return Center(
                      child: CircularProgressIndicator(color: AppColors.main1),
                    );
                  }

                  if (state is NotificationFailure) {
                    return _NotificationsError(
                      onRetry: () => context
                          .read<NotificationCubit>()
                          .fetchNotifications(),
                    );
                  }

                  if (_items.isEmpty && state is NotificationSuccess) {
                    return const NotificationsEmpty();
                  }

                  return RefreshIndicator(
                    color: AppColors.main1,
                    onRefresh: () => context
                        .read<NotificationCubit>()
                        .fetchNotifications(),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: EdgeInsets.fromLTRB(
                        NotificationsUiConstants.horizontalPadding.w,
                        0,
                        NotificationsUiConstants.horizontalPadding.w,
                        24.h,
                      ),
                      itemCount: _items.length,
                      separatorBuilder: (_, __) => SizedBox(
                        height: NotificationsUiConstants.sectionSpacing.h,
                      ),
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return Dismissible(
                          key: ValueKey(item.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 20.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444),
                              borderRadius: BorderRadius.circular(
                                NotificationsUiConstants.cardRadius.r,
                              ),
                            ),
                            child: Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.white,
                              size: 26.sp,
                            ),
                          ),
                          confirmDismiss: (_) async {
                            _confirmDelete(item);
                            return false;
                          },
                          child: NotificationCard(
                            item: item,
                            lang: _lang,
                            animationIndex: index,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NotificationDetailScreen(
                                    notificationId: item.id,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationsError extends StatelessWidget {
  const _NotificationsError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 44.sp,
              color: AuthUiConstants.iconMuted,
            ),
            SizedBox(height: 12.h),
            Text(
              AppTranslations.getText(context, 'error_occurred'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AuthUiConstants.textPrimary,
              ),
            ),
            SizedBox(height: 14.h),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(AppTranslations.getText(context, 'retry')),
              style: TextButton.styleFrom(foregroundColor: AppColors.main1),
            ),
          ],
        ),
      ),
    );
  }
}
