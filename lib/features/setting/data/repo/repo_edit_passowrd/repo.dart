import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failure.dart';
   
abstract class ChangePasswordRepo {
  Future<Either<Failure, String>> changePassword({required String newPassword});
}