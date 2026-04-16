 
import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/widgets/customButton.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_verificationRepo/cubit.dart';
import 'package:drever_warr/features/preasntaion/widhets/icon_bak.dart';
import 'package:drever_warr/features/preasntaion/widhets/row_verification_code.dart';
import 'package:drever_warr/features/preasntaion/widhets/text_verification_code.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_updet_phone/cubit.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_updet_phone/cubit_stat.dart';
import 'package:drever_warr/features/setting/preasntaion/view/user_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';  

 

class VerficationcodeEdetphone extends StatefulWidget {
  final String mobilePhone;
  const VerficationcodeEdetphone({super.key, required this.mobilePhone});

  @override
  State<VerficationcodeEdetphone> createState() =>
      _VerficationcodeEdetphoneState();
}

class _VerficationcodeEdetphoneState extends State<VerficationcodeEdetphone> {
  String otpCode = "";
  TextEditingController? _pinController;

  @override
  void initState() {
    super.initState();
   
    _pinController = TextEditingController();
  }

  @override
  void dispose() {
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pinController?.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateMobileCubit, UpdateMobileState>(
      listener: (context, state) {
        if (state is UpdateMobilePhoneSuccess) {
          FocusScope.of(context).unfocus();
        
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );

           
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const UserInformation()),
            (route) => false, 
          );
        } else if (state is UpdateMobileFailure) {
         
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.secondary1,
        resizeToAvoidBottomInset: true,
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  const IconBak(),
                  Image.asset(ImageAssets.phone, height: 250.h, width: 250.w),
                  TextVerificationCode(phone: widget.mobilePhone),
                  SizedBox(height: 25.h),

                
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: PinCodeTextField(
                        appContext: context,
                        length: 4,
                       
                        keyboardType: TextInputType.number,
                        animationType: AnimationType.fade,
                        autoFocus: true, 
                        cursorColor: AppColors.main1,

                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(12.r),
                          fieldHeight: 60.h,
                          fieldWidth: 60.w,
                          activeFillColor: Colors.white,
                          inactiveFillColor: Colors.white,
                          selectedFillColor: Colors.white,
                          activeColor: AppColors.main1,
                          inactiveColor: const Color(0xFFE0E0E0),
                          selectedColor: AppColors.main1,
                        ),

                        enableActiveFill: true,
                        onChanged: (value) {
                          otpCode = value;
                        },
                        onCompleted: (value) {
                         
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),
                  RowVerificationCode(
                    onResend: () {
                    
                      context.read<VerificationCubit>().sendVerificationCode(
                        mobilePhone: widget.mobilePhone,
                        typeOfUse: "change-mobile-phone",
                      );
                    },
                  ),

                  const Spacer(), 
              
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.w,
                      vertical: 30.h,
                    ),
                    child: BlocBuilder<UpdateMobileCubit, UpdateMobileState>(
                      builder: (context, state) {
                        if (state is UpdateMobileLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return CustomButton(
                          title: "verification_title",  
                          onTap: () => context
                              .read<UpdateMobileCubit>()
                              .changeMobilePhone(widget.mobilePhone, otpCode),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

   
}
