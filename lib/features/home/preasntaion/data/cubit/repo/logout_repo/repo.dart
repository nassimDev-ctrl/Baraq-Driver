import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failear.dart';

abstract class LogoutRepository {
  Future<Either<Failur, String>> logout();
}