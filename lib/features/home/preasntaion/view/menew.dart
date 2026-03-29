import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/features/home/preasntaion/view/wallt_screen.dart';
import 'package:drever_warr/features/home/preasntaion/widget/buildMenuItem.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/view/order_view.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/view/finsh_tripe.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/view/my_profail.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/view/start_tripe.dart';
import 'package:drever_warr/features/setting/preasntaion/view/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenueView extends StatelessWidget {
  const MenueView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 70.0),
      child: Drawer(
        width: 250.w,
        backgroundColor: AppColors.main1,
        // إزالة الحواف الافتراضية للـ Drawer ليتطابق مع حافة الشاشة
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(15.w, 50.h, 15.w, 25.h),
              decoration: const BoxDecoration(
                color: Colors.white,
                //  borderRadius: BorderRadius.all(),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.end, // محاذاة لليمين حسب الصورة
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomText("driver_name", type: AppTextType.titleSmall),
                      SizedBox(height: 5.h),
                      CustomText("+971 77788788", type: AppTextType.titleSmall),
                    ],
                  ),
                  SizedBox(width: 15.w),
                  CircleAvatar(
                    radius: 35.r,
                    backgroundImage: const AssetImage(ImageAssets.imageprofail),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // قائمة العناصر
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGestureItem(
                      icon: IconsAssets.mytrip,
                      title: "my_trips",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FinishedTripsScreen(),
                          ),
                        );
                      },
                    ),
                    _buildGestureItem(
                      icon: IconsAssets.savelocation11,
                      title: "orders",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrdersScreen(),
                          ),
                        );
                      },
                    ),
                    _buildGestureItem(
                      icon: IconsAssets.discountcodes,
                      title: "wallet",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WalletScreen(),
                          ),
                        );
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsScreen(),
                          ),
                        );
                      },
                      child: buildMenuItem(
                        icon: IconsAssets.setting,
                        title: "settings",
                      ),
                    ),
                    buildMenuItem(
                      icon: IconsAssets.technicalsupport,
                      title: "technical_support",
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DriverProfail(),
                          ),
                        );
                      },
                      child: buildMenuItem(
                        icon: IconsAssets.profailicon,
                        title: "my_profile",
                      ),
                    ),
                    buildMenuItem(
                      icon: IconsAssets
                          .shareapplaction, // استبدلها بأيقونة الملاحظات
                      title: "feedback_complaints",
                    ),
                    buildMenuItem(
                      icon: IconsAssets.shareapplaction,
                      title: "share_app",
                    ),
                  ],
                ),
              ),
            ),

            // أيقونات التواصل الاجتماعي في الأسفل
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
        ),
      ),
    );
  }

  // دالة مساعدة لتغليف العناصر بـ GestureDetector
  Widget _buildGestureItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: buildMenuItem(icon: icon, title: title),
    );
  }

  // دالة بناء أيقونات السوشيال ميديا
  Widget _socialIcon(IconData icon) {
    return Icon(icon, color: Colors.white, size: 22.sp);
  }
}
