import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failure.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/model/order_model.dart';
 
abstract class RepoSearchingTrips {
  Future<Either<Failure, List<TripModel>>> fetchSearchingTrips();
}