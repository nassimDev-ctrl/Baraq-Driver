import 'package:drever_warr/core/translate/language_cubit.dart';
import 'package:drever_warr/core/utils/service_locator.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/complain_cubit/cubit.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/cubit_finsh_trips/cubit.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/cubit_notification/cubit.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/cubit_update_location/cubit.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/cubit_wallat/cubit.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/driver_available_cubit/cubit.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/logout_cubit/cubit.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/repo/complain_repo/repo_impl.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/repo/driver_available_repo/repo.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/repo/finsh_trips_repo/repo_implmntion.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/repo/logout_repo/repo_impl.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/repo/repo_notification/repo_implmantion.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/repo/repo_wallat/repo_implmantion.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/repo/update_location/repo_implementation.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/ScheduledTrips_cubit/cubit.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/accept_order_cubit/cubit.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/cubet_end_tripe/cubit.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/cubit_current_trip/cubit.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/cubit_order/cubit.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/cubit_start_order/cubit.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/repo/accept_order_repo/repo_implmantion.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/repo/repo_end_tripe/repo_implmantion.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/repo/repo_order/ScheduledTrips_repo/repo_implmantion.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/repo/repo_order/repo_implmantion.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/repo/repo_start_tripe/repo_implmantion.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/repo/scheduled_accept_order_repo/repo_implmantion.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/scheduled_accept_order_cubit/cubit.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/trip_details_cubit/cubit.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/repo/current_trip_repo/repo_impl.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/repo/trip_details_repo/repo_implementation.dart';
import 'package:drever_warr/features/my_tripe/data/cubit/cubit_details_single_trip/cubit.dart';
import 'package:drever_warr/features/my_tripe/data/cubit/cubit_messages/cubit.dart';
import 'package:drever_warr/features/my_tripe/data/cubit/cubit_ratting/cubit.dart';
import 'package:drever_warr/features/my_tripe/data/cubit/cubit_trip_note/cubit.dart';
import 'package:drever_warr/features/my_tripe/data/repo/details_single_trip_repo/repo_impl.dart';
import 'package:drever_warr/features/my_tripe/data/repo/messages_repo/repo_impl.dart';
import 'package:drever_warr/features/my_tripe/data/repo/repo_rating/repo_implmantion.dart';
import 'package:drever_warr/features/my_tripe/data/repo/trip_note_repo/repo_impl.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_car_all_filld/cubit.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_car_image/cubit.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_category/cubit.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_forget_passwrde/cubit.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_governorates/cubit.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_information_car/cubit.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_login/cubit.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_personal_image/cubit.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_regster.dart/cubit_rejester.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_verificationRepo/cubit.dart';
import 'package:drever_warr/features/presentation/data/repo/repo/repo_car_all_filld/repo_implmantion.dart';
import 'package:drever_warr/features/presentation/data/repo/repo/repo_car_image/repo_implmantion.dart';
import 'package:drever_warr/features/presentation/data/repo/repo/repo_category/repo_implmantion.dart';
import 'package:drever_warr/features/presentation/data/repo/repo/repo_forget_passwrd/repo_implmantion.dart';
import 'package:drever_warr/features/presentation/data/repo/repo/repo_information_car/repo_implmantion.dart';
import 'package:drever_warr/features/presentation/data/repo/repo/repo_login/repo_implmantion.dart';
import 'package:drever_warr/features/presentation/data/repo/repo/repo_personal_image/repo_implmantion.dart';
import 'package:drever_warr/features/presentation/data/repo/repo/repo_verificationRepo/repo_implmantion.dart';
import 'package:drever_warr/features/presentation/data/repo/repo_implmantion.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_edit_passwrd/cubit.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_profail/cubit.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_updet_phone/cubit.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_update_language/cubit_state.dart';
import 'package:drever_warr/features/setting/data/cubit/updet_profail/cubit.dart';
import 'package:drever_warr/features/setting/data/repo/repo_edit_passowrd/repo_implmantion.dart';
import 'package:drever_warr/features/setting/data/repo/repo_profail/repo_implmantion.dart';
import 'package:drever_warr/features/setting/data/repo/repo_updet_phone.dart/repo_implmantion.dart';
import 'package:drever_warr/features/setting/data/repo/repo_updet_profail/repo_implmantion.dart';
import 'package:drever_warr/features/setting/data/repo/update_language_repo/repo.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Explicit `<T>` on every [BlocProvider] is required: a bare
/// `List<BlocProvider>` context otherwise erases `T` to the Cubit bound, and
/// `context.read/watch<MyCubit>()` cannot find the provider.

List<BlocProvider> get coreProviders => [
      BlocProvider<LanguageCubit>(
        lazy: true,
        create: (_) => LanguageCubit(),
      ),
    ];

List<BlocProvider> get authProviders => [
      BlocProvider<GovernoratesCubit>(
        lazy: true,
        create: (_) => getIt<GovernoratesCubit>(),
      ),
      BlocProvider<VerificationCubit>(
        lazy: true,
        create: (_) => VerificationCubit(getIt<VerificationRepoImpl>()),
      ),
      BlocProvider<RegisterCubit>(
        lazy: true,
        create: (_) => RegisterCubit(getIt<ImplementRepoRegister>()),
      ),
      BlocProvider<LoginCubit>(
        lazy: true,
        create: (_) => LoginCubit(getIt<ImplementRepoLogin>()),
      ),
      BlocProvider<ConfirmPasswordCubit>(
        lazy: true,
        create: (_) => ConfirmPasswordCubit(getIt<ConfirmPasswordRepoImpl>()),
      ),
      BlocProvider<UploadImageCubit>(
        lazy: true,
        create: (_) => UploadImageCubit(getIt<ImplementRepoUploadImage>()),
      ),
      BlocProvider<UploadIdCubit>(
        lazy: true,
        create: (_) => UploadIdCubit(getIt<ImplementRepoUploadId>()),
      ),
      BlocProvider<CarInfoCubit>(
        lazy: true,
        create: (_) => CarInfoCubit(getIt<ImplementRepoCarInfo>()),
      ),
      BlocProvider<CarAllFilldCubit>(
        lazy: true,
        create: (_) => CarAllFilldCubit(getIt<CarAllFilldRepoImpl>()),
      ),
      BlocProvider<CarCategoryCubit>(
        lazy: true,
        create: (_) => CarCategoryCubit(getIt<RepoCarCategoryImpl>()),
      ),
    ];

List<BlocProvider> get homeSessionProviders => [
      BlocProvider<LogoutCubit>(
        lazy: true,
        create: (_) => LogoutCubit(getIt<LogoutRepositoryImpl>()),
      ),
      BlocProvider<SearchingTripsCubit>(
        lazy: true,
        create: (_) => SearchingTripsCubit(getIt<RepoSearchingTripsImpl>()),
      ),
      BlocProvider<DriverStatusCubit>(
        lazy: true,
        create: (_) => DriverStatusCubit(getIt<DriverStatusRepositoryImpl>()),
      ),
      BlocProvider<ScheduledTripsCubit>(
        lazy: true,
        create: (_) => ScheduledTripsCubit(getIt<RepoScheduledTripsImpl>()),
      ),
      BlocProvider<UpdateLanguageCubit>(
        lazy: true,
        create: (_) => UpdateLanguageCubit(getIt<LanguageRepositoryImpl>()),
      ),
      BlocProvider<NotificationCubit>(
        lazy: true,
        create: (_) => NotificationCubit(getIt<NotificationRepositoryImpl>()),
      ),
      BlocProvider<WalletCubit>(
        lazy: true,
        create: (_) => WalletCubit(getIt<WalletRepositoryImpl>()),
      ),
      BlocProvider<ProfileCubit>(
        lazy: true,
        create: (_) => ProfileCubit(getIt<ImplementRepoProfile>()),
      ),
      BlocProvider<DriverLocationCubit>(
        lazy: true,
        create: (_) =>
            DriverLocationCubit(getIt<DriverLocationRepositoryImpl>()),
      ),
      BlocProvider<UpdateProfileCubit>(
        lazy: true,
        create: (_) => UpdateProfileCubit(getIt<UpdateProfileRepoImpl>()),
      ),
      BlocProvider<ChangePasswordCubit>(
        lazy: true,
        create: (_) => ChangePasswordCubit(getIt<ChangePasswordRepoImpl>()),
      ),
      BlocProvider<UpdateMobileCubit>(
        lazy: true,
        create: (_) => UpdateMobileCubit(getIt<RepoUpdateMobileImpl>()),
      ),
      BlocProvider<GetStartedTripsCubit>(
        lazy: true,
        create: (_) =>
            GetStartedTripsCubit(getIt<GetStartedTripsRepositoryImpl>()),
      ),
    ];

List<BlocProvider> get tripFlowProviders => [
      BlocProvider<ChatCubit>(
        lazy: true,
        create: (_) => ChatCubit(getIt<ChatRepositoryImpl>()),
      ),
      BlocProvider<AcceptTripCubit>(
        lazy: true,
        create: (_) => AcceptTripCubit(getIt<AcceptTripRepoImpl>()),
      ),
      BlocProvider<ScheduledAcceptTripCubit>(
        lazy: true,
        create: (_) =>
            ScheduledAcceptTripCubit(getIt<ScheduledAcceptOrderRepoImpl>()),
      ),
      BlocProvider<TripDetailsCubit>(
        lazy: true,
        create: (_) => TripDetailsCubit(getIt<TripDetailsRepositoryImpl>()),
      ),
      BlocProvider<SingleTripDetailsCubit>(
        lazy: true,
        create: (_) =>
            SingleTripDetailsCubit(getIt<SingleTripDetailsRepositoryImpl>()),
      ),
      BlocProvider<AddRatingCubit>(
        lazy: true,
        create: (_) => AddRatingCubit(getIt<AddRatingRepoImpl>()),
      ),
      BlocProvider<GetFinishedTripsCubit>(
        lazy: true,
        create: (_) => GetFinishedTripsCubit(getIt<GetFinishedTripsRepoImpl>()),
      ),
      BlocProvider<StartTripCubit>(
        lazy: true,
        create: (_) => StartTripCubit(getIt<TripRepositoryImpl>()),
      ),
      BlocProvider<TripNoteCubit>(
        lazy: true,
        create: (_) => TripNoteCubit(getIt<TripNoteRepositoryImpl>()),
      ),
      BlocProvider<AddComplainCubit>(
        lazy: true,
        create: (_) => AddComplainCubit(getIt<AddComplainRepositoryImpl>()),
      ),
      BlocProvider<EndTripCubit>(
        lazy: true,
        create: (_) => EndTripCubit(getIt<EndTripRepositoryImpl>()),
      ),
    ];

/// Wraps a trip/order screen so its cubits are created only for that route.
Widget withTripFlow(Widget child) {
  return MultiBlocProvider(
    providers: tripFlowProviders,
    child: child,
  );
}
