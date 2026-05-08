import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/transleat/app_translat.dart';
import '../../../home/preasntaion/data/cubit/driver_available_cubit/cubit.dart';
import '../../../home/preasntaion/data/cubit/driver_available_cubit/cubit_state.dart';

class HeaderOrder extends StatefulWidget {
  final VoidCallback onMenuTap;
  final bool con;
  final int urgentCount;
  final int scheduledCount;
  final String? imagePath;

  const HeaderOrder({
    super.key,
    required this.onMenuTap,
    required this.con,
    required this.urgentCount,
    required this.scheduledCount,
    required this.imagePath,
  });

  @override
  State<HeaderOrder> createState() => _HeaderOrderState();
}

class _HeaderOrderState extends State<HeaderOrder> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DriverStatusCubit>().fetchDriverAvailability();
      }
    });
  }

  String _ordersSummary(BuildContext context) {
    final text = AppTranslations.getText(context, "orders_summary");
    return text
        .replaceAll("{urgent}", widget.urgentCount.toString())
        .replaceAll("{scheduled}", widget.scheduledCount.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 40.h),
          Row(
            children: [
              SizedBox(width: 20.w),
              GestureDetector(
                onTap: widget.onMenuTap,
                child: SvgPicture.asset(
                  IconsAssets.menu,
                  color: AppColors.secondary2,
                ),
              ),
              SizedBox(width: 95.w),
              _profileAvatar(widget.imagePath),
              SizedBox(width: 80.w),
              _buildAvailabilitySwitch(),
            ],
          ),
          SizedBox(height: 20.h),
          if (widget.con)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
              decoration: BoxDecoration(
                color: AppColors.main1,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: CustomText(
                _ordersSummary(context),
                color: Colors.white,
                textAlign: TextAlign.right,
                type: AppTextType.bodyMedium,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvailabilitySwitch() {
    return BlocConsumer<DriverStatusCubit, DriverStatusState>(
      listener: (context, state) {
        if (state is DriverStatusFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        bool isAvailable = false;
        bool isLoading = false;

        if (state is DriverStatusLoaded) {
          isAvailable = state.isAvailable;
          isLoading = state.isUpdating;
        } else if (state is DriverStatusLoading) {
          isLoading = true;
        }

        return GestureDetector(
          onTap: isLoading
              ? null
              : () {
            context.read<DriverStatusCubit>().toggleDriverAvailability();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 50.w,
            height: 26.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: isAvailable
                  ? const Color(0xFF1595C7)
                  : Colors.grey.shade400,
            ),
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: isLoading
                ? Center(
              child: SizedBox(
                width: 14.w,
                height: 14.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            )
                : AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: isAvailable
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Container(
                width: 20.w,
                height: 20.h,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _profileAvatar(String? imagePath) {
    const String baseUrl = 'https://api.taxiwaar.com/';

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: CircleAvatar(
        radius: 35.r,
        backgroundColor: Colors.grey[200],
        child: ClipOval(
          child: (imagePath != null && imagePath.isNotEmpty)
              ? Image.network(
            imagePath.startsWith('http') ? imagePath : "$baseUrl$imagePath",
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
}