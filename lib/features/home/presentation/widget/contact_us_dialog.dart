import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/service/contact_support_service.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/app_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showContactUsDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) => const ContactUsDialog(),
  );
}

class ContactUsDialog extends StatelessWidget {
  const ContactUsDialog({super.key});

  Future<void> _copyPhone(BuildContext context) async {
    await Clipboard.setData(
      ClipboardData(text: ContactSupportService.supportPhone),
    );
    HapticFeedback.lightImpact();
    if (!context.mounted) return;
    AppSnackBar.info(
      context,
      AppTranslations.getStaticText(context, 'contact_us_copied'),
    );
  }

  Future<void> _openWhatsApp(BuildContext context) async {
    final opened = await ContactSupportService.openWhatsApp();
    if (!context.mounted) return;
    if (opened) {
      Navigator.pop(context);
      return;
    }
    AppSnackBar.info(
      context,
      AppTranslations.getStaticText(context, 'contact_us_unavailable'),
    );
  }

  Future<void> _openPhoneCall(BuildContext context) async {
    final opened = await ContactSupportService.openPhoneCall();
    if (!context.mounted) return;
    if (opened) {
      Navigator.pop(context);
      return;
    }
    AppSnackBar.info(
      context,
      AppTranslations.getStaticText(context, 'contact_us_unavailable'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: BoxDecoration(
                    color: AppColors.main1.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.support_agent_rounded,
                    color: AppColors.main1,
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppTranslations.getText(context, 'contact_us_title'),
                        style: TextStyle(
                          color: const Color(0xFF112442),
                          fontWeight: FontWeight.w900,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        AppTranslations.getText(
                          context,
                          'contact_us_subtitle',
                        ),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close_rounded,
                    color: Colors.grey.shade500,
                    size: 22.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8FC),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _SupportPhoneText(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF112442),
                        fontWeight: FontWeight.w900,
                        fontSize: 15.sp,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _copyPhone(context),
                    tooltip: AppTranslations.getText(
                      context,
                      'contact_us_copied',
                    ),
                    icon: Icon(
                      Icons.copy_rounded,
                      color: AppColors.main1,
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            _ContactOptionTile(
              titleKey: 'contact_us_whatsapp',
              icon: Icons.chat_rounded,
              color: const Color(0xFF25D366),
              onTap: () => _openWhatsApp(context),
            ),
            SizedBox(height: 10.h),
            _ContactOptionTile(
              titleKey: 'contact_us_call',
              icon: Icons.phone_in_talk_rounded,
              color: const Color(0xFF56B72A),
              onTap: () => _openPhoneCall(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactOptionTile extends StatelessWidget {
  const _ContactOptionTile({
    required this.titleKey,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String titleKey;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF7F8FC),
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: const Color(0xFFE7EBF2)),
          ),
          child: Row(
            children: [
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: color, size: 22.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppTranslations.getText(context, titleKey),
                      style: TextStyle(
                        color: const Color(0xFF112442),
                        fontWeight: FontWeight.w800,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    _SupportPhoneText(
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                        fontSize: 11.5.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_left_rounded,
                color: Colors.grey.shade500,
                size: 22.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SupportPhoneText extends StatelessWidget {
  const _SupportPhoneText({required this.style, this.textAlign});

  final TextStyle style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Text(
        ContactSupportService.supportPhone,
        textAlign: textAlign ?? TextAlign.start,
        style: style,
      ),
    );
  }
}
