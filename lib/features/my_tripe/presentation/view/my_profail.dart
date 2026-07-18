import 'package:drever_warr/core/cash/preferences_service.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/profile/driver_profile_header.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/profile/empty_reviews_widget.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/profile/profile_card.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/profile/profile_quick_info_card.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/profile/profile_review_tile.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/profile/profile_statistics_section.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/profile/profile_ui_constants.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/profile/reviews_card.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/profile/vehicle_information_card.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_profail/cubit.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_profail/cubit_stat.dart';
import 'package:drever_warr/features/setting/data/model/model_profail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DriverProfail extends StatefulWidget {
  const DriverProfail({super.key});

  @override
  State<DriverProfail> createState() => _DriverProfailState();
}

class _DriverProfailState extends State<DriverProfail> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final state = context.read<ProfileCubit>().state;
      if (state is! ProfileSuccess) {
        context.read<ProfileCubit>().getProfileData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading || state is ProfileInitial) {
              return const _ProfileLoading();
            }

            if (state is ProfileFailure) {
              return _ProfileError(
                message: state.errMessage,
                onRetry: () => context.read<ProfileCubit>().getProfileData(),
              );
            }

            if (state is ProfileSuccess) {
              return _ProfileBody(profile: state.data.data);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _ProfileBody extends StatefulWidget {
  const _ProfileBody({required this.profile});

  final ProfileData? profile;

  @override
  State<_ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<_ProfileBody> {
  String _lang = 'ar';

  @override
  void initState() {
    super.initState();
    _loadLang();
  }

  Future<void> _loadLang() async {
    final lang = await CacheManager.getData('app_language');
    if (mounted && lang != null) {
      setState(() => _lang = lang);
    }
  }

  List<int> _distribution(List<EvaluationModel> evaluations) {
    final counts = List<int>.filled(5, 0);
    for (final item in evaluations) {
      final value = double.tryParse(item.rating ?? '') ?? 0;
      final star = value.round().clamp(1, 5);
      counts[star - 1]++;
    }
    return counts;
  }

  String _cityName(City? city) {
    if (city == null) return '';
    switch (_lang) {
      case 'en':
        return city.nameEn ?? city.name ?? '';
      default:
        return city.nameAr ?? city.name ?? '';
    }
  }

  void _showAllReviews(
    BuildContext context,
    List<EvaluationModel> evaluations,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.sizeOf(context).height * 0.72,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7FB),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          ),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
                child: Row(
                  children: [
                    Text(
                      AppTranslations.getText(context, 'reviews'),
                      style: TextStyle(
                        color: AuthUiConstants.textPrimary,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                  itemCount: evaluations.length,
                  itemBuilder: (context, index) {
                    final review = evaluations[index];
                    final rating =
                        double.tryParse(review.rating ?? '') ?? 0;
                    return ProfileReviewTile(
                      note: review.note ?? '',
                      rating: rating,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _fadeUp({required int index, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 320 + (index * 70)),
      curve: Curves.easeOutCubic,
      builder: (context, value, animatedChild) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 14),
            child: animatedChild,
          ),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;
    final fullName =
        '${profile?.firstName ?? ''} ${profile?.lastName ?? ''}'.trim();
    final phone = profile?.authUser?.mobilePhone ?? '—';
    final evaluations = profile?.evaluations ?? const <EvaluationModel>[];
    final rating = profile?.rating ?? 0;
    final preview = evaluations.take(2).toList();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      clipBehavior: Clip.none,
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            height: (ProfileUiConstants.headerHeight +
                    ProfileUiConstants.avatarSize / 2 +
                    158)
                .h,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const DriverProfileHeader(),
                Positioned(
                  top: (ProfileUiConstants.headerHeight -
                          ProfileUiConstants.avatarSize / 2)
                      .h,
                  left: ProfileUiConstants.horizontalPadding.w,
                  right: ProfileUiConstants.horizontalPadding.w,
                  child: _fadeUp(
                    index: 0,
                    child: ProfileCard(
                      imagePath: profile?.profileImage,
                      fullName: fullName,
                      phone: phone,
                      rating: rating,
                      reviewsCount: evaluations.length,
                      isOnline: profile?.isAvailable == true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            ProfileUiConstants.horizontalPadding.w,
            8.h,
            ProfileUiConstants.horizontalPadding.w,
            36.h,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _fadeUp(
                index: 1,
                child: ProfileQuickInfoCard(
                  cityName: _cityName(profile?.city),
                  balance: profile?.balance ?? 0,
                ),
              ),
              SizedBox(height: ProfileUiConstants.sectionSpacing.h),
              _fadeUp(
                index: 2,
                child: ProfileStatisticsSection(
                  tripsCount: profile?.numberOfTrips ?? 0,
                  rating: rating,
                  distanceKm: profile?.distancePassed ?? 0,
                ),
              ),
              SizedBox(height: ProfileUiConstants.sectionSpacing.h),
              _fadeUp(
                index: 3,
                child: VehicleInformationCard(
                  carName: profile?.car?.carName ?? '',
                  carColor: profile?.car?.carColor ?? '',
                  carNumber: profile?.car?.carPlateNumber ?? '',
                  carYear: profile?.car?.carYearMade,
                  carImage: profile?.car?.carImage,
                ),
              ),
              SizedBox(height: ProfileUiConstants.sectionSpacing.h),
              _fadeUp(
                index: 4,
                child: evaluations.isEmpty
                    ? const EmptyReviewsWidget()
                    : ReviewsCard(
                        averageRating: rating,
                        reviewsCount: evaluations.length,
                        distribution: _distribution(evaluations),
                        previewNotes:
                            preview.map((e) => e.note ?? '').toList(),
                        previewRatings: preview
                            .map(
                              (e) => double.tryParse(e.rating ?? '') ?? 0,
                            )
                            .toList(),
                        onViewAll: () =>
                            _showAllReviews(context, evaluations),
                      ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class _ProfileLoading extends StatelessWidget {
  const _ProfileLoading();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DriverProfileHeader(),
        SizedBox(height: 40.h),
        CircularProgressIndicator(color: AppColors.main1),
      ],
    );
  }
}

class _ProfileError extends StatelessWidget {
  const _ProfileError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
            ),
            Icon(
              Icons.wifi_off_rounded,
              size: 42.sp,
              color: AuthUiConstants.iconMuted,
            ),
            SizedBox(height: 12.h),
            Text(
              message.isNotEmpty
                  ? message
                  : AppTranslations.getText(context, 'error_occurred'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AuthUiConstants.textPrimary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(AppTranslations.getText(context, 'retry')),
              style: TextButton.styleFrom(foregroundColor: AppColors.main1),
            ),
          ],
        ),
      ),
    );
  }
}
