import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/di/app_providers.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/utils/navigator_key.dart';
import 'package:drever_warr/features/home/presentation/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Authenticated shell: home-session cubits + nested [Navigator] so pushed
/// routes (wallet, orders, settings, …) still inherit those providers.
///
/// System back is handled here so it pops the nested stack first instead of
/// exiting the root route (which would leave the app).
class HomeSession extends StatefulWidget {
  const HomeSession({super.key});

  @override
  State<HomeSession> createState() => _HomeSessionState();
}

class _HomeSessionState extends State<HomeSession> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  Future<bool> _confirmExit() async {
    final dialogContext = _navigatorKey.currentContext ?? context;
    final result = await showDialog<bool>(
      context: dialogContext,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22.r),
              border: Border.all(
                color: AppColors.main1.withValues(alpha: 0.45),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  offset: const Offset(0, 10),
                  blurRadius: 18,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withValues(alpha: 0.08),
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    size: 30.sp,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  AppTranslations.getText(context, 'exit_confirm_title'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  AppTranslations.getText(context, 'exit_confirm_message'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5.sp,
                    height: 1.4,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 22.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: AppColors.main1,
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 13.h),
                        ),
                        child: Text(
                          AppTranslations.getText(context, 'stay'),
                          style: TextStyle(
                            color: AppColors.main1,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.main1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 13.h),
                          elevation: 0,
                        ),
                        child: Text(
                          AppTranslations.getText(context, 'exit_app'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    return result ?? false;
  }

  Future<void> _onSystemBack() async {
    final nav = _navigatorKey.currentState;
    if (nav == null) return;

    // Nested page or open drawer → go back / close drawer.
    if (nav.canPop()) {
      nav.pop();
      return;
    }

    // On Home screen → ask the driver before exiting.
    final shouldExit = await _confirmExit();
    if (shouldExit && mounted) {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: homeSessionProviders,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          await _onSystemBack();
        },
        child: Navigator(
          key: _navigatorKey,
          observers: [appRouteObserver],
          onGenerateInitialRoutes: (navigator, initialRoute) {
            return [
              MaterialPageRoute<void>(
                builder: (_) => const HomeView(),
              ),
            ];
          },
        ),
      ),
    );
  }
}
