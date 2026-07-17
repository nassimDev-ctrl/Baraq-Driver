import 'package:dio/dio.dart';
import 'package:drever_warr/core/service/api_service.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/repo/complain_repo/repo_impl.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/repo/driver_available_repo/repo.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/repo/finsh_trips_repo/repo_implmntion.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/repo/logout_repo/repo_impl.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/repo/repo_notification/repo_implmantion.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/repo/repo_wallat/repo_implmantion.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/repo/update_location/repo_implementation.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/repo/accept_order_repo/repo_implmantion.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/repo/repo_end_tripe/repo_implmantion.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/repo/repo_order/ScheduledTrips_repo/repo_implmantion.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/repo/repo_order/repo_implmantion.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/repo/repo_start_tripe/repo_implmantion.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/repo/scheduled_accept_order_repo/repo_implmantion.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/repo/current_trip_repo/repo_impl.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/repo/trip_details_repo/repo_implementation.dart';
import 'package:drever_warr/features/my_tripe/data/repo/details_single_trip_repo/repo_impl.dart';
import 'package:drever_warr/features/my_tripe/data/repo/messages_repo/repo_impl.dart';
import 'package:drever_warr/features/my_tripe/data/repo/repo_rating/repo_implmantion.dart';
import 'package:drever_warr/features/my_tripe/data/repo/trip_note_repo/repo_impl.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_governorates/cubit.dart';
import 'package:drever_warr/features/presentation/data/repo/repo/repo_car_all_filld/repo_implmantion.dart';
import 'package:drever_warr/features/presentation/data/repo/repo/repo_car_image/repo_implmantion.dart';
import 'package:drever_warr/features/presentation/data/repo/repo/repo_category/repo_implmantion.dart';
import 'package:drever_warr/features/presentation/data/repo/repo/repo_forget_passwrd/repo_implmantion.dart';
import 'package:drever_warr/features/presentation/data/repo/repo/repo_governorates/repo_implmantion.dart';
import 'package:drever_warr/features/presentation/data/repo/repo/repo_information_car/repo_implmantion.dart';
import 'package:drever_warr/features/presentation/data/repo/repo/repo_login/repo_implmantion.dart';
import 'package:drever_warr/features/presentation/data/repo/repo/repo_personal_image/repo_implmantion.dart';
import 'package:drever_warr/features/presentation/data/repo/repo/repo_verificationRepo/repo_implmantion.dart';
import 'package:drever_warr/features/presentation/data/repo/repo_implmantion.dart';
import 'package:drever_warr/features/setting/data/repo/repo_edit_passowrd/repo_implmantion.dart';
import 'package:drever_warr/features/setting/data/repo/repo_profail/repo_implmantion.dart';
import 'package:drever_warr/features/setting/data/repo/repo_updet_phone.dart/repo_implmantion.dart';
import 'package:drever_warr/features/setting/data/repo/repo_updet_profail/repo_implmantion.dart';
import 'package:drever_warr/features/setting/data/repo/update_language_repo/repo.dart';
import 'package:drever_warr/features/update/update_required_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'navigator_key.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  final dio = Dio();

  dio.interceptors.add(InterceptorsWrapper(
    onError: (DioException e, ErrorInterceptorHandler handler) {
      if (e.response?.statusCode == 426) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const UpdateRequiredView()),
            (_) => false,
          );
        });
      }
      handler.next(e);
    },
  ));

  getIt.registerLazySingleton<Dio>(() => dio);
  getIt.registerLazySingleton<ApiService>(() => ApiService(getIt<Dio>()));

  // Auth / onboarding repos
  getIt.registerLazySingleton<RepoGovernoratesImpl>(
    () => RepoGovernoratesImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<VerificationRepoImpl>(
    () => VerificationRepoImpl(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ImplementRepoRegister>(
    () => ImplementRepoRegister(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ImplementRepoLogin>(
    () => ImplementRepoLogin(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ConfirmPasswordRepoImpl>(
    () => ConfirmPasswordRepoImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ImplementRepoUploadImage>(
    () => ImplementRepoUploadImage(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ImplementRepoUploadId>(
    () => ImplementRepoUploadId(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ImplementRepoCarInfo>(
    () => ImplementRepoCarInfo(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<CarAllFilldRepoImpl>(
    () => CarAllFilldRepoImpl(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<RepoCarCategoryImpl>(
    () => RepoCarCategoryImpl(getIt<ApiService>()),
  );

  // Home session repos
  getIt.registerLazySingleton<LogoutRepositoryImpl>(
    () => LogoutRepositoryImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<RepoSearchingTripsImpl>(
    () => RepoSearchingTripsImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<DriverStatusRepositoryImpl>(
    () => DriverStatusRepositoryImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<RepoScheduledTripsImpl>(
    () => RepoScheduledTripsImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<LanguageRepositoryImpl>(
    () => LanguageRepositoryImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<NotificationRepositoryImpl>(
    () => NotificationRepositoryImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<WalletRepositoryImpl>(
    () => WalletRepositoryImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<GetFinishedTripsRepoImpl>(
    () => GetFinishedTripsRepoImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ImplementRepoProfile>(
    () => ImplementRepoProfile(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<DriverLocationRepositoryImpl>(
    () => DriverLocationRepositoryImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<UpdateProfileRepoImpl>(
    () => UpdateProfileRepoImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ChangePasswordRepoImpl>(
    () => ChangePasswordRepoImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<RepoUpdateMobileImpl>(
    () => RepoUpdateMobileImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<GetStartedTripsRepositoryImpl>(
    () => GetStartedTripsRepositoryImpl(getIt<ApiService>()),
  );

  // Trip / order flow repos
  getIt.registerLazySingleton<ChatRepositoryImpl>(
    () => ChatRepositoryImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<AcceptTripRepoImpl>(
    () => AcceptTripRepoImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ScheduledAcceptOrderRepoImpl>(
    () => ScheduledAcceptOrderRepoImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<TripDetailsRepositoryImpl>(
    () => TripDetailsRepositoryImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<SingleTripDetailsRepositoryImpl>(
    () => SingleTripDetailsRepositoryImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<AddRatingRepoImpl>(
    () => AddRatingRepoImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<TripRepositoryImpl>(
    () => TripRepositoryImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<TripNoteRepositoryImpl>(
    () => TripNoteRepositoryImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<AddComplainRepositoryImpl>(
    () => AddComplainRepositoryImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<EndTripRepositoryImpl>(
    () => EndTripRepositoryImpl(getIt<ApiService>()),
  );

  getIt.registerFactory(() => GovernoratesCubit(getIt<RepoGovernoratesImpl>()));
}
