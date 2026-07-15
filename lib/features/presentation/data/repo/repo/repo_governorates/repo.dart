 

 
import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failure.dart';
import 'package:drever_warr/features/presentation/data/repo/model/model_governorates.dart';

abstract class RepoGovernorates {
  Future<Either<Failure, List<GovernorateModel>>> fetchGovernorates();
}