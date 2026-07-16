class PlaceSearchResult {
  const PlaceSearchResult({
    required this.displayName,
    required this.shortName,
    required this.latitude,
    required this.longitude,
  });

  final String displayName;
  final String shortName;
  final double latitude;
  final double longitude;

  factory PlaceSearchResult.fromNominatimJson(Map<String, dynamic> json) {
    final displayName = json['display_name']?.toString() ?? '';
    final name = json['name']?.toString();
    final shortName = (name != null && name.isNotEmpty)
        ? name
        : displayName.split(',').first.trim();

    return PlaceSearchResult(
      displayName: displayName,
      shortName: shortName.isNotEmpty ? shortName : displayName,
      latitude: double.tryParse(json['lat']?.toString() ?? '') ?? 0,
      longitude: double.tryParse(json['lon']?.toString() ?? '') ?? 0,
    );
  }
}
