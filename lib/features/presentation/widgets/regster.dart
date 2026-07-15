import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_regster.dart/cubit_rejester.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/utils/validator.dart';
import 'package:drever_warr/core/widgets/custom_text_field_all.dart';
import 'package:drever_warr/core/widgets/custom_button.dart';
import 'package:drever_warr/core/widgets/custom_text.dart';
import 'package:drever_warr/core/widgets/logo_app.dart';

import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_governorates/cubit.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_governorates/cubit_state.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_verificationRepo/cubit.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_verificationRepo/cubite_state.dart';
import 'package:drever_warr/features/presentation/data/repo/model/model_governorates.dart';
import 'package:drever_warr/features/presentation/view/verification_code_regster.dart';
import 'package:drever_warr/features/presentation/widgets/login.dart';
import 'package:drever_warr/features/presentation/widgets/row_select_gender.dart';

import '../../../core/utils/normalize_number.dart';
import '../../../core/widgets/password_helper.dart';

class Regsterview extends StatefulWidget {
  final String? initialAddress;
  final double? lat;
  final double? lng;

  const Regsterview({super.key, this.initialAddress, this.lat, this.lng});

  @override
  State<Regsterview> createState() => _RegsterviewState();
}

class _RegsterviewState extends State<Regsterview> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController _governorateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emergencyController = TextEditingController();
  final TextEditingController _gmail = TextEditingController();
  final TextEditingController _addres = TextEditingController();

  final GlobalKey _govKey = GlobalKey();

  String? _selectedGovernorateId;
  String _selectedGender = "male";
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialAddress != null) {
      _addres.text = widget.initialAddress!;
    }
  }



  Future<void> _handleSubmit() async {
    if (_isSubmitting) return;

    final formState = _formKey.currentState;
    if (formState == null) return;

    FocusScope.of(context).unfocus();

    if (!formState.validate()) return;

    if (_selectedGovernorateId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى اختيار المحافظة")),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final formattedPhone = normalizePhone(phoneController.text);
    final formattedEmergency = normalizePhone(_emergencyController.text);

    context.read<RegisterCubit>().setUserData(
      addres: _addres.text.trim(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      mobilePhone: formattedPhone,
      governorateId: _selectedGovernorateId!,
      password: _passwordController.text,
      emergencyNumber: formattedEmergency,
      gender: _selectedGender,
      lat: widget.lat ?? 0.0,
      lng: widget.lng ?? 0.0,
    );

    context.read<VerificationCubit>().sendVerificationCode(
      mobilePhone: "963$formattedPhone",
      typeOfUse: "activate-account",
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<VerificationCubit, VerificationState>(
          listener: (context, state) {
            if (!mounted) return;

            if (state is CreateVerificationCodeSuccess) {
              final rawPhone = phoneController.text.trim();
              final formattedPhone =
              rawPhone.startsWith('0') ? rawPhone.substring(1) : rawPhone;

              setState(() {
                _isSubmitting = false;
              });

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      VerificationCodeRegster(phone: formattedPhone),
                ),
              );

            } else if (state is VerificationFailure) {
              setState(() {
                _isSubmitting = false;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.secondary1,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: AppSpacing.lg.h),
              const LogoSection(),
              CustomText(
                "Register",
                type: AppTextType.titleSmall,
                color: AppColors.main1,
              ),
              SizedBox(height: AppSpacing.md.h),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildLabel("first_name"),
                        AppCustomTextField(
                          controller: _firstNameController,
                          hintText: "",
                          validator: (val) =>
                              Validators.isEmptyValue(val, context),
                        ),

                        _buildLabel("last_name"),
                        AppCustomTextField(
                          controller: _lastNameController,
                          hintText: "",
                          validator: (val) =>
                              Validators.isEmptyValue(val, context),
                        ),

                        _buildLabel("phone_number"),
                        AppCustomTextField(
                          countryCode: "+963",
                          controller: phoneController,
                          hintText: "",
                          keyboardType: TextInputType.phone,
                          validator: (val) =>
                              Validators.validatePhone(val, context),
                        ),

                        _buildLabel("enter_email"),
                        AppCustomTextField(
                          controller: _gmail,
                          hintText: "",
                          validator: (val) =>
                              Validators.validateEmail(val, context),
                        ),

                        _buildLabel("select_governorate"),
                        _buildGovernoratePicker(),

                        _buildLabel("enter_address"),
                        AppCustomTextField(
                          controller: _addres,
                          hintText: "",
                          validator: (val) =>
                              Validators.isEmptyValue(val, context),
                        ),

                        _buildLabel("password"),
                        PasswordTextField(
                          hintText: "",
                          controller: _passwordController,
                          iconImage: IconAssets.eyeoff,
                          validator: (val) =>
                              Validators.validatePassword(val, context),
                        ),
                        _buildLabel("emergency_number"),
                        AppCustomTextField(
                          iconImage: IconAssets.emergemcy,
                          controller: _emergencyController,
                          hintText: "",
                          keyboardType: TextInputType.phone,
                          validator: (val) =>
                              Validators.validatePhone(val, context),
                        ),

                        SizedBox(height: AppSpacing.lg.h),
                        Selectgender(
                          onGenderSelected: (gender) {
                            setState(() {
                              _selectedGender = gender;
                            });
                          },
                        ),
                        SizedBox(height: AppSpacing.x30.h),

                        _buildLoginButton(context),

                        SizedBox(height: AppSpacing.lg.h),

                        BlocBuilder<VerificationCubit, VerificationState>(
                          builder: (context, state) {
                            final isLoading =
                                state is VerificationLoading || _isSubmitting;

                            return IgnorePointer(
                              ignoring: isLoading,
                              child: Opacity(
                                opacity: isLoading ? 0.75 : 1,
                                child: CustomButton(
                                  title: "next",
                                  onTap: _handleSubmit,
                                ),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGovernoratePicker() {
    return GestureDetector(
      onTap: () async {
        if (_isSubmitting) return;

        final cubit = context.read<GovernoratesCubit>();

        if (cubit.state is! GovernoratesSuccess) {
          await cubit.getGovernorates();
        }

        if (!mounted) return;
        if (cubit.state is! GovernoratesSuccess) return;

        final state = cubit.state as GovernoratesSuccess;

        final keyContext = _govKey.currentContext;
        if (keyContext == null || !keyContext.mounted) return;

        final renderObject = keyContext.findRenderObject();
        if (renderObject is! RenderBox) return;

        if (!mounted) return;
        final overlayObject = Overlay.of(context).context.findRenderObject();
        if (overlayObject is! RenderBox) return;
        final overlay = overlayObject;

        final Offset fieldOffset = renderObject.localToGlobal(
          Offset.zero,
          ancestor: overlay,
        );

        final bool isRtl = Directionality.of(context) == TextDirection.rtl;
        final double anchorWidth = 44.w;

        final double left = isRtl
            ? fieldOffset.dx + renderObject.size.width - anchorWidth
            : fieldOffset.dx;

        final double top = fieldOffset.dy + renderObject.size.height + 4.h;
        final double right = overlay.size.width - (left + anchorWidth);

        final selected = await showMenu<GovernorateModel>(
          context: context,
          position: RelativeRect.fromLTRB(left, top, right, 0),
          color: Colors.white,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          menuPadding: EdgeInsets.zero,
          constraints: BoxConstraints(
            minWidth: renderObject.size.width,
            maxHeight: 180.h,
          ),
          items: state.governorates.map((gov) {
            return PopupMenuItem<GovernorateModel>(
              value: gov,
              padding: EdgeInsets.zero,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
                child: Text(
                  gov.name,
                  textAlign: isRtl ? TextAlign.right : TextAlign.left,
                ),
              ),
            );
          }).toList(),
        );

        if (!mounted) return;
        if (selected != null) {
          setState(() {
            _governorateController.text = selected.name;
            _selectedGovernorateId = selected.id;
          });
        }
      },
      child: AbsorbPointer(
        child: AppCustomTextField(
          key: _govKey,
          iconImage: IconAssets.drowpdawn,
          controller: _governorateController,
          hintText: "",
          validator: (val) => Validators.isEmptyValue(val, context),
        ),
      ),
    );
  }
  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
      child: CustomText(text, type: AppTextType.titleSmall),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 45.w),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.main1),
          ),
          child: Center(
            child: CustomText(
              "login",
              type: AppTextType.titleMedium,
              color: TextColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

