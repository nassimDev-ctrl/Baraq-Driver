import 'package:intl/intl.dart';

class FinishedTripModel {
  final String id;
  final String date;
  final String time;
  final String startAddress;
  final String destinationAddress;
  final num totalPrice;
  final num price;
  final num distanceKmMeters;
  final num durationMinutes;
  final num durationInsideCar;
  final num waitingDuration;
  final String paymentWay;
  final String status;
  final double startLat;
  final double startLng;
  final double destinationLat;
  final double destinationLng;
  final String driverName;
  final String driverPhone;
  final String? driverImage;
  final String carName;
  final String carPlateNumber;
  final String? carImage;
  final num commissionAmount;
  final num commissionPercentage;
  final num discount;
  final String? confirmedAt;
  final String? startedAt;
  final String? completedAt;

  FinishedTripModel({
    required this.id,
    required this.date,
    required this.time,
    required this.startAddress,
    required this.destinationAddress,
    required this.totalPrice,
    required this.price,
    required this.startLat,
    required this.startLng,
    required this.destinationLat,
    required this.destinationLng,
    required this.distanceKmMeters,
    required this.durationMinutes,
    required this.durationInsideCar,
    required this.waitingDuration,
    required this.paymentWay,
    required this.status,
    required this.driverName,
    required this.driverPhone,
    this.driverImage,
    required this.carName,
    required this.carPlateNumber,
    this.carImage,
    required this.commissionAmount,
    required this.commissionPercentage,
    required this.discount,
    this.confirmedAt,
    this.startedAt,
    this.completedAt,
  });

  factory FinishedTripModel.fromJson(Map<String, dynamic> json) {
    final createdAt = json['createdAt'] != null
        ? DateTime.parse(json['createdAt']).toLocal()
        : null;

    final Map<String, dynamic> trip =
    _asMap(json['data'])['updatedTrip'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(json['data']['updatedTrip'])
        : json;

    final formattedDate =
    createdAt != null ? DateFormat('d MMM', 'ar').format(createdAt) : '';
    final formattedTime =
    createdAt != null ? DateFormat('hh:mm a').format(createdAt) : '';


    final driverJson = (json['driver'] as Map<String, dynamic>?) ?? {};
    final carJson = (driverJson['car'] as Map<String, dynamic>?) ?? {};

    var dName =
    "${driverJson['firstName'] ?? ''} ${driverJson['lastName'] ?? ''}".trim();
    if (dName.isEmpty) dName = "سفير غير معروف";

    final dPhone = driverJson['emergencyNumber']?.toString() ?? "لا يوجد رقم";

    final cName = carJson['carName']?.toString() ?? "سيارة عامة";
    final cPlate = carJson['carPlateNumber']?.toString() ?? "";
    final cImage = carJson['carImage']?.toString();
    final startLoc = _asMap(trip['startLocation']);
    final destLoc = _asMap(trip['destinationLocation']);
    final startCoords = _asList(startLoc['coordinates']);
    final destCoords = _asList(destLoc['coordinates']);

    return FinishedTripModel(
      id: json['_id']?.toString() ?? '',
      date: formattedDate,
      time: formattedTime,
      startAddress: json['startLocation']?['address']?.toString() ?? 'موقع البداية',
      destinationAddress: json['destinationLocation']?['address']?.toString() ?? 'موقع النهاية',
      totalPrice: json['totalPrice'] ?? 0,
      price: json['price'] ?? 0,
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
      distanceKmMeters: json['distanceKmMeters'] ?? 0,
      durationMinutes: json['durationMinutes'] ?? 0,
      durationInsideCar: json['durationInsideCar'] ?? 0,
      waitingDuration: json['waitingDuration'] ?? 0,
      paymentWay: json['paymentWay']?.toString() ?? 'cash',
      status: json['status']?.toString() ?? '',
      driverName: dName,
      driverPhone: dPhone,
      driverImage: driverJson['profileImage']?.toString(),
      carName: cName,
      carPlateNumber: cPlate,
      carImage: cImage,
      commissionAmount: json['commissionAmount'] ?? 0,
      commissionPercentage: json['commissionPercentage'] ?? 0,
      discount: json['discount'] ?? 0,
      confirmedAt: json['confirmedAt']?.toString(),
      startedAt: json['startedAt']?.toString(),
      completedAt: json['completedAt']?.toString(),
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
}