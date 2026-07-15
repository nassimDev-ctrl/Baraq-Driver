import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failure.dart';

abstract class AddComplainRepository {
  Future<Either<Failure, String>> sendComplain({
    required String description,
    File? image,
  });
}