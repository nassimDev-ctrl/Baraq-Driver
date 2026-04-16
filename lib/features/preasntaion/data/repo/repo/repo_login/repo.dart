import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failear.dart';
   
abstract class RepoLogin {
  Future<Either<Failur, dynamic>> login({
    required String mobilePhone,
    required String password,
  });
}