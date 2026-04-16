 
import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/model/ScheduledTrips.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/view/order_view.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/widget/card_point_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderCard extends StatelessWidget {
  final OrderButtonStatus buttonStatus;
  final ScheduledTripModel trip;  

  const OrderCard({super.key, required this.buttonStatus, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: AppColors.main1.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.main1.withOpacity(0.12),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
         
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    trip.scheduledDate ?? "غير محدد",  
                    type: AppTextType.titleSmall,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomText(
                    trip.clientName ?? "عميل واري",
                    type: AppTextType.titleSmall,
                  ),
                  CustomText(
                    trip.clientPhone ?? "",
                    type: AppTextType.bodySmall,
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 20.h),

        
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "${trip.totalPrice.toStringAsFixed(0)} SYP",
                      color: Colors.cyan,
                      type: AppTextType.titleSmall,
                    ),
                    SizedBox(height: 35.h),
                    _buildActionButton(),
                  ],
                ),
              ),

              
              Expanded(
                flex: 3,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomText(
                            trip.sourceAddress,
                            type: AppTextType.bodySmall,
                            maxLines: 1,
                          ),
                          SizedBox(height: 35.h),
                          CustomText(
                            trip.destinationAddress,
                            type: AppTextType.bodySmall,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Column(
                      children: [
                        Icon(
                          Icons.radio_button_unchecked,
                          color: Colors.grey,
                          size: 18.sp,
                        ),
                        CustomPaint(
                          size: Size(1, 25.h),
                          painter: DashedLinePainter(),
                        ),
                        SvgPicture.asset(
                          IconsAssets.locationsearch,
                          color: AppColors.blue,
                          width: 20.sp,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    bool isAccepted = buttonStatus == OrderButtonStatus.accepted;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isAccepted ? Colors.white : AppColors.main1,
        border: isAccepted
            ? Border.all(color: AppColors.main1, width: 1.2)
            : null,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        isAccepted ? "Accepted" : "Accept",
        style: GoogleFonts.cairo(
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
          color: isAccepted ? AppColors.main1 : Colors.white,
        ),
      ),
    );
  }
}
