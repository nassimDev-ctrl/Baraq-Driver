import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/features/presentation/widgets/location_pick/location_gps_metrics.dart';
import 'package:flutter/material.dart';

class LocationAddressParts {
  const LocationAddressParts({
    required this.areaName,
    required this.cityName,
    required this.fullAddress,
  });

  final String areaName;
  final String cityName;
  final String fullAddress;
}

LocationAddressParts parseAddressParts(String address) {
  final trimmed = address.trim();
  if (trimmed.isEmpty) {
    return const LocationAddressParts(
      areaName: '',
      cityName: '',
      fullAddress: '',
    );
  }

  final parts = trimmed
      .split(',')
      .map((part) => part.trim())
      .where((part) => part.isNotEmpty)
      .toList();

  return LocationAddressParts(
    areaName: parts.isNotEmpty ? parts.first : trimmed,
    cityName: parts.length > 1 ? parts[1] : '',
    fullAddress: trimmed,
  );
}

String signalQualityLabel(BuildContext context, double? accuracyMeters) {
  final quality = LocationGpsMetrics.qualityFromAccuracy(accuracyMeters);
  return AppTranslations.getText(
    context,
    LocationGpsMetrics.qualityTranslationKey(quality),
  );
}

String formatAccuracyMeters(double? accuracyMeters) {
  return LocationGpsMetrics.formatAccuracyMeters(accuracyMeters);
}
