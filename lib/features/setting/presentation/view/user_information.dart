import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/utils/validator.dart';
import 'package:drever_warr/core/widgets/app_snack_bar.dart';
import 'package:drever_warr/core/widgets/auth/app_text_field.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_category/cubit.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_category/cubit_stat.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_governorates/cubit.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_governorates/cubit_state.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_verificationRepo/cubit.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_verificationRepo/cubite_state.dart';
import 'package:drever_warr/features/presentation/data/repo/model/model_governorates.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_profail/cubit.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_profail/cubit_stat.dart';
import 'package:drever_warr/features/setting/data/cubit/updet_profail/cubit.dart';
import 'package:drever_warr/features/setting/data/cubit/updet_profail/cubit_stat.dart';
import 'package:drever_warr/features/setting/presentation/view/password_for_edet_phone.dart';
import 'package:drever_warr/features/setting/presentation/view/verfication_code_change_password.dart';
import 'package:drever_warr/features/setting/presentation/widget/personal_info/personal_info_avatar.dart';
import 'package:drever_warr/features/setting/presentation/widget/personal_info/personal_info_header.dart';
import 'package:drever_warr/features/setting/presentation/widget/personal_info/personal_info_section.dart';
import 'package:drever_warr/features/setting/presentation/widget/personal_info/personal_info_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class UserInformation extends StatefulWidget {
  const UserInformation({super.key});

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController _governorateController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  final GlobalKey _categoryKey = GlobalKey();
  final GlobalKey _governorateKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _selectedGovernorateId;
  String? _selectedCategoryId;
  String? _pickedImagePath;

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getProfileData();
    context.read<CarCategoryCubit>().getCarCategories();
  }

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    _governorateController.dispose();
    passwordController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _syncCategoryControllerFromLoadedCategories() {
    final state = context.read<CarCategoryCubit>().state;
    if (state is! CarCategorySuccess) return;

    if (_selectedCategoryId == null || _selectedCategoryId!.isEmpty) {
      _categoryController.clear();
      return;
    }

    for (final category in state.categories) {
      final id = category.id?.toString();
      if (id == _selectedCategoryId) {
        _categoryController.text = category.name ?? '';
        return;
      }
    }

    _categoryController.clear();
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _pickedImagePath = image.path);
    }
  }

  Future<void> _pickCategory() async {
    final cubit = context.read<CarCategoryCubit>();
    var state = cubit.state;

    if (state is! CarCategorySuccess) {
      await cubit.getCarCategories();
      if (!mounted) return;
      state = cubit.state;
    }
    if (state is! CarCategorySuccess) return;
    final categoryState = state;

    final button =
        _categoryKey.currentContext!.findRenderObject() as RenderBox;
    if (!mounted) return;
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final position = button.localToGlobal(Offset.zero, ancestor: overlay);

    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + button.size.height,
        position.dx + button.size.width,
        0,
      ),
      constraints: BoxConstraints(
        maxHeight: 180.h,
        minWidth: button.size.width,
        maxWidth: button.size.width,
      ),
      items: categoryState.categories.map((category) {
        return PopupMenuItem<String>(
          value: category.id,
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(category.name ?? ''),
          ),
        );
      }).toList(),
    );

    if (!mounted || selected == null) return;
    setState(() {
      _selectedCategoryId = selected;
      _categoryController.text = categoryState.categories
              .firstWhere((element) => element.id == selected)
              .name ??
          '';
    });
  }

  Future<void> _pickGovernorate() async {
    final cubit = context.read<GovernoratesCubit>();
    var state = cubit.state;

    if (state is! GovernoratesSuccess) {
      await cubit.getGovernorates();
      if (!mounted) return;
      state = cubit.state;
    }
    if (state is! GovernoratesSuccess) return;

    final button =
        _governorateKey.currentContext!.findRenderObject() as RenderBox;
    if (!mounted) return;
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final position = button.localToGlobal(Offset.zero, ancestor: overlay);

    final selected = await showMenu<GovernorateModel>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + button.size.height,
        position.dx + button.size.width,
        0,
      ),
      constraints: BoxConstraints(
        maxHeight: 180.h,
        minWidth: button.size.width,
        maxWidth: button.size.width,
      ),
      items: state.governorates.map((gov) {
        return PopupMenuItem<GovernorateModel>(
          value: gov,
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(gov.name),
          ),
        );
      }).toList(),
    );

    if (!mounted || selected == null) return;
    setState(() {
      _governorateController.text = selected.name;
      _selectedGovernorateId = selected.id;
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    context.read<UpdateProfileCubit>().updateUserData(
          firstName: nameController.text,
          lastName: lastNameController.text,
          governorate: _selectedGovernorateId ?? '',
          category: _selectedCategoryId ?? '',
          imagePath: _pickedImagePath,
        );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileSuccess) {
              final profile = state.data.data;
              if (profile != null) {
                nameController.text = profile.firstName ?? '';
                lastNameController.text = profile.lastName ?? '';
                phoneController.text =
                    profile.authUser?.mobilePhone?.replaceFirst('963', '') ??
                        '';
                _governorateController.text = profile.city?.name ?? '';
                _selectedGovernorateId = profile.city?.id?.toString();
                _selectedCategoryId = profile.car?.category?.toString();
                _syncCategoryControllerFromLoadedCategories();
              }
            }
          },
        ),
        BlocListener<CarCategoryCubit, CarCategoryState>(
          listener: (context, state) {
            if (state is CarCategorySuccess) {
              _syncCategoryControllerFromLoadedCategories();
            }
          },
        ),
        BlocListener<UpdateProfileCubit, UpdateProfileState>(
          listener: (context, state) {
            if (state is UpdateProfileSuccess) {
              AppSnackBar.success(context, state.message);
              context.read<ProfileCubit>().getProfileData();
            } else if (state is UpdateProfileFailure) {
              AppSnackBar.error(context, state.errMessage);
            }
          },
        ),
        BlocListener<VerificationCubit, VerificationState>(
          listener: (context, state) {
            if (state is CreateVerificationCodeSuccess) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VerificationCodeforgetpassword2(
                    mobilePhone: phoneController.text,
                  ),
                ),
              );
            } else if (state is VerificationFailure) {
              AppSnackBar.error(context, state.errMessage);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FB),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, profileState) {
            if (profileState is ProfileLoading) {
              return Column(
                children: [
                  const PersonalInfoHeader(),
                  Expanded(
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.main1),
                    ),
                  ),
                ],
              );
            }

            String? networkImage;
            if (profileState is ProfileSuccess) {
              networkImage = profileState.data.data?.profileImage;
            }

            return Column(
              children: [
                const PersonalInfoHeader(),
                Expanded(
                  child: Transform.translate(
                    offset: Offset(0, -22.h),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(
                          PersonalInfoUiConstants.horizontalPadding.w,
                          0,
                          PersonalInfoUiConstants.horizontalPadding.w,
                          28.h,
                        ),
                        children: [
                          PersonalInfoAvatar(
                            networkImagePath: networkImage,
                            pickedImagePath: _pickedImagePath,
                            onEdit: _pickImage,
                          ),
                          SizedBox(height: 18.h),
                          PersonalInfoSectionCard(
                            titleKey: 'personal_info',
                            children: [
                              SizedBox(height: 8.h),
                              AppTextField(
                                controller: nameController,
                                hintKey: 'first_name',
                                icon: Icons.person_outline_rounded,
                                validator: (val) =>
                                    Validators.isEmptyValue(val, context),
                              ),
                              SizedBox(height: 12.h),
                              AppTextField(
                                controller: lastNameController,
                                hintKey: 'last_name',
                                icon: Icons.badge_outlined,
                                validator: (val) =>
                                    Validators.isEmptyValue(val, context),
                              ),
                              SizedBox(height: 12.h),
                              AppPhoneField(
                                controller: phoneController,
                                readOnly: true,
                                validator: (_) => null,
                                suffix: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const PasswordForgetPhone(),
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.edit_rounded,
                                    color: AppColors.main1,
                                    size: 18.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: PersonalInfoUiConstants.sectionSpacing.h,
                          ),
                          PersonalInfoSectionCard(
                            titleKey: 'vehicle_info',
                            children: [
                              SizedBox(height: 8.h),
                              KeyedSubtree(
                                key: _governorateKey,
                                child: AppPickerField(
                                  controller: _governorateController,
                                  hintKey: 'governorate',
                                  icon: Icons.location_city_rounded,
                                  onTap: _pickGovernorate,
                                  validator: (val) =>
                                      Validators.isEmptyValue(val, context),
                                ),
                              ),
                              SizedBox(height: 12.h),
                              KeyedSubtree(
                                key: _categoryKey,
                                child: AppPickerField(
                                  controller: _categoryController,
                                  hintKey: 'category',
                                  icon: Icons.directions_car_outlined,
                                  onTap: _pickCategory,
                                  validator: (val) => val == null || val.isEmpty
                                      ? AppTranslations.getText(
                                          context,
                                          'validate_empty',
                                        )
                                      : null,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: PersonalInfoUiConstants.sectionSpacing.h,
                          ),
                          PersonalInfoSectionCard(
                            titleKey: 'password',
                            children: [
                              SizedBox(height: 8.h),
                              AppTextField(
                                controller: passwordController,
                                hintKey: 'password',
                                icon: Icons.lock_outline_rounded,
                                obscureText: true,
                                readOnly: true,
                                validator: (_) => null,
                                suffix: IconButton(
                                  onPressed: () {
                                    if (phoneController.text.isNotEmpty) {
                                      context
                                          .read<VerificationCubit>()
                                          .sendVerificationCode(
                                            mobilePhone:
                                                '963${phoneController.text}',
                                            typeOfUse: 'reset-password',
                                          );
                                    } else {
                                      AppSnackBar.error(
                                        context,
                                        AppTranslations.getText(
                                          context,
                                          'please_enter_phone_first',
                                        ),
                                      );
                                    }
                                  },
                                  icon: Icon(
                                    Icons.edit_rounded,
                                    color: AppColors.main1,
                                    size: 18.sp,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                AppTranslations.getText(
                                  context,
                                  'password_edit_hint',
                                ),
                                style: TextStyle(
                                  color: AuthUiConstants.mutedText,
                                  fontSize: 11.5.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 22.h),
                          BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
                            builder: (context, updateState) {
                              return PersonalInfoSaveButton(
                                isLoading:
                                    updateState is UpdateProfileLoading,
                                onPressed: _save,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
