import 'package:dio/dio.dart';
import 'package:drever_warr/core/models/place_search_result.dart';

class PlaceSearchService {
  PlaceSearchService({Dio? dio}) : _dio = dio ?? _createDio();

  final Dio _dio;

  static Dio _createDio() {
    return Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
  }

  static const _searchUrl = 'https://nominatim.openstreetmap.org/search';
  static const _reverseUrl = 'https://nominatim.openstreetmap.org/reverse';
  static const _userAgent = 'Barq-Driver/1.0';
  static const _minQueryLength = 3;

  /// Syria bounding box: left, top, right, bottom (lon, lat).
  static const _syriaViewbox = '35.60,37.32,42.35,32.31';

  Future<List<PlaceSearchResult>> search(
    String query, {
    CancelToken? cancelToken,
  }) async {
    final trimmed = query.trim();
    if (trimmed.length < _minQueryLength) return [];

    final response = await _dio.get<List<dynamic>>(
      _searchUrl,
      queryParameters: {
        'q': trimmed,
        'format': 'json',
        'addressdetails': '1',
        'limit': 8,
        'countrycodes': 'sy',
        'accept-language': 'ar,en',
        'viewbox': _syriaViewbox,
        'bounded': '1',
      },
      options: Options(
        headers: {'User-Agent': _userAgent},
        responseType: ResponseType.json,
      ),
      cancelToken: cancelToken,
    );

    final data = response.data;
    if (data == null || data.isEmpty) return [];

    return data
        .whereType<Map>()
        .map(
          (item) => PlaceSearchResult.fromNominatimJson(
            item.cast<String, dynamic>(),
          ),
        )
        .where((place) => place.latitude != 0 && place.longitude != 0)
        .toList();
  }

  Future<String?> reverseGeocode(
    double latitude,
    double longitude, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        _reverseUrl,
        queryParameters: {
          'lat': latitude,
          'lon': longitude,
          'format': 'json',
          'accept-language': 'ar,en',
        },
        options: Options(
          headers: {'User-Agent': _userAgent},
          responseType: ResponseType.json,
        ),
        cancelToken: cancelToken,
      );

      final displayName = response.data?['display_name']?.toString().trim();
      if (displayName == null || displayName.isEmpty) return null;
      return displayName;
    } catch (_) {
      return null;
    }
  }
}
