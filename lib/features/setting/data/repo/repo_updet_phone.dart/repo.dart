import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failear.dart';
  
abstract class RepoUpdateMobile {
  Future<Either<Failur, String>> confirmPassword(String password);
  Future<Either<Failur, String>> updateMobilePhone(String newMobile,String code);
}