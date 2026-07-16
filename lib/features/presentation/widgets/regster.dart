import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/utils/normalize_number.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_governorates/cubit.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_regster.dart/cubit_rejester.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_verificationRepo/cubit.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_verificationRepo/cubite_state.dart';
import 'package:drever_warr/features/presentation/view/verification_code_regster.dart';
import 'package:drever_warr/features/presentation/widgets/login.dart';
import 'package:drever_warr/features/presentation/widgets/register/governorates_picker_sheet.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/presentation/widgets/register/register_form.dart';
import 'package:drever_warr/features/presentation/widgets/register/register_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:drever_warr/core/widgets/app_snack_bar.dart';

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
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _governorateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emergencyController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _emergencyFocus = FocusNode();

  String? _selectedGovernorateId;
  String _selectedGender = 'male';
  bool _isSubmitting = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    if (widget.initialAddress != null) {
      _addressController.text = widget.initialAddress!;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _governorateController.dispose();
    _passwordController.dispose();
    _emergencyController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();
    _addressFocus.dispose();
    _passwordFocus.dispose();
    _emergencyFocus.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_isSubmitting) return;

    final formState = _formKey.currentState;
    if (formState == null) return;

    FocusScope.of(context).unfocus();
    if (!formState.validate()) return;

    if (_selectedGovernorateId == null) {
      AppSnackBar.error(
        context,
        AppTranslations.getText(context, 'please_select_governorate'),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final formattedPhone = normalizePhone(_phoneController.text);
    final formattedEmergency = normalizePhone(_emergencyController.text);

    context.read<RegisterCubit>().setUserData(
      addres: _addressController.text.trim(),
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
      mobilePhone: '963$formattedPhone',
      typeOfUse: 'activate-account',
    );
  }

  void _openGovernoratesSheet() {
    FocusScope.of(context).unfocus();
    context.read<GovernoratesCubit>().getGovernorates();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => GovernoratesPickerSheet(
        selectedName: _governorateController.text,
        onSelected: (gov) {
          setState(() {
            _governorateController.text = gov.name;
            _selectedGovernorateId = gov.id;
          });
        },
      ),
    );
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return MultiBlocListener(
      listeners: [
        BlocListener<VerificationCubit, VerificationState>(
          listener: (context, state) {
            if (!mounted) return;

            if (state is CreateVerificationCodeSuccess) {
              final rawPhone = _phoneController.text.trim();
              final formattedPhone =
                  rawPhone.startsWith('0') ? rawPhone.substring(1) : rawPhone;

              setState(() => _isSubmitting = false);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VerificationCodeRegster(phone: formattedPhone),
                ),
              );
            } else if (state is VerificationFailure) {
              setState(() => _isSubmitting = false);
              AppSnackBar.error(context, state.errMessage);
            }
          },
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.translucent,
          child: SafeArea(
            bottom: false,
            child: BlocBuilder<VerificationCubit, VerificationState>(
              builder: (context, state) {
                final isLoading =
                    state is VerificationLoading || _isSubmitting;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.only(
                    bottom: bottomInset + AppSpacing.lg.h,
                  ),
                  child: Column(
                    children: [
                      const RegisterHeader(),
                      Transform.translate(
                        offset: Offset(0, -AuthUiConstants.cardOverlap.h),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.md.w,
                          ),
                          child: RegisterForm(
                            formKey: _formKey,
                            firstNameController: _firstNameController,
                            lastNameController: _lastNameController,
                            phoneController: _phoneController,
                            emailController: _emailController,
                            governorateController: _governorateController,
                            addressController: _addressController,
                            passwordController: _passwordController,
                            emergencyController: _emergencyController,
                            firstNameFocus: _firstNameFocus,
                            lastNameFocus: _lastNameFocus,
                            phoneFocus: _phoneFocus,
                            emailFocus: _emailFocus,
                            addressFocus: _addressFocus,
                            passwordFocus: _passwordFocus,
                            emergencyFocus: _emergencyFocus,
                            obscurePassword: _obscurePassword,
                            selectedGender: _selectedGender,
                            isLoading: isLoading,
                            onTogglePassword: () {
                              setState(
                                () => _obscurePassword = !_obscurePassword,
                              );
                            },
                            onGenderSelected: (gender) {
                              setState(() => _selectedGender = gender);
                            },
                            onGovernorateTap: _openGovernoratesSheet,
                            onSubmit: _handleSubmit,
                            onLoginTap: _goToLogin,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
