import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failear.dart';
 
abstract class RepoProfile {
  Future<Either<Failur, dynamic>> getProfile();
}