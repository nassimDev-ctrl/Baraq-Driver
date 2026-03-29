 
// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:warr2/core/cash/preferences_servis.dart';
// import 'package:warr2/core/service/api_servise.dart';
// import 'package:warr2/core/service/failear.dart';
// import 'package:warr2/features/Auth/preasntaion/data/repo/repo/repo_login/repo.dart';
 
 
 

// class ImplementRepoLogin extends RepoLogin {
//   final ApiService _apiService;

//   ImplementRepoLogin({required ApiService apiService})
//     : _apiService = apiService;

//   @override
//   Future<Either<Failur, dynamic>> login({
//     required String mobilePhone,
//     required String password,
//   }) async {
//     final Map<String, dynamic> loginData = {
//       "mobilePhone": mobilePhone.toString(),
//       "password": password,
//     };

//     print("🚀 [POST Request] Endpoint: auth-users/login");
//     print("📦 [Login Data]: $loginData");

//     try {
//       Response response = await _apiService.postdata(
//         "auth-users/login",
//         data: loginData,
//         needToken: false,
//         isfromdata: false,
//       );

//       print("✅ [Response Received] Status Code: ${response.statusCode}");
//       print("📄 [Response Data]: ${response.data}");

//       // التحقق من نجاح العملية بناءً على رد السيرفر
//       if (response.data["success"] == true || response.data["error"] == false) {
//         // --- 💾 منطق تخزين التوكن المعدل ---
//         // بناءً على الـ Log الخاص بك: التوكن موجود داخل حقل الـ data
//         final String? token = response.data["data"]?["token"];

//         if (token != null && token.isNotEmpty) {
//           await CacheManager.saveData('token', token);
//           print(
//             "🔑 [Token Saved]: تم استخراج التوكن من data['token'] وحفظه بنجاح",
//           );
//         } else {
//           print(
//             "⚠️ [Token Warning]: لم يتم العثور على التوكن في المسار response.data['data']['token']",
//           );
//         }
//         // -------------------------

//         return right(response.data);
//       } else {
//         print("🛑 [Login Logic Error]: السيرفر أعاد حالة فشل");
//         return left(
//           ServierFailur.fromResponse(response.statusCode ?? 400, response.data),
//         );
//       }
//     } catch (e) {
//       print("❌ [Exception Caught in Login Repo]: $e");
//       if (e is DioException) {
//         print("🔗 Error Details: ${e.response?.data}");
//         return left(ServierFailur.fromDioError(e));
//       }
//       return left(ServierFailur('حدث خطأ أثناء تسجيل الدخول', 500));
//     }
//   }
// }
