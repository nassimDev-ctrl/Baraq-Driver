import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failear.dart';

abstract class AddComplainRepository {
  Future<Either<Failur, String>> sendComplain({
    required String description,
    File? image,
  });
}