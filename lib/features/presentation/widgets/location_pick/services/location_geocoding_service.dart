import 'package:dio/dio.dart';
import 'package:drever_warr/core/models/place_search_result.dart';
import 'package:drever_warr/core/service/place_search_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Address search + reverse geocoding via Nominatim (no Google Places key).
class LocationGeocodingService {
  LocationGeocodingService({PlaceSearchService? placeSearch})
      : _placeSearch = placeSearch ?? PlaceSearchService();

  final PlaceSearchService _placeSearch;
  CancelToken? _autocompleteCancelToken;

  void cancelAutocomplete() => _autocompleteCancelToken?.cancel();

  Future<String?> reverseGeocode(LatLng position) {
    return _placeSearch.reverseGeocode(
      position.latitude,
      position.longitude,
    );
  }

  Future<List<PlaceSearchResult>> autocomplete(String input) async {
    final query = input.trim();
    if (query.isEmpty) return const [];

    _autocompleteCancelToken?.cancel();
    _autocompleteCancelToken = CancelToken();

    return _placeSearch.search(
      query,
      cancelToken: _autocompleteCancelToken,
    );
  }

  Future<({LatLng position, String address})?> geocodeAddress(
    String address,
  ) async {
    final results = await _placeSearch.search(address);
    if (results.isEmpty) return null;

    final first = results.first;
    return (
      position: LatLng(first.latitude, first.longitude),
      address: first.displayName,
    );
  }
}
