import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failear.dart';

abstract class TripNoteRepository {
  Future<Either<Failur, String>> fetchTripNote({
    required String tripId,
  });
}