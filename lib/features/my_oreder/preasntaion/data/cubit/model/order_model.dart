 
class TripModel {
  final String id;
  final String? clientName;
  final String? clientPhone;
  final String sourceAddress;
  final String destinationAddress;
  final double price;
  final double totalPrice;
  final double distance;
  final double durationMinutes;
  final String status;
 
  final double startLat;
  final double startLng;
  final double destinationLat;
  final double destinationLng;

  TripModel({
    required this.id,
    this.clientName,
    this.clientPhone,
    required this.sourceAddress,
    required this.destinationAddress,
    required this.price,
    required this.totalPrice,
    required this.distance,
    required this.durationMinutes,
    required this.status,
    required this.startLat,
    required this.startLng,
    required this.destinationLat,
    required this.destinationLng,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
     
    List startCoords = json['startLocation']?['coordinates'] ?? [0.0, 0.0];
    List endCoords = json['destinationLocation']?['coordinates'] ?? [0.0, 0.0];


    return TripModel(
      id: json['_id'] ?? '',
      clientName: json['client'] is Map 
          ? (json['client']['firstName'] ?? "عميل") 
          : "عميل واري",
      clientPhone: json['client'] is Map
          ? (json['client']['mobilePhone'] ?? "")
          : "",
      sourceAddress: json['startLocation']?['address'] ?? "غير محدد",
      destinationAddress: json['destinationLocation']?['address'] ?? "غير محدد",
      price: (json['price'] ?? 0).toDouble(),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      distance: (json['distanceKmMeters'] ?? 0).toDouble(),
      durationMinutes: (json['durationMinutes'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      // تعيين الإحداثيات
      startLat: startCoords.length > 1 ? startCoords[1].toDouble() : 0.0,
      startLng: startCoords.length > 0 ? startCoords[0].toDouble() : 0.0,
      destinationLat: endCoords.length > 1 ? endCoords[1].toDouble() : 0.0,
      destinationLng: endCoords.length > 0 ? endCoords[0].toDouble() : 0.0,
    );
  }
}