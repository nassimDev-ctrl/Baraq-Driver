// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:warr2/core/service/api_servise.dart';
// import 'package:warr2/core/service/failear.dart';
// import 'package:warr2/features/Auth/preasntaion/data/repo/repo.dart';
 
// class ImplementRepoRegister extends RepoRegister {
//   final ApiService _apiService;

//   ImplementRepoRegister({required ApiService apiService})
//     : _apiService = apiService;

//   @override
//   Future<Either<Failur, dynamic>> register({
//     required Map<String, dynamic> userData,
//   }) async {
//     // 1. طباعة البيانات المرسلة للسيرفر
//     print("🚀 [POST Request] Endpoint: /clients/register");
//     print("📦 [Request Data]: $userData");

//     try {
//       Response response = await _apiService.postdata(
//         "/clients/register",
//         data: userData,
//         needToken: false,
//         isfromdata: false,
//       );

//       // 2. طباعة الرد القادم من السيرفر بالتفصيل
//       print("✅ [Response Received] Status Code: ${response.statusCode}");
//       print("📄 [Response Data]: ${response.data}");

//       if (response.data["error"] == false) {
//         print("🎉 [Register Success]");
//         return right(response.data);
//       } else {
//         // 3. طباعة الخطأ المنطقي (مثلاً رقم هاتف مستخدم)
//         print("⚠️ [Logic Error from Server]: ${response.data}");
//         return left(
//           ServierFailur.fromResponse(response.statusCode ?? 400, response.data),
//         );
//       }
//     } catch (e) {
//       // 4. طباعة أي خطأ تقني أو خطأ اتصال
//       print("❌ [Exception Caught in Repo]: $e");

//       if (e is DioException) {
//         print("🔴 [Dio Error Type]: ${e.type}");
//         print("🔴 [Dio Error Response]: ${e.response?.data}");
//         return left(ServierFailur.fromDioError(e));
//       }
//       return left(ServierFailur('حدث خطأ أثناء التسجيل', 500));
//     }
//   }
// }
