import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
    
   
final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<Dio>(
    Dio(),
  );

  // getIt.registerSingleton(ApiService(
  //   dio: getIt.get<Dio>(),
  // ));
  // getIt.registerSingleton<ImplementRepoRegister>(
  //   ImplementRepoRegister(apiService: getIt.get<ApiService>()),
  // );
}
