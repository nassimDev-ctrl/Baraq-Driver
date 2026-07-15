import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/logging/app_logger.dart';

import 'package:dio/dio.dart';

import 'package:drever_warr/core/service/api_servise.dart';

import 'package:drever_warr/core/service/failear.dart';
import 'dart:developer' as dev;

import 'package:drever_warr/features/home/preasntaion/data/cubit/repo/update_location/repo.dart';

import '../../model/update_location_response_model.dart';

class DriverLocationRepositoryImpl implements DriverLocationRepository {
  final ApiService apiService;

  DriverLocationRepositoryImpl(this.apiService);

  @override
  Future<Either<Failur, UpdateLocationResponseModel>> updateDriverLocation({
    required double longitude,
    required double latitude,
    required String address,
  }) async {
    try {
      dev.log(
        '🚀 [PUT Request] Updating driver location...',
        name: 'DriverLocationRepo',
      );

      final body = {
        "location": {
          "type": "Point",
          "coordinates": [longitude, latitude],
          "address": address,
        }
      };

      dev.log('📤 [Request Body]: $body', name: 'DriverLocationRepo');

      final response = await apiService.put(
        endPoint: '/drivers/update-location',
        data: body,
        isfromdata: false,
      );

      dev.log('✅ [Raw Response]: ${response.data}', name: 'DriverLocationRepo');

      final result = UpdateLocationResponseModel.fromJson(response.data);

      return right(result);
    } catch (e) {
      dev.log(
        '❌ [Catch Error]: ${e.toString()}',
        name: 'DriverLocationRepo',
        error: e,
      );

      return left(ServierFailur(e.toString(), 500));
    }
  }

  @override
  Future<Either<Failur, UpdateLocationResponseModel>> updateDriverLocationForTrip({
    required String tripId,
    required double longitude,
    required double latitude,
    required String address,
  }) async {

    dev.log(
      '🚀 [PUT Request] Updating driver for trip location...',
      name: 'DriverLocationRepo',
    );
    try {
      final body = {
        "location": {
          "type": "Point",
          "coordinates": [longitude, latitude],
          "address": address,
        }
      };

      final response = await apiService.put(
        endPoint: '/drivers/update-location-for-trips/$tripId',
        data: body,
        isfromdata: false,
      );

      final result = UpdateLocationResponseModel.fromJson(response.data);
      return right(result);
    } catch (e) {
      if (e is DioException) {
        AppLogger.debug("ERROR DATA: ${e.response?.data}");
        AppLogger.error("ERROR STATUS: ${e.response?.statusCode}");
      }
      return left(ServierFailur(e.toString(), 500));
    }
  }

  @override
  Future<Either<Failur, UpdateLocationResponseModel>> updateEmergencyLocationForTrip({
    required String tripId,
    required double longitude,
    required double latitude,
    required String address,
  }) async {
    try {

      final Map<String, dynamic> body = {
        "location": {
          "type": "Point",
          "coordinates": [longitude, latitude],
          "address": address,
        }
      };
      AppLogger.debug("body $body");

      final response = await apiService.postdata(
        '/trips/activate-emergency/$tripId',
        data: body,
        isfromdata: false,
        needToken: true,
      );

      final result = UpdateLocationResponseModel.fromJson(response.data);
      return right(result);
    } catch (e) {
      if (e is DioException) {
        AppLogger.debug("ERROR DATA: ${e.response?.data}");
        AppLogger.error("ERROR STATUS: ${e.response?.statusCode}");
      }
      return left(ServierFailur(e.toString(), 500));
    }
  }
}