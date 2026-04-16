 

 
import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failear.dart';
import 'package:drever_warr/features/preasntaion/data/repo/model/model_governorates.dart';

abstract class RepoGovernorates {
  Future<Either<Failur, List<GovernorateModel>>> fetchGovernorates();
}