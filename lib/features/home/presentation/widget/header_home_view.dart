import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/api_constants.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/driver_available_cubit/cubit.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/driver_available_cubit/cubit_state.dart';
import 'package:drever_warr/features/home/presentation/view/notification_screen.dart';
import 'package:drever_warr/features/home/presentation/view/wallt_screen.dart';
import 'package:drever_warr/features/my_tripe/presentation/view/my_profail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderHomeView extends StatefulWidget {
  const HeaderHomeView({
    super.key,
    required this.driverBalance,
    required this.onMenuTap,
    this.imagePath,
    this.isProfileLoading = false,
    this.driverName,
    this.rating,
  });

  final VoidCallback onMenuTap;
  final String? imagePath;
  final num driverBalance;
  final bool isProfileLoading;
  final String? driverName;
  final num? rating;

  @override
  State<HeaderHomeView> createState() => _HeaderHomeViewState();
}

class _HeaderHomeViewState extends State<HeaderHomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<DriverStatusCubit>().fetchDriverAvailability();
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = ApiConstants.resolveMediaUrl(widget.imagePath);
    final topInset = MediaQuery.paddingOf(context).top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md.w,
        topInset + 10.h,
        AppSpacing.md.w,
        16.h,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AuthUiConstants.headerGradient,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _HeaderIconButton(
                icon: Icons.menu_rounded,
                onTap: widget.onMenuTap,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DriverProfail(),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      _ProfileAvatar(
                        imageUrl: imageUrl,
                        isLoading: widget.isProfileLoading,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.driverName?.trim().isNotEmpty == true
                                  ? widget.driverName!
                                  : AppTranslations.getText(
                                      context,
                                      'brand_name',
                                    ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  color: const Color(0xFFFFC107),
                                  size: 16.sp,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  (widget.rating ?? 0).toStringAsFixed(1),
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _HeaderIconButton(
                icon: Icons.notifications_none_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WalletScreen()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.16),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36.r,
                          height: 36.r,
                          decoration: BoxDecoration(
                            color: AppColors.button.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(11.r),
                          ),
                          child: Icon(
                            Icons.account_balance_wallet_outlined,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppTranslations.getText(
                                  context,
                                  'current_balance',
                                ),
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.75),
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                '${widget.driverBalance.toStringAsFixed(0)} SYP',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              const _AvailabilityToggle(),
            ],
          ),
        ],
      ),
    );
  }
}

class _AvailabilityToggle extends StatelessWidget {
  const _AvailabilityToggle();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverStatusCubit, DriverStatusState>(
      builder: (context, state) {
        final isAvailable = switch (state) {
          DriverStatusLoaded(:final isAvailable) => isAvailable,
          _ => false,
        };
        final isLoading = switch (state) {
          DriverStatusLoading() => true,
          DriverStatusLoaded(:final isUpdating) => isUpdating,
          _ => false,
        };

        return GestureDetector(
          onTap: isLoading
              ? null
              : () => context
                  .read<DriverStatusCubit>()
                  .toggleDriverAvailability(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isAvailable
                  ? AppColors.button.withValues(alpha: 0.22)
                  : Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isAvailable
                    ? AppColors.button.withValues(alpha: 0.55)
                    : Colors.white.withValues(alpha: 0.16),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading)
                  SizedBox(
                    width: 16.r,
                    height: 16.r,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                else
                  Container(
                    width: 10.r,
                    height: 10.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isAvailable
                          ? const Color(0xFF86EFAC)
                          : const Color(0xFFFCA5A5),
                      boxShadow: [
                        BoxShadow(
                          color: (isAvailable
                                  ? AppColors.button
                                  : Colors.redAccent)
                              .withValues(alpha: 0.45),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                SizedBox(width: 8.w),
                Text(
                  AppTranslations.getText(
                    context,
                    isAvailable ? 'driver_online' : 'driver_offline',
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(width: 6.w),
                Icon(
                  isAvailable
                      ? Icons.toggle_on_rounded
                      : Icons.toggle_off_rounded,
                  color: Colors.white,
                  size: 26.sp,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: SizedBox(
          width: 42.r,
          height: 42.r,
          child: Icon(icon, color: Colors.white, size: 22.sp),
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({
    required this.imageUrl,
    required this.isLoading,
  });

  final String? imageUrl;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46.r,
      height: 46.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: isLoading
            ? const ColoredBox(
                color: Color(0x33FFFFFF),
                child: Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            : imageUrl != null
                ? Image.network(
                    imageUrl!,
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
