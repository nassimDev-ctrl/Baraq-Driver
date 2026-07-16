import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/cash/preferences_service.dart';
import 'package:drever_warr/core/constant/api_constants.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/service/notification_service.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/app_snack_bar.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/logout_cubit/cubit.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/logout_cubit/cubit_state.dart';
import 'package:drever_warr/features/home/presentation/view/compliant_screen.dart';
import 'package:drever_warr/features/home/presentation/view/notification_screen.dart';
import 'package:drever_warr/features/home/presentation/view/wallt_screen.dart';
import 'package:drever_warr/features/home/presentation/widget/build_menu_item.dart';
import 'package:drever_warr/features/home/presentation/widget/contact_us_dialog.dart';
import 'package:drever_warr/features/my_oreder/presentation/view/order_view.dart';
import 'package:drever_warr/features/my_tripe/presentation/view/finsh_tripe.dart';
import 'package:drever_warr/features/my_tripe/presentation/view/my_profail.dart';
import 'package:drever_warr/features/presentation/widgets/login.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_profail/cubit.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_profail/cubit_stat.dart';
import 'package:drever_warr/features/setting/presentation/view/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MenueView extends StatelessWidget {
  const MenueView({super.key});

  static const String _appShareLink = 'https://waslninow.com/';
  static const String _websiteUrl = 'https://waslninow.com/';
  static Future<PackageInfo>? _packageInfoFuture;

  static Future<PackageInfo> _getPackageInfo() {
    return _packageInfoFuture ??= PackageInfo.fromPlatform();
  }

  Future<void> _clearSessionData() async {
    await NotificationService.instance.clearToken();
    await CacheManager.clearSession();
  }

  Future<void> _showShareAppPopup(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64.r,
                  height: 64.r,
                  decoration: BoxDecoration(
                    color: AppColors.main1.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.share_rounded,
                    size: 32.sp,
                    color: AppColors.main1,
                  ),
                ),
                SizedBox(height: 18.h),
                Text(
                  AppTranslations.getText(context, 'share_app_title'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: AuthUiConstants.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  AppTranslations.getText(context, 'share_app_description'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5.sp,
                    height: 1.4,
                    color: AuthUiConstants.mutedText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 22.h),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 46.h,
                        child: OutlinedButton(
                          onPressed: () async {
                            Navigator.of(dialogContext).pop();
                            final uri = Uri.parse(_websiteUrl);
                            final ok = await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                            if (!ok && context.mounted) {
                              AppSnackBar.error(
                                context,
                                AppTranslations.getText(
                                  context,
                                  'could_not_open_website',
                                ),
                              );
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.main1, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                          child: Text(
                            AppTranslations.getText(context, 'website'),
                            style: TextStyle(
                              color: AppColors.main1,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: SizedBox(
                        height: 46.h,
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.of(dialogContext).pop();
                            await SharePlus.instance.share(
                              ShareParams(
                                text: _appShareLink,
                                subject: AppTranslations.getText(
                                  context,
                                  'share_app_title',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.main1,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                          child: Text(
                            AppTranslations.getText(context, 'share'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = BuildMenuItem.isRtlLocale(context);

    return BlocConsumer<LogoutCubit, LogoutState>(
      listener: (context, state) async {
        if (state is LogoutSuccess) {
          await _clearSessionData();
          if (context.mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginView()),
              (route) => false,
            );
          }
        }
      },
      builder: (context, state) {
        final isLoggingOut = state is LogoutLoading;

        return Drawer(
          width: 304.w,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.horizontal(
              right: isRtl ? Radius.zero : Radius.circular(28.r),
              left: isRtl ? Radius.circular(28.r) : Radius.zero,
            ),
          ),
          child: Directionality(
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, profileState) {
                String name = '...';
                String phone = '...';
                String? imagePath;
                num rating = 0;

                if (profileState is ProfileSuccess) {
                  final data = profileState.data.data;
                  name =
                      '${data?.firstName ?? ''} ${data?.lastName ?? ''}'.trim();
                  if (name.isEmpty) {
                    name = AppTranslations.getText(context, 'driver_brand_name');
                  }
                  phone = data?.authUser?.mobilePhone ?? '-';
                  imagePath = data?.profileImage;
                  rating = data?.rating ?? 0;
                } else if (profileState is ProfileFailure) {
                  name = AppTranslations.getText(context, 'error_occurred');
                  phone = profileState.errMessage;
                }

                return Column(
                  children: [
                    _DrawerHeader(
                      name: name,
                      phone: phone,
                      imagePath: imagePath,
                      rating: rating,
                      onClose: () => Navigator.pop(context),
                      onProfileTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DriverProfail(),
                          ),
                        );
                      },
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                        children: [
                          DrawerSectionTitle('menu_section_main'),
                          BuildMenuItem(
                            iconData: Icons.local_taxi_rounded,
                            title: 'orders',
                            accentColor: AppColors.main1,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    OrdersScreen(imagePath: imagePath),
                              ),
                            ),
                          ),
                          BuildMenuItem(
                            iconData: Icons.history_rounded,
                            title: 'my_trips',
                            accentColor: const Color(0xFF7C3AED),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const OngoingJourney(),
                              ),
                            ),
                          ),
                          BuildMenuItem(
                            iconData: Icons.account_balance_wallet_outlined,
                            title: 'wallet',
                            accentColor: AppColors.button,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const WalletScreen(),
                              ),
                            ),
                          ),
                          DrawerSectionTitle('menu_section_account'),
                          BuildMenuItem(
                            iconData: Icons.person_outline_rounded,
                            title: 'my_profile',
                            accentColor: const Color(0xFF0EA5E9),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const DriverProfail(),
                              ),
                            ),
                          ),
                          BuildMenuItem(
                            iconData: Icons.notifications_none_rounded,
                            title: 'notifications',
                            accentColor: const Color(0xFFF59E0B),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const NotificationScreen(),
                              ),
                            ),
                          ),
                          BuildMenuItem(
                            iconData: Icons.settings_outlined,
                            title: 'settings',
                            accentColor: AuthUiConstants.mutedText,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SettingsScreen(),
                              ),
                            ),
                          ),
                          DrawerSectionTitle('menu_section_more'),
                          BuildMenuItem(
                            iconData: Icons.support_agent_rounded,
                            title: 'technical_support',
                            accentColor: const Color(0xFF14B8A6),
                            onTap: () {
                              Navigator.pop(context);
                              showContactUsDialog(context);
                            },
                          ),
                          BuildMenuItem(
                            iconData: Icons.feedback_outlined,
                            title: 'feedback_complaints',
                            accentColor: const Color(0xFFEF4444),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CommentsPage(),
                              ),
                            ),
                          ),
                          BuildMenuItem(
                            iconData: Icons.ios_share_rounded,
                            title: 'share_app',
                            accentColor: AppColors.main1,
                            onTap: () => _showShareAppPopup(context),
                          ),
                          SizedBox(height: 8.h),
                          BuildMenuItem(
                            iconData: Icons.logout_rounded,
                            title: isLoggingOut ? 'logging_out' : 'logout',
                            isDestructive: true,
                            onTap: isLoggingOut
                                ? null
                                : () => context.read<LogoutCubit>().logout(),
                          ),
                        ],
                      ),
                    ),
                    _DrawerFooter(getPackageInfo: _getPackageInfo),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({
    required this.name,
    required this.phone,
    required this.imagePath,
    required this.rating,
    required this.onClose,
    required this.onProfileTap,
  });

  final String name;
  final String phone;
  final String? imagePath;
  final num rating;
  final VoidCallback onClose;
  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final resolvedUrl = ApiConstants.resolveMediaUrl(imagePath);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md.w,
        topInset + 12.h,
        AppSpacing.md.w,
        20.h,
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
              Text(
                AppTranslations.getText(context, 'brand_name'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              Material(
                color: Colors.white.withValues(alpha: 0.14),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onClose,
                  child: SizedBox(
                    width: 36.r,
                    height: 36.r,
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: onProfileTap,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56.r,
                    height: 56.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
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
                          : Image.asset(
                              ImageAssets.imageprofail,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          phone,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: const Color(0xFFFFC107),
                              size: 15.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              rating.toStringAsFixed(1),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              AppTranslations.getText(context, 'my_profile'),
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.75),
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white.withValues(alpha: 0.7),
                    size: 14.sp,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerFooter extends StatelessWidget {
  const _DrawerFooter({required this.getPackageInfo});

  final Future<PackageInfo> Function() getPackageInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: AuthUiConstants.fieldFill,
        border: Border(
          top: BorderSide(color: AuthUiConstants.fieldBorder),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SocialButton(
                  icon: Icons.facebook_rounded,
                  onTap: () async {
                    final uri = Uri.parse(
                      'https://www.facebook.com/share/1BAa9GrmrH/',
                    );
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  },
                ),
                SizedBox(width: 12.w),
                _SocialButton(
                  icon: Icons.camera_alt_outlined,
                  onTap: () async {
                    final uri = Uri.parse(
                      'https://www.instagram.com/waar.taxi/',
                    );
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  },
                ),
              ],
            ),
            SizedBox(height: 10.h),
            FutureBuilder<PackageInfo>(
              future: getPackageInfo(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();
                final info = snapshot.data!;
                return Text(
                  '${AppTranslations.getText(context, 'app_version')} ${info.version} (${info.buildNumber})',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AuthUiConstants.mutedText,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AuthUiConstants.fieldBorder),
          ),
          child: Icon(icon, color: AppColors.main1, size: 18.sp),
        ),
      ),
    );
  }
}
