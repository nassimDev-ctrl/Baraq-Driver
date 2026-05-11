 
import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/utiles/faledtor.dart';
import 'package:drever_warr/core/widgets/coustm_text_fild_all.dart';
import 'package:drever_warr/core/widgets/customButton.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_governorates/cubit.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_governorates/cubit_state.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_verificationRepo/cubit.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_verificationRepo/cubite_state.dart';
import 'package:drever_warr/features/preasntaion/data/repo/model/model_governorates.dart';
import 'package:drever_warr/features/preasntaion/widhets/icon_bak.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_profail/cubit.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_profail/cubit_stat.dart';
import 'package:drever_warr/features/setting/data/cubit/updet_profail/cubit.dart';
import 'package:drever_warr/features/setting/data/cubit/updet_profail/cubit_stat.dart';
import 'package:drever_warr/features/setting/preasntaion/view/Verficationcode_change_password.dart';
import 'package:drever_warr/features/setting/preasntaion/view/password_for_edet_phone.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';


import 'dart:io';

import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../preasntaion/data/repo/cubit/cubit_category/cubit.dart';
import '../../../preasntaion/data/repo/cubit/cubit_category/cubit_stat.dart';


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

  String? _selectedGovernorateId;
  String? _selectedCategoryId;
  String? _pickedImagePath;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool carCategoryError = false;

  @override
  void initState() {
    super.initState();

    context.read<ProfileCubit>().getProfileData();
    context.read<CarCategoryCubit>().getCarCategories();
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
        _categoryController.text = category.name ?? "";
        return;
      }
    }

    _categoryController.clear();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _pickedImagePath = image.path;
      });
    }
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
                  nameController.text = profile.firstName ?? "";
                  lastNameController.text = profile.lastName ?? "";
                  phoneController.text =
                      profile.authUser?.mobilePhone?.replaceFirst("963", "") ?? "";

                  _governorateController.text = profile.city?.name ?? "";
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
                context.read<ProfileCubit>().getProfileData();
              } else if (state is UpdateProfileFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errMessage),
                    backgroundColor: Colors.red,
                  ),
                );
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
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, profileState) {
              if (profileState is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const IconBak(),
                      SizedBox(height: 20.h),


                      _buildProfileImage(profileState),

                      SizedBox(height: 30.h),
                      _buildSectionTitle("personal_info"),


                      _buildInputLabel("first_name"),
                      AppCustomTextField(
                        iconImage: IconsAssets.editee,
                        controller: nameController,
                        hintText: "",
                        validator: (val) =>
                            Validators.isEmptyValue(val, context),
                      ),
                      _buildInputLabel("last_name"),
                      AppCustomTextField(
                        iconImage: IconsAssets.editee,
                        controller: lastNameController,
                        hintText: "",
                        validator: (val) =>
                            Validators.isEmptyValue(val, context),
                      ),


                      _buildInputLabel("phone_number"),
                      AppCustomTextField(
                        countryCode: "+963",
                        readOnly: true,
                        onIconTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PasswordForgetPhone(),
                            ),
                          );
                        },
                        controller: phoneController,
                        iconImage: IconsAssets.editee,
                        hintText: "",
                        validator: (String? p1) {},
                      ),


                      _buildInputLabel("governorate"),
                      _buildGovernoratePicker(context),

                      _buildFieldSection(
                        label: "category",
                        child: BlocBuilder<CarCategoryCubit, CarCategoryState>(
                          builder: (context, state) {
                            return GestureDetector(
                              onTap: () async {
                                final cubit = context.read<CarCategoryCubit>();

                                if (state is! CarCategorySuccess) {
                                  await cubit.getCarCategories();
                                }

                                if (cubit.state is CarCategorySuccess) {
                                  final categoryState =
                                  cubit.state as CarCategorySuccess;

                                  final RenderBox button =
                                  _categoryKey.currentContext!
                                      .findRenderObject()
                                  as RenderBox;
                                  final RenderBox overlay =
                                  Overlay.of(context)
                                      .context
                                      .findRenderObject()
                                  as RenderBox;

                                  final Offset position = button
                                      .localToGlobal(
                                    Offset.zero,
                                    ancestor: overlay,
                                  );

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
                                          alignment: Alignment.centerRight,
                                          child: Text(category.name ?? ""),
                                        ),
                                      );
                                    }).toList(),
                                  );

                                  if (selected != null) {
                                    setState(() {
                                      _selectedCategoryId = selected;
                                      _categoryController.text =
                                          categoryState.categories
                                              .firstWhere(
                                                (element) =>
                                            element.id == selected,
                                          )
                                              .name ??
                                              "";
                                    });
                                  }
                                }
                              },
                              child: AbsorbPointer(
                                child: Container(
                                  key: _categoryKey,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),

                                  ),
                                  child: AppCustomTextField(
                                    iconImage: IconsAssets.drowpdawn,
                                    controller: _categoryController,
                                    hintText: "",
                                    validator: (val) =>
                                    val!.isEmpty ? "مطلوب" : null,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),


                      _buildInputLabel("password"),
                      AppCustomTextField(
                        onIconTap: () {

                          if (phoneController.text.isNotEmpty) {

                            context.read<VerificationCubit>().sendVerificationCode(
                              mobilePhone:
                              "963${phoneController.text}",
                              typeOfUse:
                              "reset-password",
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("يرجى إدخال رقم الهاتف أولاً"),
                              ),
                            );
                          }
                        },
                        iconImage: IconsAssets.editee,
                        controller: passwordController,
                        hintText: "*****",
                        isPassword: true,
                        readOnly: true,
                        validator: (val) => Validators.validatePassword(val, context),
                      ),

                      SizedBox(height: 40.h),


                      BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
                        builder: (context, updateState) {
                          if (updateState is UpdateProfileLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return CustomButton(
                            title: "save_changes",
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<UpdateProfileCubit>().updateUserData(
                                  firstName: nameController.text,
                                  lastName: lastNameController.text,
                                  governorate: _selectedGovernorateId ?? "",
                                  category: _selectedCategoryId ?? "",
                                  imagePath:
                                  _pickedImagePath, // 👈 تمرير المسار الذي اخترناه
                                );
                              }
                            },
                          );

                        },
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

  }

  Widget _buildFieldSection({
    required String label,
    required Widget child,
    String? errorMessage,
  }) {
    final bool hasError =
        errorMessage != null && errorMessage.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildLabel(label),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: hasError
                ? Border.all(color: Colors.red, width: 1.5)
                : Border.all(color: Colors.transparent, width: 0),
          ),
          child: child,
        ),
        if (hasError) ...[
          SizedBox(height: 6.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: CustomText(
              errorMessage!,
              type: AppTextType.bodySmall,
              color: Colors.red,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomText(
            text,
            textAlign: TextAlign.right,
            type: AppTextType.bodyMedium,
          ),
        ],
      ),
    );
  }



  Widget _buildGovernoratePicker(BuildContext context) {
    return BlocBuilder<GovernoratesCubit, GovernoratesState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () async {
            final cubit = context.read<GovernoratesCubit>();

            if (state is! GovernoratesSuccess) {
              await cubit.getGovernorates();
            }

            if (cubit.state is GovernoratesSuccess) {
              final governorateState = cubit.state as GovernoratesSuccess;

              final RenderBox button = _governorateKey.currentContext!
                  .findRenderObject() as RenderBox;
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
                constraints: BoxConstraints(
                  maxHeight: 180.h,
                  minWidth: button.size.width,
                  maxWidth: button.size.width,
                ),
                items: governorateState.governorates.map((gov) {
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
            child: Container(
              key: _governorateKey,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: AppCustomTextField(
                iconImage: IconsAssets.drowpdawn,
                controller: _governorateController,
                hintText: "",
                validator: (val) => Validators.isEmptyValue(val, context),
              ),
            ),
          ),
        );
      },
    );
  }
  Widget _buildProfileImage(ProfileState state) {
    String? networkImageUrl;
    if (state is ProfileSuccess) {
      networkImageUrl = state.data.data?.profileImage;
    }

     
    const String baseUrl = 'https://api.taxiwaar.com/';

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 100.h,
            width: 100.w,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.blue.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: ClipOval(
              child: _pickedImagePath != null
                  ? Image.file(
                      File(_pickedImagePath!),
                      fit: BoxFit.cover,
                    )  
                  : (networkImageUrl != null && networkImageUrl.isNotEmpty)
                  ? Image.network(
                     
                      networkImageUrl.startsWith('http')
                          ? networkImageUrl
                          : "$baseUrl$networkImageUrl",
                      fit: BoxFit.cover,
                      
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          ImageAssets.imageprofail,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(ImageAssets.imageprofail, fit: BoxFit.cover),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  IconsAssets.editee,
                  height: 15.h,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

   
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
      child: CustomText(
        title,
        type: AppTextType.titleMedium,
        color: AppColors.blue,
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 12.h),
      child: CustomText(
        label,
        type: AppTextType.titleSmall,
        color: AppColors.secondary2,
      ),
    );
  }
}
