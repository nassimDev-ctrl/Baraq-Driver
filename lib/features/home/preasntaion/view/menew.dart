import 'package:drever_warr/features/home/preasntaion/view/compliant_screen.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/view/finsh_tripe.dart';
import 'package:drever_warr/features/preasntaion/widhets/login.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_profail/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/features/home/preasntaion/widget/contact_us_dialog.dart';
import 'package:drever_warr/features/home/preasntaion/view/wallt_screen.dart';
import 'package:drever_warr/features/home/preasntaion/widget/build_menu_item.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/view/order_view.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/view/my_profail.dart';
import 'package:drever_warr/features/setting/preasntaion/view/settings.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_profail/cubit_stat.dart';

import '../../../../core/cash/preferences_servis.dart';
import '../../../../core/service/notification_service.dart';
import 'notification_screen.dart';
import '../../../../core/transleat/app_translat.dart';
import '../data/cubit/logout_cubit/cubit.dart';
import '../data/cubit/logout_cubit/cubit_state.dart';

class MenueView extends StatelessWidget {
  const MenueView({super.key});

  static const String _appShareLink = 'https://taxiwaar.com/';
  static const String _websiteUrl = 'https://taxiwaar.com/';
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
                  AppTranslations.getText(context, "share_app_title"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F1F1F),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  AppTranslations.getText(context, "share_app_description"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5.sp,
                    height: 1.4,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w400,
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppTranslations.getText(
                                      context,
                                      "could_not_open_website",
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: AppColors.main1,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                          child: Text(
                            AppTranslations.getText(context, "website"),
                            style: TextStyle(
                              color: AppColors.main1,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
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
                                  "share_app_title",
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
                            AppTranslations.getText(context, "share"),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
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
              MaterialPageRoute(builder: (context) => const LoginView()),
              (route) => false,
            );
          }
        }
      },
      builder: (context, state) {
        final isLoggingOut = state is LogoutLoading;

        return Drawer(
          width: 285.w,
          backgroundColor: AppColors.main1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.horizontal(
              right: Radius.circular(24.r),
            ),
          ),
          child: Directionality(
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, profileState) {
                String name = "جاري التحميل...";
                String phone = "...";
                String? imagePath;

                if (profileState is ProfileSuccess) {
                  final data = profileState.data.data;
                  name =
                      "${data?.firstName ?? ''} ${data?.lastName ?? ''}".trim();
                  if (name.isEmpty) name = "سائق واصلني";
                  phone = data?.authUser?.mobilePhone ?? "لا يوجد رقم";
                  imagePath = data?.profileImage;
                } else if (profileState is ProfileFailure) {
                  name = "خطأ في البيانات";
                  phone = profileState.errMessage;
                }

                return SafeArea(
                  child: Column(
                    children: [
                      _buildHeader(name: name, phone: phone, imagePath: imagePath),
                      SizedBox(height: 12.h),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            BuildMenuItem(
                              icon: IconsAssets.mytrip,
                              title: "my_trips",
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OngoingJourney(),
                                ),
                              ),
                            ),
                            BuildMenuItem(
                              icon: IconsAssets.savelocation11,
                              title: "orders",
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrdersScreen(
                                    imagePath: imagePath,
                                  ),
                                ),
                              ),
                            ),
                            BuildMenuItem(
                              icon: IconsAssets.discountcodes,
                              title: "wallet",
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WalletScreen(),
                                ),
                              ),
                            ),
                            BuildMenuItem(
                              icon: IconsAssets.masseage,
                              title: "notifications",
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const NotificationScreen(),
                                ),
                              ),
                            ),
                            BuildMenuItem(
                              icon: IconsAssets.setting,
                              title: "settings",
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingsScreen(),
                                ),
                              ),
                            ),
                            BuildMenuItem(
                              icon: IconsAssets.technicalsupport,
                              title: "technical_support",
                              onTap: () {
                                Navigator.pop(context);
                                showContactUsDialog(context);
                              },
                            ),
                            BuildMenuItem(
                              icon: IconsAssets.profailicon,
                              title: "my_profile",
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DriverProfail(),
                                ),
                              ),
                            ),
                            BuildMenuItem(
                              icon: IconsAssets.masseage,
                              title: "feedback_complaints",
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommentsPage(),
                                ),
                              ),
                            ),
                            BuildMenuItem(
                              icon: IconsAssets.shareapplaction,
                              title: "share_app",
                              onTap: () => _showShareAppPopup(context),
                            ),
                            BuildMenuItem(
                              icon: IconsAssets.logout,
                              title: isLoggingOut ? "logging_out" : "logout",
                              isDestructive: true,
                              onTap: isLoggingOut
                                  ? null
                                  : () {
                                      context.read<LogoutCubit>().logout();
                                    },
                            ),
                          ],
                        ),
                      ),
                      _buildFooter(context),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader({
    required String name,
    required String phone,
    required String? imagePath,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 0),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _profileAvatar(imagePath),
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
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F1F1F),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  phone,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileAvatar(String? imagePath) {
    const String baseUrl = 'https://api.taxiwaar.com/';

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.main1.withValues(alpha: 0.35),
          width: 2,
        ),
      ),
      child: CircleAvatar(
        radius: 30.r,
        backgroundColor: Colors.grey[200],
        child: ClipOval(
          child: (imagePath != null && imagePath.isNotEmpty)
              ? Image.network(
                  imagePath.startsWith('http')
                      ? imagePath
                      : "$baseUrl$imagePath",
                  width: 60.r,
                  height: 60.r,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    ImageAssets.imageprofail,
                    fit: BoxFit.cover,
                  ),
                )
              : Image.asset(ImageAssets.imageprofail, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 16.h),
      child: Column(
        children: [
          Divider(
            color: Colors.white.withValues(alpha: 0.25),
            height: 1,
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _socialButton(
                icon: Icons.facebook,
                onTap: () async {
                  final uri = Uri.parse(
                    'https://www.facebook.com/share/1BAa9GrmrH/',
                  );
                  final ok = await launchUrl(
                    uri,
                    mode: LaunchMode.externalApplication,
                  );
                  if (!ok) {
                    throw Exception('Could not open Facebook link');
                  }
                },
              ),
              SizedBox(width: 16.w),
              _socialButton(
                icon: Icons.camera_alt,
                onTap: () async {
                  final uri = Uri.parse(
                    'https://www.instagram.com/waar.taxi/',
                  );
                  final ok = await launchUrl(
                    uri,
                    mode: LaunchMode.externalApplication,
                  );
                  if (!ok) {
                    throw Exception('Could not open Instagram link');
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 12.h),
          FutureBuilder<PackageInfo>(
            future: _getPackageInfo(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }

              final info = snapshot.data!;
              return Text(
                '${AppTranslations.getText(context, "app_version")} ${info.version} (${info.buildNumber})',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.65),
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _socialButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white.withValues(alpha: 0.14),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: EdgeInsets.all(10.r),
          child: Icon(icon, color: Colors.white, size: 20.sp),
        ),
      ),
    );
  }
}
