 

import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failure.dart';
 
abstract class UpdateProfileRepo {
  Future<Either<Failure, String>> updateProfile({
    required String firstName,
    required String lastName,
    required String governorate,
    required String category,
    String? imagePath,
  });
}