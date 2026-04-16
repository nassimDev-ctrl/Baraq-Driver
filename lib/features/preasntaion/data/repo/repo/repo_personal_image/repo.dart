import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failear.dart';
import 'dart:io';

abstract class RepoUploadImage {
  Future<Either<Failur, dynamic>> uploadDriverImage({
    required File imageFile,
  });
}