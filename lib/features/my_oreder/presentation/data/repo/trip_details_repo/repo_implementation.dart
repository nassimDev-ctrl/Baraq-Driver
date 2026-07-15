import 'dart:developer' as dev;
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drever_warr/core/service/api_service.dart';
import 'package:drever_warr/core/service/failure.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/repo/trip_details_repo/repo.dart';

import '../../models/trip_response_model.dart';

class TripDetailsRepositoryImpl implements TripDetailsRepository {
  final ApiService apiService;

  TripDetailsRepositoryImpl(this.apiService);

  @override
  Future<Either<Failure, TripResponseModel>> getTripDetails({
    required String tripId,
  }) async {
    try {
      dev.log('🚀 [PUT Request] Fetching trip details...', name: 'TripDetailsRepo');
      dev.log('🆔 Trip ID: $tripId', name: 'TripDetailsRepo');

      final response = await apiService.get(
        endpoint: '/trips/get-trip/$tripId',
        needToken: true,

      );

      dev.log('✅ [Raw Response]: ${response.data}', name: 'TripDetailsRepo');

      final tripData = TripResponseModel.fromJson(response.data);

      dev.log('📍 Trip Status: ${tripData.data.status}', name: 'TripDetailsRepo');

      return right(tripData);
    } catch (e) {
      dev.log('❌ [Catch Error]: ${e.toString()}', name: 'TripDetailsRepo', error: e);

      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }

      return left(ServerFailure(e.toString(), 500));
    }
  }

  @override
  Future<Either<Failure, bool>> isClientConfirmed({
    required String tripId,
  }) async {
    final result = await getTripDetails(tripId: tripId);

    return result.fold(
          (failure) => left(failure),
          (trip) => right(trip.data.status == 'client_confirmed'),
    );
  }
}