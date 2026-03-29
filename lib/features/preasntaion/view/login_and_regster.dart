// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart'; // إضافة استيراد الـ Bloc
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:waslne/Features/Auth/preasntaion/data/repo/cubit/cubit_regster.dart/cubit_rejester.dart';
// import 'package:waslne/Features/Auth/preasntaion/data/repo/repo_implmantion.dart';
// import 'package:waslne/Features/Auth/preasntaion/widhets/login.dart';
// import 'package:waslne/Features/Auth/preasntaion/widhets/regster.dart';
// import 'package:waslne/core/asset/image_asset.dart';
// import 'package:waslne/core/constant/app_colors.dart';
// import 'package:waslne/core/constant/app_spacing.dart';
// import 'package:waslne/core/utiles/serves_lecture.dart';
// import 'package:waslne/core/widgets/custom_text.dart';

// class LoginandregsterView extends StatefulWidget {
//   const LoginandregsterView({super.key});

//   @override
//   State<LoginandregsterView> createState() => _LoginandregsterViewState();
// }

// class _LoginandregsterViewState extends State<LoginandregsterView> {
//   bool isLogin = true;

//   @override
//   Widget build(BuildContext context) {
//     // نستخدم MultiBlocProvider هنا لضمان توفر الكيوبت لكل من الـ Login والـ Register
//     return SafeArea(
//       bottom: true,
//       top: true,
//       child: Scaffold(
//         body: Container(
//           height: double.infinity,
//           width: double.infinity,
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [Color(0xFF031D4E), Color(0xFF0C4588), Color(0xFF072F6D)],
//             ),
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 SizedBox(height: AppSpacing.lg.h),
//                 Image.asset(ImageAssets.logo, height: 130.h, width: 130.w),
//                 SizedBox(height: AppSpacing.xxxlg.h),
//                 Container(
//                   margin: EdgeInsets.symmetric(horizontal: 10.w),
//                   padding: EdgeInsets.all(15.w),
//                   decoration: BoxDecoration(
//                     color: AppColors.secondary1,
//                     borderRadius: BorderRadius.vertical(
//                       top: Radius.circular(10),
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           _buildTabItem("login", isLogin, () {
//                             setState(() => isLogin = true);
//                           }),
//                           _buildTabItem("Register", !isLogin, () {
//                             setState(() => isLogin = false);
//                           }),
//                         ],
//                       ),
//                       SizedBox(height: 10.h),
//                       // الآن عند التبديل، سيجد كل Widget الكيوبت الخاص به في الـ context
//                       AnimatedSwitcher(
//                         duration: const Duration(milliseconds: 300),
//                         child: isLogin
//                             ? const Loginview()
//                             : const Regsterview(),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTabItem(String title, bool isActive, VoidCallback onTap) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: Column(
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 18.sp,
//                 fontWeight: FontWeight.bold,
//                 color: isActive ? Colors.black : Colors.grey,
//               ),
//             ),
//             SizedBox(height: 5.h),
//             Container(
//               height: 4.h,
//               width: 110.w,
//               decoration: BoxDecoration(
//                 color: isActive ? Colors.green : Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(15),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
