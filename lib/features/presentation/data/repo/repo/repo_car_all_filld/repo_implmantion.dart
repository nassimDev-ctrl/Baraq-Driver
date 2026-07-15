 import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drever_warr/core/service/api_service.dart';
import 'package:drever_warr/core/service/failure.dart';
import 'package:drever_warr/features/presentation/data/repo/repo/repo_car_all_filld/repo.dart';
 
class CarAllFilldRepoImpl extends CarAllFilldRepo {
  final ApiService _apiService;

  CarAllFilldRepoImpl({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<Either<Failure, dynamic>> completeCarAllFilldInfo({
    required Map<String, dynamic> carData,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "carName": carData['carName'],
        "category": carData['category'],
        "carPlateNumber": carData['carPlateNumber'],
        "carYearMade": carData['carYearMade'],
        "car_image": await MultipartFile.fromFile(carData['car_image']),
        "car_plate_image": await MultipartFile.fromFile(carData['car_plate_image']),
      });

      Response response = await _apiService.postdata(
        "/drivers/complete-driver-car-info",
        data: formData,
        needToken: true,
        isfromdata: true,
      );

      if (response.data["success"] == true) {
        return right(response.data);
      } else {
        return left(
          ServerFailure.fromResponse(response.statusCode ?? 400, response.data),
        );
      }
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure('حدث خطأ أثناء رفع بيانات السيارة', 500));
    }
  }
}