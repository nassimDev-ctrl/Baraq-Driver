// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:warr2/core/service/api_servise.dart';
// import 'package:warr2/core/service/failear.dart';
// import 'package:warr2/features/Auth/preasntaion/data/repo/model/model_governorates.dart';
// import 'package:warr2/features/Auth/preasntaion/data/repo/repo/repo_governorates/repo.dart';
 
 
 

// class RepoGovernoratesImpl extends RepoGovernorates {
//   final ApiService _apiService;

//   RepoGovernoratesImpl(this._apiService);

//   @override
//   Future<Either<Failur, List<GovernorateModel>>> fetchGovernorates() async {
//     try {
//       print("🚀 [GET Request] Endpoint: governorates");
      
//       Response response = await _apiService.get(
//         endpoint: "governorates",
//         needToken: false, // حسب الـ JSON يبدو أنها بيانات عامة
//       );

//       print("✅ [Governorates Response]: ${response.data}");

//       if (response.data["success"] == true) {
//         List<GovernorateModel> governorates = [];
//         for (var item in response.data["governorates"]) {
//           governorates.add(GovernorateModel.fromJson(item));
//         }
//         return right(governorates);
//       } else {
//         return left(ServierFailur.fromResponse(response.statusCode ?? 400, response.data));
//       }
//     } catch (e) {
//       print("❌ [Exception in Governorates Repo]: $e");
//       if (e is DioException) {
//         return left(ServierFailur.fromDioError(e));
//       }
//       return left(ServierFailur('حدث خطأ أثناء جلب المحافظات', 500));
//     }
//   }
// }