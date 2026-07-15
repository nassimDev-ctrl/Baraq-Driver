class ScheduledTripModel {
  final String id;
  final String? clientName;
  final String? clientPhone;
  final String sourceAddress;
  final String destinationAddress;

  // --- Add these fields ---
  final double startLat;
  final double startLng;
  final double destinationLat;
  final double destinationLng;
  final double distance;
  final double? durationMinutes;
  // -----------------------

  final double totalPrice;
  final String status;
  final String? scheduledDate;

  ScheduledTripModel({
    required this.id,
    this.clientName,
    this.clientPhone,
    required this.sourceAddress,
    required this.destinationAddress,

    // --- Add to constructor ---
    required this.startLat,
    required this.startLng,
    required this.destinationLat,
    required this.destinationLng,
    required this.distance,
    this.durationMinutes,
    // -------------------------

    required this.totalPrice,
    required this.status,
    this.scheduledDate,
  });

  factory ScheduledTripModel.fromJson(Map<String, dynamic> json) {

    String? fullName;
    String? phone;
    if (json['client'] is Map) {
      final client = json['client'];
      final first = client['firstName'] ?? '';
      final last = client['lastName'] ?? '';
      fullName = '$first $last'.trim();
      if (fullName.isEmpty) fullName = "عميل واري";
      phone = client['authUser']['mobilePhone']?.toString() ?? '';
    } else {
      fullName = "عميل واري";
    }

    // Helper to safely extract coordinates
    double getLat(Map<String, dynamic>? loc) {
      if (loc != null && loc['coordinates'] is List && (loc['coordinates'] as List).length >= 2) {
        return _toDouble(loc['coordinates'][1]); // Index 1 is usually Latitude
      }
      return 0.0;
    }

    double getLng(Map<String, dynamic>? loc) {
      if (loc != null && loc['coordinates'] is List && (loc['coordinates'] as List).length >= 2) {
        return _toDouble(loc['coordinates'][0]); // Index 0 is usually Longitude
      }
      return 0.0;
    }

    // Safely extract startLocation and destinationLocation
    final startLoc = json['startLocation'] is Map ? json['startLocation'] : null;
    final destLoc = json['destinationLocation'] is Map ? json['destinationLocation'] : null;

    return ScheduledTripModel(
      id: json['_id']?.toString() ?? '',
      clientName: fullName,
      clientPhone: phone,

      sourceAddress: startLoc != null
          ? (startLoc['address'] ?? "غير محدد")
          : "غير محدد",
      destinationAddress: destLoc != null
          ? (destLoc['address'] ?? "غير محدد")
          : "غير محدد",

      // --- Map the new fields ---
      startLat: getLat(startLoc),
      startLng: getLng(startLoc),
      destinationLat: getLat(destLoc),
      destinationLng: getLng(destLoc),
      distance: _toDouble(json['distanceKmMeters']),
      durationMinutes: _toDouble(json['durationMinutes']),

      // --------------------------

      totalPrice: _toDouble(json['totalPrice']),
      status: json['status']?.toString() ?? '',
      scheduledDate: json['scheduledFor']?.toString(),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}