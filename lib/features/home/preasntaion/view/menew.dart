 
import 'package:drever_warr/features/my_tripe/preasntaion/view/finsh_tripe.dart';
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

class MenueView extends StatelessWidget {
  const MenueView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 70.0),
      child: Drawer(
        width: 250.w,
        backgroundColor: AppColors.main1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            String name = "جاري التحميل...";
            String phone = "...";
            String? imagePath;

            if (state is ProfileSuccess) {
              final data = state.data.data;
              name = "${data?.firstName ?? ''} ${data?.lastName ?? ''}".trim();
              if (name.isEmpty) name = "سائق واصلني";
              phone = data?.authUser?.mobilePhone ?? "لا يوجد رقم";
              imagePath = data?.profileImage;
            } else if (state is ProfileFailure) {
              name = "خطأ في البيانات";
              phone = state.errMessage;
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
                              builder: (context) => OrdersScreen(),
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
                        BuildMenuItem(
                          icon: IconsAssets.technicalsupport,
                          title: "technical_support",
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
                        BuildMenuItem(
                          icon: IconsAssets.shareapplaction,
                          title: "feedback_complaints",
                        ),
                        BuildMenuItem(
                          icon: IconsAssets.shareapplaction,
                          title: "share_app",
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
                      _socialIcon(Icons.facebook),
                      SizedBox(width: 20.w),
                      _socialIcon(Icons.camera_alt_outlined),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

    
  Widget _profileAvatar(String? imagePath) {
    const String baseUrl = 'https://api.taxiwaar.com/';

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // border: Border.all(color: AppColors.main1, width: 2),
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
