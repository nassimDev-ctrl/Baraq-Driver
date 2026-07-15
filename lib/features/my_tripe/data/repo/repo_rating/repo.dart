import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failure.dart';
 
abstract class AddRatingRepo {
  Future<Either<Failure, Map<String, dynamic>>> addRating({
    required String tripId,
    required String note,
    required int rating,
  });
}