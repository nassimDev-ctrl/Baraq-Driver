 

import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failear.dart';
 
abstract class UpdateProfileRepo {
  Future<Either<Failur, String>> updateProfile({
    required String firstName,
    required String lastName,
    required String governorate,
    String? imagePath,  
  });
}