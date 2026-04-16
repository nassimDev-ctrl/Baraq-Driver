import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failear.dart';

abstract class RepoCarInfo {
  Future<Either<Failur, dynamic>> completeCarInfo({
    required File carImage,
    required File carPlateImage,
    required String carName,
    required String category,
    required String carPlateNumber,
    required String carYearMade,
  });
}