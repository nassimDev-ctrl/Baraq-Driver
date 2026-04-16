import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failear.dart';
   
abstract class ConfirmPasswordRepo {
  Future<Either<Failur, dynamic>> confirmPassword({required String password, required String mobilphone});
}