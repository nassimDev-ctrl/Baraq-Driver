import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failure.dart';
import 'dart:io';

abstract class RepoUploadImage {
  Future<Either<Failure, dynamic>> uploadDriverImage({
    required File imageFile,
  });
}