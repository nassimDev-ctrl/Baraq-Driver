import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failure.dart';
   
abstract class VerificationRepo {
  Future<Either<Failure, dynamic>> createVerificationCode({
    required String mobilePhone,
    required String typeOfUse,
  });
  Future<Either<Failure, dynamic>> verifyMobileNumber({
    required String mobilePhone,
    required String typeOfUse,
    required String code,
  });
}