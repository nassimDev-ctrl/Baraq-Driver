import 'package:drever_warr/core/constant/api_constants.dart';
import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/app_snack_bar.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/driver_available_cubit/cubit.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/driver_available_cubit/cubit_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderOrder extends StatefulWidget {
  final VoidCallback onMenuTap;
  final bool con;
  final int urgentCount;
  final int scheduledCount;
  final String? imagePath;

  const HeaderOrder({
    super.key,
    required this.onMenuTap,
    required this.con,
    required this.urgentCount,
    required this.scheduledCount,
    required this.imagePath,
  });

  @override
  State<HeaderOrder> createState() => _HeaderOrderState();
}

class _HeaderOrderState extends State<HeaderOrder> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DriverStatusCubit>().fetchDriverAvailability();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AuthUiConstants.headerGradient,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md.w,
            AppSpacing.sm.h,
            AppSpacing.md.w,
            16.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Material(
                    color: Colors.white.withValues(alpha: 0.16),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: widget.onMenuTap,
                      child: SizedBox(
                        width: 42.r,
                        height: 42.r,
                        child: Icon(
                          Icons.menu_rounded,
                          color: Colors.white,
                          size: 22.sp,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    AppTranslations.getText(context, 'orders'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  _ProfileAvatar(imagePath: widget.imagePath),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: _CountChip(
                      icon: Icons.flash_on_rounded,
                      label: AppTranslations.getText(context, 'urgent_orders'),
                      count: widget.urgentCount,
                      color: AppColors.accentOrange,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _CountChip(
                      icon: Icons.event_available_rounded,
                      label: AppTranslations.getText(
                        context,
                        'scheduled_orders',
                      ),
                      count: widget.scheduledCount,
                      color: const Color(0xFF38BDF8),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              const _AvailabilityBanner(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountChip extends StatelessWidget {
  const _CountChip({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  final IconData icon;
  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 30.r,
            height: 30.r,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: Colors.white, size: 16.sp),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$count',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AvailabilityBanner extends StatelessWidget {
  const _AvailabilityBanner();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DriverStatusCubit, DriverStatusState>(
      listener: (context, state) {
        if (state is DriverStatusFailure) {
          AppSnackBar.error(context, state.errMessage);
        }
      },
      builder: (context, state) {
        var isAvailable = false;
        var isLoading = false;

        if (state is DriverStatusLoaded) {
          isAvailable = state.isAvailable;
          isLoading = state.isUpdating;
        } else if (state is DriverStatusLoading) {
          isLoading = true;
        }

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Row(
            children: [
              Container(
                width: 8.r,
                height: 8.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isAvailable
                      ? const Color(0xFF5CE1A8)
                      : const Color(0xFF9CA3AF),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  AppTranslations.getText(
                    context,
                    isAvailable ? 'driver_online' : 'driver_offline',
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              GestureDetector(
                onTap: isLoading
                    ? null
                    : () => context
                        .read<DriverStatusCubit>()
                        .toggleDriverAvailability(),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 46.w,
                  height: 26.h,
                  padding: EdgeInsets.all(3.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: isAvailable
                        ? AppColors.button
                        : Colors.white.withValues(alpha: 0.28),
                  ),
                  child: isLoading
                      ? Center(
                          child: SizedBox(
                            width: 12.r,
                            height: 12.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : AnimatedAlign(
                          duration: const Duration(milliseconds: 220),
                          alignment: isAvailable
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            width: 20.r,
                            height: 20.r,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.imagePath});

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final resolvedUrl = ApiConstants.resolveMediaUrl(imagePath);

    return Container(
      width: 42.r,
      height: 42.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        color: Colors.white.withValues(alpha: 0.2),
      ),
      child: ClipOval(
        child: resolvedUrl != null
            ? Image.network(
                resolvedUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset(
                  ImageAssets.imageprofail,
                  fit: BoxFit.cover,
                ),
              )
            : Image.asset(ImageAssets.imageprofail, fit: BoxFit.cover),
      ),
    );
  }
}
