import 'package:dio/dio.dart';
import 'package:drever_warr/core/service/api_servise.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_governorates/cubit.dart';
import 'package:drever_warr/features/preasntaion/data/repo/repo/repo_governorates/repo_implmantion.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<Dio>(() => Dio());

   
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
