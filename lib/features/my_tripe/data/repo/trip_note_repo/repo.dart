import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failure.dart';

abstract class TripNoteRepository {
  Future<Either<Failure, String>> fetchTripNote({
    required String tripId,
  });
}