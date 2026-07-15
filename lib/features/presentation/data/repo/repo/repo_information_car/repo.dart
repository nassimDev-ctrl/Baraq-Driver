import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failure.dart';

abstract class RepoCarInfo {
  Future<Either<Failure, dynamic>> completeCarInfo({
    required File carImage,
    required File carPlateImage,
    required String carName,
    required String category,
    required String carColor,
    required String carPlateNumber,
    required String carYearMade,
  });
}