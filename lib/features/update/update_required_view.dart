import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateRequiredView extends StatefulWidget {
  const UpdateRequiredView({super.key});

  @override
  State<UpdateRequiredView> createState() => _UpdateRequiredViewState();
}

class _UpdateRequiredViewState extends State<UpdateRequiredView> {
  String? _newVersion;
  String? _googlePlayLink;
  String? _appStoreLink;
  String? _downloadLink;
  bool _loading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchVersionInfo();
  }

  Future<void> _fetchVersionInfo() async {
    try {
      final platform = Platform.isIOS ? 'ios' : 'andriod';
      final response = await Dio().get(
        'https://api.taxiwaar.com/versions/$platform/driver',
      );

      if (response.statusCode == 200 && mounted) {
        final version = response.data['version'];
        setState(() {
          _newVersion = version['version'];
          _googlePlayLink = version['googlePlayLink'];
          _appStoreLink = version['appStoreLink'];
          _downloadLink = version['downloadLink'];
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _hasError = true;
        });
      }
    }
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      try {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } catch (e) {
        debugPrint('Could not launch $url: $e');
      }
    }
  }

  String? get _storeLink =>
      Platform.isIOS ? _appStoreLink : _googlePlayLink;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final hasStoreLink = _storeLink != null && _storeLink!.isNotEmpty;
    final hasDirectLink = _downloadLink != null && _downloadLink!.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        children: [
          const Spacer(flex: 2),

          Image.asset(
            ImageAssets.logoWarr,
            width: 160.w,
            height: 160.w,
            fit: BoxFit.contain,
          ),

          SizedBox(height: 32.h),

          Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF9C46D1).withValues(alpha: 0.1),
            ),
            child: Icon(
              Icons.system_update_rounded,
              size: 38.sp,
              color: const Color(0xFF9C46D1),
            ),
          ),

          SizedBox(height: 24.h),

          Text(
            AppTranslations.getText(context, "update_required_title"),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          SizedBox(height: 12.h),

          if (_newVersion != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFF9C46D1).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                '${AppTranslations.getText(context, "update_new_version")}: $_newVersion',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF9C46D1),
                ),
              ),
            ),

          SizedBox(height: 16.h),

          Text(
            AppTranslations.getText(context, "update_required_message"),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              height: 1.6,
              color: Colors.black54,
            ),
          ),

          const Spacer(flex: 2),

          if (_hasError && !hasStoreLink && !hasDirectLink)
            Text(
              AppTranslations.getText(context, "update_no_link"),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.red,
              ),
            ),

          if (hasStoreLink)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _launch(_storeLink!),
                icon: Icon(
                  Platform.isIOS ? Icons.apple : Icons.shop,
                  size: 22.sp,
                ),
                label: Text(
                  AppTranslations.getText(
                    context,
                    Platform.isIOS
                        ? "update_from_appstore"
                        : "update_from_playstore",
                  ),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9C46D1),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  elevation: 0,
                ),
              ),
            ),

          if (hasDirectLink) ...[
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _launch(_downloadLink!),
                icon: Icon(Icons.download_rounded, size: 22.sp),
                label: Text(
                  AppTranslations.getText(context, "update_direct_download"),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF9C46D1),
                  side: const BorderSide(
                    color: Color(0xFF9C46D1),
                    width: 1.5,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
              ),
            ),
          ],

          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
