class ActiveTripModel {
  final String id;
  final String clientName;
  final String clientPhone;
  final String sourceAddress;
  final String destinationAddress;
  final double startLat;
  final double startLng;
  final double destinationLat;
  final double destinationLng;
  final double totalPrice;
  final double distance;
  final String status;
  final double durationMinutes;

  ActiveTripModel({
    required this.id,
    required this.clientName,
    required this.clientPhone,
    required this.sourceAddress,
    required this.destinationAddress,
    required this.startLat,
    required this.startLng,
    required this.destinationLat,
    required this.destinationLng,
    required this.totalPrice,
    required this.distance,
    required this.status,
    required this.durationMinutes,
  });

  factory ActiveTripModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> trip =
    _asMap(json['data'])['updatedTrip'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(json['data']['updatedTrip'])
        : json;

    final client = _asMap(trip['client']);
    final startLoc = _asMap(trip['startLocation']);
    final destLoc = _asMap(trip['destinationLocation']);

    final startCoords = _asList(startLoc['coordinates']);
    final destCoords = _asList(destLoc['coordinates']);

    final String name = _buildName(
      client['firstName']?.toString(),
      client['lastName']?.toString(),
      fallback: 'عميل برق',
    );

    final String phone =
        client['emergencyNumber']?.toString() ?? 'بدون رقم';


    return ActiveTripModel(
      id: trip['_id']?.toString() ?? '',
      clientName: name,
      clientPhone: phone,
      sourceAddress: startLoc['address']?.toString() ?? 'غير محدد',
      destinationAddress: destLoc['address']?.toString() ?? 'غير محدد',
      startLat: startCoords.length > 1
          ? (startCoords[1] as num).toDouble()
          : 0.0,
      startLng: startCoords.isNotEmpty
          ? (startCoords[0] as num).toDouble()
          : 0.0,
      destinationLat: destCoords.length > 1
          ? (destCoords[1] as num).toDouble()
          : 0.0,
      destinationLng: destCoords.isNotEmpty
          ? (destCoords[0] as num).toDouble()
          : 0.0,
      totalPrice: (trip['totalPrice'] as num?)?.toDouble() ?? 0.0,
      distance: (trip['distanceKmMeters'] as num?)?.toDouble() ?? 0.0,
      status: trip['status']?.toString() ?? '',
      durationMinutes: (trip['durationMinutes'] as num?)?.toDouble() ?? 0.0,
    );
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    return <String, dynamic>{};
  }

  static List _asList(dynamic value) {
    if (value is List) return value;
    return [];
  }

  static String _buildName(String? first, String? last, {String fallback = ''}) {
    final full = '${first ?? ''} ${last ?? ''}'.trim();
    return full.isEmpty ? fallback : full;
  }
}