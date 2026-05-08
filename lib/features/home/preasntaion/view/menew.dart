import 'package:drever_warr/features/home/preasntaion/view/compliant_screen.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/view/finsh_tripe.dart';
import 'package:drever_warr/features/preasntaion/widhets/login.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_profail/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/features/home/preasntaion/view/wallt_screen.dart';
import 'package:drever_warr/features/home/preasntaion/widget/buildMenuItem.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/view/order_view.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/view/my_profail.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/view/start_tripe.dart';
import 'package:drever_warr/features/setting/preasntaion/view/settings.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_profail/cubit_stat.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/cash/preferences_servis.dart';
import '../../../../core/transleat/app_translat.dart';
import '../../../my_oreder/preasntaion/data/cubit/model/accsept_model.dart';
import '../data/cubit/logout_cubit/cubit.dart';
import '../data/cubit/logout_cubit/cubit_state.dart';

class MenueView extends StatelessWidget {
  const MenueView({super.key});

  static const String _appShareLink = 'https://taxiwaar.com/';
  static const String _websiteUrl = 'https://taxiwaar.com/';

  Future<void> logout(BuildContext context) async {
    await CacheManager.removeData('token');
    await CacheManager.removeData('status');


    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
          (route) => false,
    );
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
                  color: Colors.black.withOpacity(0.12),
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
                    color: AppColors.main1.withOpacity(0.12),
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
                            await Share.share(
                              _appShareLink,
                              subject: AppTranslations.getText(
                                context,
                                "share_app_title",
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
    return BlocConsumer<LogoutCubit, LogoutState>(
      listener: (context, state) async {
        if (state is LogoutSuccess) {
          await CacheManager.removeData('token');
          await CacheManager.removeData('status');

          if (context.mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginView()),
                  (route) => false,
            );
          }
        } else if (state is LogoutFailure) {
        }
      },
      builder: (context, state) {
        final isLoggingOut = state is LogoutLoading;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 70.0),
          child: Drawer(
            width: 250.w,
            backgroundColor: AppColors.main1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, profileState) {
                String name = "جاري التحميل...";
                String phone = "...";
                String? imagePath;

                if (profileState is ProfileSuccess) {
                  final data = profileState.data.data;
                  name = "${data?.firstName ?? ''} ${data?.lastName ?? ''}".trim();
                  if (name.isEmpty) name = "سائق واصلني";
                  phone = data?.authUser?.mobilePhone ?? "لا يوجد رقم";
                  imagePath = data?.profileImage;
                } else if (profileState is ProfileFailure) {
                  name = "خطأ في البيانات";
                  phone = profileState.errMessage;
                }

                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(15.w, 50.h, 15.w, 25.h),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomText(name, type: AppTextType.titleSmall),
                              SizedBox(height: 5.h),
                              CustomText(phone, type: AppTextType.titleSmall),
                            ],
                          ),
                          SizedBox(width: 15.w),
                          _profileAvatar(imagePath),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildGestureItem(
                              icon: IconsAssets.mytrip,
                              title: "my_trips",
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OngoingJourney(),
                                ),
                              ),
                            ),
                            _buildGestureItem(
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
                            _buildGestureItem(
                              icon: IconsAssets.discountcodes,
                              title: "wallet",
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WalletScreen(),
                                ),
                              ),
                            ),
                            _buildGestureItem(
                              icon: IconsAssets.setting,
                              title: "settings",
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingsScreen(),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                final uri = Uri.parse('https://wa.me/+41779877052');
                                final ok = await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                                if (!ok) {
                                  throw Exception('Could not open Instagram link');
                                }
                              },
                              child: BuildMenuItem(
                                icon: IconsAssets.technicalsupport,
                                title: "technical_support",
                              ),
                            ),
                            _buildGestureItem(
                              icon: IconsAssets.profailicon,
                              title: "my_profile",
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DriverProfail(),
                                ),
                              ),
                            ),
                            _buildGestureItem(
                              icon: IconsAssets.masseage,
                              title: "feedback_complaints",
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommentsPage(),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  if (context.mounted) {
                                    _showShareAppPopup(context);
                                  }
                                });
                              },
                              child: BuildMenuItem(
                                icon: IconsAssets.shareapplaction,
                                title: "share_app",
                              ),
                            ),
                            _buildGestureItem(
                              icon: IconsAssets.logout,
                              title: isLoggingOut ? "logging_out" : "logout",
                              onTap: isLoggingOut
                                  ? () {}
                                  : () {
                                context.read<LogoutCubit>().logout();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 30.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final uri = Uri.parse(
                                'https://www.facebook.com/share/1BAa9GrmrH/',
                              );
                              final ok = await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                              if (!ok) {
                                throw Exception('Could not open Instagram link');
                              }
                            },
                            child: _socialIcon(Icons.facebook),
                          ),
                          SizedBox(width: 20.w),
                          GestureDetector(
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
                            child: _socialIcon(Icons.camera_alt),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _profileAvatar(String? imagePath) {
    const String baseUrl = 'https://api.taxiwaar.com/';

    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        radius: 35.r,
        backgroundColor: Colors.grey[200],
        child: ClipOval(
          child: (imagePath != null && imagePath.isNotEmpty)
              ? Image.network(
            imagePath.startsWith('http')
                ? imagePath
                : "$baseUrl$imagePath",
            width: 70.r,
            height: 70.r,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Image.asset(ImageAssets.imageprofail, fit: BoxFit.cover),
          )
              : Image.asset(ImageAssets.imageprofail, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildGestureItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: BuildMenuItem(icon: icon, title: title),
    );
  }

  Widget _socialIcon(IconData icon) {
    return Icon(icon, color: Colors.white, size: 22.sp);
  }
}