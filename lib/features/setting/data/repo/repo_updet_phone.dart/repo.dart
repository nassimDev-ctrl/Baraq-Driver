import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failure.dart';
  
abstract class RepoUpdateMobile {
  Future<Either<Failure, String>> confirmPassword(String password);
  Future<Either<Failure, String>> updateMobilePhone(String newMobile,String code);
}