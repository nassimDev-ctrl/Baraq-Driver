  
import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failear.dart';
  
abstract class RepoRegister {
  Future<Either<Failur, dynamic>> register({
    required Map<String, dynamic> userData,
  });
}