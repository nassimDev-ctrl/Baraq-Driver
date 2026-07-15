import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failure.dart';

abstract class RepoUploadId {
  Future<Either<Failure, dynamic>> uploadDriverIdImages({
    required File frontImage,
    required File backImage,
  });
}