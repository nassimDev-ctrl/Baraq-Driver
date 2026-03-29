import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/widgets/customButton.dart';
import 'package:drever_warr/features/preasntaion/widhets/icon_bak.dart';
import 'package:drever_warr/features/preasntaion/widhets/row_verification_code.dart';
import 'package:drever_warr/features/preasntaion/widhets/text_verification_code.dart';
import 'package:drever_warr/features/setting/preasntaion/view/new_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
 

class VerificationCodeforgetpassword2 extends StatefulWidget {
  final String mobilePhone;
  const VerificationCodeforgetpassword2({super.key, required this.mobilePhone});

  @override
  State<VerificationCodeforgetpassword2> createState() =>
      _VerificationCodeforgetpasswordState();
}

class _VerificationCodeforgetpasswordState
    extends State<VerificationCodeforgetpassword2> {
  // متغير لتخزين الكود المدخل
  // String otpCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary1,
      resizeToAvoidBottomInset: true,
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                const IconBak(), // زر الرجوع

                Image.asset(ImageAssets.phone, height: 250.h, width: 250.w),

                // النص اللي بيعرض الرقم اللي انرسل له الكود
                TextVerificationCode(phone: widget.mobilePhone),

                SizedBox(height: 25.h),

                // حقول إدخال الكود (PIN Code)
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 20.w),
                //   child: PinCodeTextField(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     appContext: context,
                //     length: 4,
                //     onChanged: (value) => otpCode = value,
                //     keyboardType: TextInputType.number,
                //     animationType: AnimationType.fade,
                //     pinTheme: PinTheme(
                //       shape: PinCodeFieldShape.box,
                //       borderRadius: BorderRadius.circular(12.r),
                //       fieldHeight: 60.h,
                //       fieldWidth: 60.w,
                //       fieldOuterPadding: EdgeInsets.symmetric(horizontal: 10.w),
                //       activeFillColor: Colors.white,
                //       inactiveFillColor: Colors.white,
                //       selectedFillColor: Colors.white,
                //       activeColor: Colors.transparent,
                //       inactiveColor: Colors.transparent,
                //       selectedColor: Colors.green,
                //     ),
                //     cursorColor: Colors.black,
                //     enableActiveFill: true,
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(4, (index) {
                    // غير 4 لـ 6 إذا كان الكود أطول
                    return SizedBox(
                      height: 60.h,
                      width: 60.w,
                      child: TextFormField(
                        onChanged: (value) {
                          if (value.length == 1 && index < 3) {
                            FocusScope.of(
                              context,
                            ).nextFocus(); // ينتقل للمربع التالي تلقائياً
                          }
                          if (value.isEmpty && index > 0) {
                            FocusScope.of(
                              context,
                            ).previousFocus(); // يرجع للمربع السابق عند الحذف
                          }
                          // هنا يمكنك تجميع الكود في متغير otpCode
                        },
                        style: Theme.of(context).textTheme.headlineMedium,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          // يمنع إدخال أكثر من رقم واحد في المربع
                          //  import 'package:flutter/services.dart'; // تحتاج لهذا الـ import
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(color: AppColors.main1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              color: AppColors
                                  .main1, // غير اللون من هنا (مثلاً رمادي فاتح)
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              color: AppColors.main1,
                            ), // لون المربع عند الاختيار
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 20.h),

                // السطر الخاص بإعادة الإرسال
                RowVerificationCode(
                  onResend: () {
                    // منطق إعادة الإرسال (UI فقط حالياً)
                    debugPrint("Resending code to ${widget.mobilePhone}");
                  },
                ),

                SizedBox(height: AppSpacing.x110.h),

                // زر التحقق
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: CustomButton(
                    title: "verification_title",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NewPassword(mobilePhone1: widget.mobilePhone),
                        ),
                      );
                      // if (otpCode.length == 4) {
                      //   // الانتقال لصفحة تعيين كلمة المرور الجديدة (UI Flow)
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => ConfermPassword(
                      //         mobilePhone1: widget.mobilePhone,
                      //       ),
                      //     ),
                      //   );
                      // } else {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     const SnackBar(
                      //       content: Text("يرجى إدخال الكود كاملاً"),
                      //     ),
                      //   );
                      // }
                    },
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
