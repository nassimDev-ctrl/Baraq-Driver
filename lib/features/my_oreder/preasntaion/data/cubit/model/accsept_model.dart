 
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
  });

  factory ActiveTripModel.fromJson(Map<String, dynamic> json) {
    
    String name = "عميل واري";
    String phone = "بدون رقم";
    
    if (json['client'] is Map) {
      final client = json['client'];
      name = "${client['firstName'] ?? 'عميل'} ${client['lastName'] ?? 'واري'}";
      phone = client['mobilePhone'] ?? 'بدون رقم';
    }

    final startLoc = json['startLocation'] is Map ? json['startLocation'] : {};
    final destLoc = json['destinationLocation'] is Map ? json['destinationLocation'] : {};

    final List startCoords = startLoc['coordinates'] ?? [0.0, 0.0];
    final List destCoords = destLoc['coordinates'] ?? [0.0, 0.0];

    return ActiveTripModel(
      id: json['_id'] ?? '',
      clientName: name,
      clientPhone: phone,
      sourceAddress: startLoc['address'] ?? 'غير محدد',
      destinationAddress: destLoc['address'] ?? 'غير محدد',
      startLat: startCoords.length > 1 ? (startCoords[1] as num).toDouble() : 0.0,
      startLng: startCoords.length > 0 ? (startCoords[0] as num).toDouble() : 0.0,
      destinationLat: destCoords.length > 1 ? (destCoords[1] as num).toDouble() : 0.0,
      destinationLng: destCoords.length > 0 ? (destCoords[0] as num).toDouble() : 0.0,
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      distance: (json['distanceKmMeters'] ?? 0).toDouble(),
      status: json['status'] ?? '',
    );
  }
}