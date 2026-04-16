import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failear.dart';
   
abstract class ChangePasswordRepo {
  Future<Either<Failur, String>> changePassword({required String newPassword});
}