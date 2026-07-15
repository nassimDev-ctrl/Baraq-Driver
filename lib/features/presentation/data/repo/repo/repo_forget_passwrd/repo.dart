import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failure.dart';
   
abstract class ConfirmPasswordRepo {
  Future<Either<Failure, dynamic>> confirmPassword({required String password, required String mobilphone});
}