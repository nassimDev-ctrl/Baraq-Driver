// import 'package:drever_warr/core/asset/icon_asset.dart';
// import 'package:drever_warr/core/constant/app_spacing.dart';
// import 'package:drever_warr/core/widgets/customButton.dart';
// import 'package:drever_warr/core/widgets/customText.dart';
// import 'package:drever_warr/core/widgets/logo_app.dart';
// import 'package:drever_warr/features/presentation/widgets/icon_bak.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
 

// class NodeViewandcompl extends StatefulWidget {
//   const NodeViewandcompl({super.key});

//   @override
//   State<NodeViewandcompl> createState() => _NodeViewandcomplState();
// }

// class _NodeViewandcomplState extends State<NodeViewandcompl> {
//   final TextEditingController nodetext = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             IconBak(),
//             LogoSection(),
//             SizedBox(height: AppSpacing.xxs.h),
//             RowPaymentMethod(
//               title: "notes_and_complaints",
//               image: IconAssets.node,
//               hh: 10,
//               apptext: AppTextType.titleMedium,
//             ),

//             SizedBox(height: AppSpacing.x45.h),
//             CustomTextFieldNotes(hintText: "", controller: nodetext),
//             SizedBox(height: 250.h),
//             CustomButton(
//               title: "done",
//               onTap: () {
//                 String note = nodetext.text;

//                 // 2. تخزينه في الكيوبت (تأكد أنك أضفت متغير notes في الـ CreateTripCubit)
//                 // context.read<CreateTripCubit>().notes = note;

//                 // 3. الرجوع للصفحة السابقة بعد حفظ الملاحظة
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
