 import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failure.dart';

abstract class CarAllFilldRepo {
  Future<Either<Failure, dynamic>> completeCarAllFilldInfo({
    required Map<String, dynamic> carData,
  });
}