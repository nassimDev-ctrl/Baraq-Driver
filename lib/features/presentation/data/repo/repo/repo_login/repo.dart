import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failure.dart';

abstract class RepoLogin {
  Future<Either<Failure, dynamic>> login({
    required String mobilePhone,
    required String password,
  });
}
