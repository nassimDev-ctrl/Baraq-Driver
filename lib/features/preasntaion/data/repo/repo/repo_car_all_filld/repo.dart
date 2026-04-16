 import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failear.dart';

abstract class CarAllFilldRepo {
  Future<Either<Failur, dynamic>> completeCarAllFilldInfo({
    required Map<String, dynamic> carData,
  });
}