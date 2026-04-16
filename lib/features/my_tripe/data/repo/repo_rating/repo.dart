import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failear.dart';
 
abstract class AddRatingRepo {
  Future<Either<Failur, Map<String, dynamic>>> addRating({
    required String tripId,
    required String note,
    required int rating,
  });
}