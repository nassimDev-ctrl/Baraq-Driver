 
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_regster.dart/cubit_rejester.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

 
import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/utiles/faledtor.dart';
import 'package:drever_warr/core/widgets/coustm_text_fild_all.dart';
import 'package:drever_warr/core/widgets/customButton.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/core/widgets/logo_app.dart';

 
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_governorates/cubit.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_governorates/cubit_state.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_verificationRepo/cubit.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_verificationRepo/cubite_state.dart';
import 'package:drever_warr/features/preasntaion/data/repo/model/model_governorates.dart';
import 'package:drever_warr/features/preasntaion/view/verification_code_regster.dart';
import 'package:drever_warr/features/preasntaion/widhets/login.dart';
import 'package:drever_warr/features/preasntaion/widhets/row_select_gender.dart';

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

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController _governorateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emergencyController = TextEditingController();
  final TextEditingController _gmail = TextEditingController();
  final TextEditingController _addres = TextEditingController();

  final GlobalKey _govKey = GlobalKey();
  String? _selectedGovernorateId;
  String _selectedGender = "male";

  @override
  void initState() {
    super.initState();
    
    if (widget.initialAddress != null) {
      _addres.text = widget.initialAddress!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    phoneController.dispose();
    _governorateController.dispose();
    _passwordController.dispose();
    _emergencyController.dispose();
    _gmail.dispose();
    _addres.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<VerificationCubit, VerificationState>(
          listener: (context, state) {
            if (state is CreateVerificationCodeSuccess) {
              String rawPhone = phoneController.text.trim();
              String formattedPhone = rawPhone.startsWith('0')
                  ? rawPhone.substring(1)
                  : rawPhone;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      VerificationCodeRegster(phone: formattedPhone),
                ),
              );
              
              _nameController.clear();
              phoneController.clear();
              _governorateController.clear();
              _passwordController.clear();
              _emergencyController.clear();
              _gmail.clear();
              _addres.clear();
              _selectedGovernorateId = null;
            } else if (state is VerificationFailure) {
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
                        _buildLabel("full_name"),
                        AppCustomTextField(
                          controller: _nameController,
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

                        _buildLabel("gmail"),
                        AppCustomTextField(
                          controller: _gmail,
                          hintText: "",
                          validator: (val) =>
                              Validators.isEmptyValue(val, context),
                        ),

                        _buildLabel("select_governorate"),
                        _buildGovernoratePicker(context),

                        _buildLabel("addres"),
                        AppCustomTextField(
                          controller: _addres,
                          hintText: "",
                          validator: (val) =>
                              Validators.isEmptyValue(val, context),
                        ),

                        _buildLabel("password"),
                        AppCustomTextField(
                          iconImage: IconsAssets.eyeoff,
                          controller: _passwordController,
                          hintText: "",
                          isPassword: true,
                          validator: (val) =>
                              Validators.validatePassword(val, context),
                        ),

                        _buildLabel("emergency_number"),
                        AppCustomTextField(
                          iconImage: IconsAssets.emergemcy,
                          controller: _emergencyController,
                          hintText: "",
                          keyboardType: TextInputType.phone,
                          validator: (val) =>
                              Validators.validatePhone(val, context),
                        ),

                        SizedBox(height: AppSpacing.lg.h),
                        Selectgender(
                          onGenderSelected: (gender) {
                            _selectedGender = gender;
                          },
                        ),
                        SizedBox(height: AppSpacing.x30.h),

                        _buildLoginButton(context),

                        SizedBox(height: AppSpacing.lg.h),

                        BlocBuilder<VerificationCubit, VerificationState>(
                          builder: (context, state) {
                            if (state is VerificationLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return CustomButton(
                              title: "next",
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  if (_selectedGovernorateId == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("يرجى اختيار المحافظة"),
                                      ),
                                    );
                                    return;
                                  }

                               
                                  String rawPhone = phoneController.text.trim();
                                  String formattedPhone =
                                      rawPhone.startsWith('0')
                                      ? rawPhone.substring(1)
                                      : rawPhone;

                                  String emrgecy = _emergencyController.text
                                      .trim();
                                  String formattedemergcy =
                                      emrgecy.startsWith('0')
                                      ? emrgecy.substring(1)
                                      : emrgecy;

                                  
                                  context.read<RegisterCubit>().setUserData(
                                    addres: _addres.text,
                                    firstName: _nameController.text,
                                    lastName: "jjjjj", 
                                    mobilePhone: formattedPhone,
                                    governorateId: _selectedGovernorateId!,
                                    password: _passwordController.text,
                                    emergencyNumber: formattedemergcy,
                                    gender: _selectedGender,

                                    lat:
                                        widget.lat ??
                                        0.0,  
                                    lng: widget.lng ?? 0.0,
                                  );

                                  // إرسال كود التحقق
                                  context
                                      .read<VerificationCubit>()
                                      .sendVerificationCode(
                                        mobilePhone: "963$formattedPhone",
                                        typeOfUse: "activate-account",
                                      );
                                }
                              },
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

  Widget _buildGovernoratePicker(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final cubit = context.read<GovernoratesCubit>();

        if (cubit.state is! GovernoratesSuccess) {
          await cubit.getGovernorates();
        }

        if (cubit.state is GovernoratesSuccess) {
          final state = cubit.state as GovernoratesSuccess;

          final RenderBox button =
              _govKey.currentContext!.findRenderObject() as RenderBox;

          final RenderBox overlay =
              Overlay.of(context).context.findRenderObject() as RenderBox;

          final Offset position = button.localToGlobal(
            Offset.zero,
            ancestor: overlay,
          );

          final selected = await showMenu<GovernorateModel>(
            context: context,
            position: RelativeRect.fromLTRB(
              position.dx,
              position.dy + button.size.height,
              position.dx + button.size.width,
              0,
            ),
            constraints: const BoxConstraints(maxHeight: 180),
            items: state.governorates.map((gov) {
              return PopupMenuItem<GovernorateModel>(
                value: gov,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(gov.name),
                ),
              );
            }).toList(),
          );

          if (selected != null) {
            setState(() {
              _governorateController.text = selected.name;
              _selectedGovernorateId = selected.id;
            });
          }
        }
      },
      child: AbsorbPointer(
        child: AppCustomTextField(
          key: _govKey,
          iconImage: IconsAssets.drowpdawn,
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
