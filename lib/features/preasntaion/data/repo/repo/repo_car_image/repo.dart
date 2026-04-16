import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failear.dart';

abstract class RepoUploadId {
  Future<Either<Failur, dynamic>> uploadDriverIdImages({
    required File frontImage,
    required File backImage,
  });
}