import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failure.dart';

abstract class LogoutRepository {
  Future<Either<Failure, String>> logout();
}