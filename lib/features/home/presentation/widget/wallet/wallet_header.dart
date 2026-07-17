import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/widgets/auth/auth_gradient_header.dart';
import 'package:drever_warr/features/home/presentation/widget/wallet/wallet_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WalletHeader extends StatelessWidget {
  const WalletHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthGradientHeader(
      height: WalletUiConstants.headerHeight,
      backgroundImage: ImageAssets.driverCar,
      backgroundFit: BoxFit.contain,
      backgroundAlignment: Alignment.centerLeft,
      mapOpacity: 0.55,
      overlayTopAlpha: 0.08,
      overlayBottomAlpha: 0.35,
      child: SafeArea(
        bottom: false,
        child: Align(
          alignment: AlignmentDirectional.topStart,
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              start: AppSpacing.md.w,
              top: AppSpacing.md.h,
            ),
            child: Material(
              color: Colors.white.withValues(alpha: 0.16),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => Navigator.maybePop(context),
                child: SizedBox(
                  width: 42.r,
                  height: 42.r,
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
