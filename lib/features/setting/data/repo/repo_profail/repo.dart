import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failure.dart';
 
abstract class RepoProfile {
  Future<Either<Failure, dynamic>> getProfile();
}