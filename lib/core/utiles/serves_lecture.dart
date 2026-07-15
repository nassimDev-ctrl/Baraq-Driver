import 'package:dio/dio.dart';
import 'package:drever_warr/core/service/api_servise.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_governorates/cubit.dart';
import 'package:drever_warr/features/preasntaion/data/repo/repo/repo_governorates/repo_implmantion.dart';
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

   
  getIt.registerLazySingleton<RepoGovernoratesImpl>(
    () => RepoGovernoratesImpl(getIt<ApiService>()),
  );

  
  getIt.registerFactory(() => GovernoratesCubit(getIt<RepoGovernoratesImpl>()));
  // getIt.registerSingleton(ApiService(
  //   dio: getIt.get<Dio>(),
  // ));
  // getIt.registerSingleton<ImplementRepoRegister>(
  //   ImplementRepoRegister(apiService: getIt.get<ApiService>()),
  // );
}
