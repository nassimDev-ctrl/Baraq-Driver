import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/view/my_profail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../data/cubit/driver_available_cubit/cubit.dart';
import '../data/cubit/driver_available_cubit/cubit_state.dart';
import '../view/notification_screen.dart';

class HeaderHomeView extends StatefulWidget {
  final VoidCallback onMenuTap;
  final String? imagePath;
  final num driverBalance;
  final bool isProfileLoading;

  const HeaderHomeView({
    super.key,
    required this.driverBalance,
    required this.onMenuTap,
    this.imagePath,
    this.isProfileLoading = false,
  });

  @override
  State<HeaderHomeView> createState() => _HeaderHomeViewState();
}

class _HeaderHomeViewState extends State<HeaderHomeView> {
  bool _imageLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<DriverStatusCubit>().fetchDriverAvailability();
    });
  }

  String? _resolveImageUrl(String? imagePath) {
    const String baseUrl = 'https://api.taxiwaar.com/';

    if (imagePath == null || imagePath.isEmpty) return null;
    if (imagePath.startsWith('http')) return imagePath;

    return "$baseUrl$imagePath";
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _resolveImageUrl(widget.imagePath);

    return Container(
      padding: EdgeInsets.only(
        top: 40.h,
        bottom: 20.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.main1,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: AppSpacing.x25.h),
          Row(
            children: [
              SizedBox(width: 20.w),
              GestureDetector(
                onTap: widget.onMenuTap,
                child: SvgPicture.asset(
                  IconsAssets.menu,
                  color: AppColors.secondary1,
                ),
              ),
              const Spacer(),
              SizedBox(width: 20.w),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DriverProfail(),
                    ),
                  );
                },
                child: _profileAvatar(imageUrl),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationScreen(),
                    ),
                  );
                },
                child: Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 26.sp,
                ),
              ),
              SizedBox(width: 12.w),
              _buildAvailabilitySwitch(),
              SizedBox(width: 20.w),
            ],
          ),
          SizedBox(height: 15.h),
          CustomText(
            "current_balance",
            color: Colors.white70,
            type: AppTextType.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5.h),
          CustomText(
            "${widget.driverBalance.toStringAsFixed(2)} SYP",
            color: Colors.white,
            type: AppTextType.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilitySwitch() {
    return BlocConsumer<DriverStatusCubit, DriverStatusState>(
      listener: (context, state) {
        if (state is DriverStatusFailure) {
        }
      },
      builder: (context, state) {
        final bool isAvailable = switch (state) {
          DriverStatusLoaded(:final isAvailable) => isAvailable,
          _ => false,
        };

        final bool isLoading = switch (state) {
          DriverStatusLoading() => true,
          DriverStatusLoaded(:final isUpdating) => isUpdating,
          _ => false,
        };

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

    final String? resolvedUrl = (imagePath == null || imagePath.isEmpty)
        ? null
        : imagePath.startsWith('http')
        ? imagePath
        : "$baseUrl$imagePath";

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: CircleAvatar(
        radius: 35.r,
        backgroundColor: Colors.grey[200],
        child: ClipOval(
          child: SizedBox(
            width: 70.r,
            height: 70.r,
            child: widget.isProfileLoading
                ? Center(
              child: SizedBox(
                width: 18.w,
                height: 18.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.main1,
                ),
              ),
            )
                : (resolvedUrl != null)
                ? Image.network(
              resolvedUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: SizedBox(
                    width: 18.w,
                    height: 18.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.main1,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  ImageAssets.imageprofail,
                  fit: BoxFit.cover,
                );
              },
            )
                : Image.asset(
              ImageAssets.imageprofail,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

