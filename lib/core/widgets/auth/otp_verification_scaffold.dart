import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/app_snack_bar.dart';
import 'package:drever_warr/core/widgets/auth/app_primary_button.dart';
import 'package:drever_warr/core/widgets/auth/auth_gradient_header.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// Shared OTP verification layout used across register / forget-password / settings.
class OtpVerificationScaffold extends StatefulWidget {
  const OtpVerificationScaffold({
    super.key,
    required this.phone,
    required this.isLoading,
    required this.onVerify,
    required this.onResend,
    this.verifyLabelKey = 'verify_button',
    this.length = 4,
  });

  final String phone;
  final bool isLoading;
  final ValueChanged<String> onVerify;
  final VoidCallback onResend;
  final String verifyLabelKey;
  final int length;

  @override
  State<OtpVerificationScaffold> createState() =>
      _OtpVerificationScaffoldState();
}

class _OtpVerificationScaffoldState extends State<OtpVerificationScaffold> {
  final TextEditingController _pinController = TextEditingController();
  String _otpCode = '';
  int _resendSeconds = 0;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  String get _displayPhone {
    final raw = widget.phone.trim();
    if (raw.startsWith('963') && raw.length > 3) {
      return '+963 ${raw.substring(3)}';
    }
    if (raw.startsWith('+')) return raw;
    return raw.startsWith('0') ? raw : '+963 $raw';
  }

  void _startResendCooldown() {
    setState(() => _resendSeconds = 60);
    Future.doWhile(() async {
      await Future<void>.delayed(const Duration(seconds: 1));
      if (!mounted || _resendSeconds <= 0) return false;
      setState(() => _resendSeconds -= 1);
      return _resendSeconds > 0;
    });
  }

  void _handleResend() {
    if (_resendSeconds > 0 || widget.isLoading) return;
    widget.onResend();
    _startResendCooldown();
  }

  void _handleVerify() {
    FocusScope.of(context).unfocus();
    if (_otpCode.length != widget.length) {
      AppSnackBar.info(
        context,
        AppTranslations.getText(context, 'enter_code_instruction'),
      );
      return;
    }
    widget.onVerify(_otpCode);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.only(bottom: bottomInset + AppSpacing.lg.h),
            child: Column(
              children: [
                _OtpHeader(onBack: () => Navigator.maybePop(context)),
                Transform.translate(
                  offset: Offset(0, -AuthUiConstants.cardOverlap.h),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
                    child: _OtpCard(
                      phoneDisplay: _displayPhone,
                      pinController: _pinController,
                      length: widget.length,
                      isLoading: widget.isLoading,
                      resendSeconds: _resendSeconds,
                      verifyLabelKey: widget.verifyLabelKey,
                      onChanged: (value) => setState(() => _otpCode = value),
                      onCompleted: (value) {
                        setState(() => _otpCode = value);
                        _handleVerify();
                      },
                      onResend: _handleResend,
                      onVerify: _handleVerify,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OtpHeader extends StatelessWidget {
  const _OtpHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return AuthGradientHeader(
      height: 200,
      mapOpacity: 0.12,
      overlayTopAlpha: 0.03,
      overlayBottomAlpha: 0.2,
      child: Stack(
        children: [
          PositionedDirectional(
            top: AppSpacing.md.h,
            start: AppSpacing.md.w,
            child: Material(
              color: Colors.white.withValues(alpha: 0.16),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onBack,
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
          Positioned(
            left: AppSpacing.xlg.w,
            right: AppSpacing.xlg.w,
            bottom: (AuthUiConstants.cardOverlap + 24).h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56.r,
                  height: 56.r,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.22),
                    ),
                  ),
                  child: Icon(
                    Icons.sms_outlined,
                    color: Colors.white,
                    size: 28.sp,
                  ),
                ),
                SizedBox(height: AppSpacing.sm.h),
                Text(
                  AppTranslations.getText(context, 'verification_title'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  AppTranslations.getText(context, 'verify_identity'),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
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

class _OtpCard extends StatelessWidget {
  const _OtpCard({
    required this.phoneDisplay,
    required this.pinController,
    required this.length,
    required this.isLoading,
    required this.resendSeconds,
    required this.verifyLabelKey,
    required this.onChanged,
    required this.onCompleted,
    required this.onResend,
    required this.onVerify,
  });

  final String phoneDisplay;
  final TextEditingController pinController;
  final int length;
  final bool isLoading;
  final int resendSeconds;
  final String verifyLabelKey;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onCompleted;
  final VoidCallback onResend;
  final VoidCallback onVerify;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      color: Colors.white,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AuthUiConstants.cardTopRadius.r),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg.w,
          AppSpacing.xlg.h,
          AppSpacing.lg.w,
          AppSpacing.xlg.h,
        ),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isLoading ? 0.72 : 1,
          child: IgnorePointer(
            ignoring: isLoading,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppTranslations.getText(context, 'verification_code_sent'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AuthUiConstants.mutedText,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: AppSpacing.md.h),
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.main1.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: AppColors.main1.withValues(alpha: 0.14),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.phone_iphone_rounded,
                          size: 18.sp,
                          color: AppColors.main1,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          phoneDisplay,
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w800,
                            color: AuthUiConstants.textPrimary,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.sm.h),
                Text(
                  AppTranslations.getText(context, 'enter_code_instruction'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AuthUiConstants.hintColor,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: AppSpacing.xlg.h),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: PinCodeTextField(
                    appContext: context,
                    length: length,
                    controller: pinController,
                    keyboardType: TextInputType.number,
                    animationType: AnimationType.scale,
                    autoFocus: true,
                    cursorColor: AppColors.main1,
                    enableActiveFill: true,
                    useHapticFeedback: true,
                    hapticFeedbackTypes: HapticFeedbackTypes.light,
                    animationDuration: const Duration(milliseconds: 220),
                    textStyle: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                      color: AuthUiConstants.textPrimary,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(16.r),
                      fieldHeight: 62.h,
                      fieldWidth: 62.w,
                      borderWidth: 1.4,
                      activeFillColor: Colors.white,
                      selectedFillColor: Colors.white,
                      inactiveFillColor: AuthUiConstants.fieldFill,
                      activeColor: AppColors.main1,
                      selectedColor: AppColors.main1,
                      inactiveColor: AuthUiConstants.fieldBorder,
                      errorBorderColor: Colors.red,
                    ),
                    backgroundColor: Colors.transparent,
                    onChanged: onChanged,
                    onCompleted: onCompleted,
                    beforeTextPaste: (text) => true,
                  ),
                ),
                SizedBox(height: AppSpacing.md.h),
                _ResendRow(
                  seconds: resendSeconds,
                  onResend: onResend,
                ),
                SizedBox(height: AppSpacing.xlg.h),
                AppPrimaryButton(
                  isLoading: isLoading,
                  onPressed: onVerify,
                  labelKey: verifyLabelKey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResendRow extends StatelessWidget {
  const _ResendRow({
    required this.seconds,
    required this.onResend,
  });

  final int seconds;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final canResend = seconds <= 0;

    return Center(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        spacing: 4.w,
        children: [
          Text(
            AppTranslations.getText(context, 'code_not_sent_question'),
            style: TextStyle(
              fontSize: 13.sp,
              color: AuthUiConstants.mutedText,
              fontWeight: FontWeight.w500,
            ),
          ),
          GestureDetector(
            onTap: canResend ? onResend : null,
            child: Text(
              canResend
                  ? AppTranslations.getText(context, 'resend_code')
                  : '0:${seconds.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: canResend
                    ? AppColors.main1
                    : AuthUiConstants.hintColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
