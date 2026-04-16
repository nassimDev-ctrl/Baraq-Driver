import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failear.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/model/order_model.dart';
 
abstract class RepoSearchingTrips {
  Future<Either<Failur, List<TripModel>>> fetchSearchingTrips();
}