 
import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/core/widgets/customTextFieldsearch.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/model/model_finsh_trips.dart';
import 'package:drever_warr/features/my_tripe/data/cubit/cubit_ratting/cubit.dart';
import 'package:drever_warr/features/my_tripe/data/cubit/cubit_ratting/cubit_stat.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/widget/TopColoumnDetailsTripEnd.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/widget/detals_row.dart';
import 'package:drever_warr/features/preasntaion/widhets/icon_bak.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class DetailsOfTheCompletedTrip extends StatefulWidget {
  final FinishedTripModel trip;

  const DetailsOfTheCompletedTrip({super.key, required this.trip});

  @override
  State<DetailsOfTheCompletedTrip> createState() =>
      _DetailsOfTheCompletedTripState();
}

class _DetailsOfTheCompletedTripState extends State<DetailsOfTheCompletedTrip> {
  final TextEditingController option = TextEditingController();
  int userRating = 0;  

  @override
  void dispose() {
    option.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;

    return BlocConsumer<AddRatingCubit, AddRatingState>(
      listener: (context, state) {
        if (state is AddRatingSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);  
        } else if (state is AddRatingFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const IconBak(),
                SizedBox(height: AppSpacing.xxxlg.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomText(
                        "تفاصيل الرحلة",
                        type: AppTextType.caption,
                        color: AppColors.blue,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.xxxxlg.h),

               
                TopColoumnDetailsTripEnd(
                  startAddress: trip.startAddress,
                  destinationAddress: trip.destinationAddress,
                ),

                SizedBox(height: AppSpacing.xxxlg.h),

               
                details_row(t1: "${trip.distance} m", t2: "المسافة المقطوعة"),
                SizedBox(height: AppSpacing.sm.h),
                details_row(
                  t1: "${trip.durationInsideCar} min",
                  t2: "الوقت المستغرق",
                ),
                SizedBox(height: AppSpacing.sm.h),
                details_row(
                  t1: "${trip.waitingDuration} min",
                  t2: "وقت الانتظار",
                ),

                SizedBox(height: AppSpacing.x45.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: CustomText(
                    "السفير",
                    type: AppTextType.titleMedium,
                    color: AppColors.blue,
                  ),
                ),
                SizedBox(height: AppSpacing.lg.h),

               
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomText(
                            trip.driverName,
                            type: AppTextType.titleSmall,
                            color: AppColors.secondary2,
                          ),
                          SizedBox(height: AppSpacing.xs.h),
                          CustomText(
                            trip.driverPhone,
                            type: AppTextType.titleSmall,
                            color: AppColors.secondary2,
                          ),
                        ],
                      ),
                      SizedBox(width: AppSpacing.sm.w),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child:
                            (trip.driverImage != null &&
                                trip.driverImage!.isNotEmpty)
                            ? Image.network(
                                'https://api.taxiwaar.com/${trip.driverImage}',
                                height: 75.h,
                                width: 75.w,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset(
                                      ImageAssets.imageprofail,
                                      height: 75.h,
                                      width: 75.w,
                                      fit: BoxFit.cover,
                                    ),
                              )
                            : Image.asset(
                                ImageAssets.imageprofail,
                                height: 75.h,
                                width: 75.w,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSpacing.lg.h),

              
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        "${trip.carName} - ${trip.carPlateNumber}",
                        type: AppTextType.titleSmall,
                        color: AppColors.secondary2,
                      ),
                      CustomText(
                        "نوع السيارة",
                        type: AppTextType.titleMedium,
                        color: AppColors.blue,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSpacing.lg.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: CustomText(
                    "تفاصيل الفاتورة",
                    type: AppTextType.titleMedium,
                    color: AppColors.blue,
                  ),
                ),
                SizedBox(height: AppSpacing.xxxlg.h),

               
                details_row(t1: "${trip.totalPrice} SYP", t2: "سعر الرحلة"),
                SizedBox(height: AppSpacing.sm.h),
                details_row(t1: "0", t2: "الخصم"),
                SizedBox(height: AppSpacing.sm.h),
                details_row(t1: "${trip.totalPrice} SYP", t2: "الإجمالي"),
                SizedBox(height: AppSpacing.sm.h),
                details_row(
                  t1: trip.paymentWay == "cash" ? "نقدي" : trip.paymentWay,
                  t2: "طريقة الدفع",
                ),

                SizedBox(height: AppSpacing.xxxxlg.h),

                
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: CustomText(
                    "تقييم الرحلة",
                    type: AppTextType.titleMedium,
                    color: AppColors.secondary1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            userRating = index + 1;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: SvgPicture.asset(
                            index < userRating
                                ? IconsAssets.staroption
                                : IconsAssets.stareoptionborder,
                            height: 35.h,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(height: AppSpacing.xxxxlg.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: CustomTextFieldsearch(
                    controller: option,
                    hintText: "اكتب رأيك هنا...",
                  ),
                ),

                SizedBox(height: 40.h),

               
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is AddRatingLoading
                          ? null
                          : () {
                              if (userRating == 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "يرجى اختيار عدد النجوم للتقييم",
                                    ),
                                  ),
                                );
                                return;
                              }
                              context.read<AddRatingCubit>().submitRating(
                                tripId: trip.id,
                                note: option.text,
                                rating: userRating,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.main1,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: state is AddRatingLoading
                          ? SizedBox(
                              height: 20.h,
                              width: 20.h,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "تأكيد وإرسال التقييم",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
