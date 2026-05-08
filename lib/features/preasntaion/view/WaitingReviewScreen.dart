import 'dart:async';

import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/features/home/preasntaion/view/home_view.dart';
import 'package:drever_warr/features/preasntaion/view/CarRegistrationScreen.dart';
import 'package:drever_warr/features/preasntaion/view/Personal_identity.dart';
import 'package:drever_warr/features/preasntaion/view/registerPhotoScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/cash/preferences_servis.dart';
import '../../setting/data/cubit/cubit_profail/cubit.dart';
import '../../setting/data/cubit/cubit_profail/cubit_stat.dart';


class WaitingReviewScreen extends StatefulWidget {
  const WaitingReviewScreen({super.key});

  @override
  State<WaitingReviewScreen> createState() => _WaitingReviewScreenState();
}

class _WaitingReviewScreenState extends State<WaitingReviewScreen> {
  Timer? _timer;
  String status = "waiting";
  String? fieldToUpdate;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _saveStatus();
    _fetchProfile();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      _fetchProfile();
    });
  }

  void _fetchProfile() {
    context.read<ProfileCubit>().getProfileData();
  }

  Future<void> _saveStatus() async {
    await CacheManager.saveData("status", status);
  }

  Future<void> _handleProfileSuccess(ProfileSuccess state) async {
    final newStatus = state.data.data?.status ?? "waiting";
    await CacheManager.saveData("status", newStatus);
    final newFieldToUpdate = state.data.data?.fieldToUpdate;
    final stageToUpdate = state.data.data?.registrationStep;
    final message = state.data.message;

    status = newStatus;
    fieldToUpdate = newFieldToUpdate;

    if (_navigated) return;

    if (newStatus == "active" || newStatus == "change-category") {
      _navigated = true;
      _timer?.cancel();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeView()),
      );
      return;
    }

    if (newStatus == "rejected") {
      final page = _getUpdatePage(newFieldToUpdate, stageToUpdate.toString(), message);
      if (page != null) {
        _navigated = true;
        _timer?.cancel();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => page),
        );
      }
    }
  }

  Widget? _getUpdatePage(String? field, String? stage, String? message) {
    switch (stage){
      case "1":
        return RegisterPhotoScreen(
          isUpdate: true,
          imageError: message,
        );
      case "2":
        switch (field) {
          case "personalCardImageFront":
            return Personalidentity(
              isUpdate: true,
              frontImageError: message,
            );
          case "personalCardImageBack":
            return Personalidentity(
              isUpdate: true,
              backImageError: message,
            );

          default:
            return Personalidentity(
              isUpdate: true,
            );
        }
      case "3":
        switch (field) {
          case "carType":
            return CarRegistrationScreen(
              isUpdate: true,
              carTypeError: message,
            );

          case "carImage":
            return CarRegistrationScreen(
              isUpdate: true,
              carImageError: message,
            );
          case "carPlateNumber":
            return CarRegistrationScreen(
              isUpdate: true,
              carPlateNumberError: message,
            );
          case "carModel":
            return CarRegistrationScreen(
              isUpdate: true,
              carModelError: message,
            );
          case "carCategory":
            return CarRegistrationScreen(
              isUpdate: true,
              carCategoryError: message,
            );
          case "carColor":
            return CarRegistrationScreen(
              isUpdate: true,
              carColorError: message,
            );

          default:
            return CarRegistrationScreen(
              isUpdate: true,
            );
        }
      default:
        return null;
    }

  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSuccess) {
          _handleProfileSuccess(state);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 50.h),
              Center(
                child: Image.asset(
                  ImageAssets.logo_warr,
                  height: 150.h,
                  width: 150.w,
                ),
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: 40.h,
                    horizontal: 20.w,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: AppColors.main1,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.main1.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        "request_sent_waiting",
                        type: AppTextType.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}