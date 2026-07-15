  
import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failure.dart';
  
abstract class RepoRegister {
  Future<Either<Failure, dynamic>> register({
    required Map<String, dynamic> userData,
  });
}