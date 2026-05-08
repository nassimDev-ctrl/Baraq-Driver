import 'package:intl/intl.dart';

class SingleFinishedTripModel {
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
  final String driverName;
  final String driverPhone;
  final int driverRating;
  final String? driverImage;
  final String clientName;
  final String clientPhone;
  final String carName;
  final String carPlateNumber;
  final String? carImage;
  final num commissionAmount;
  final num commissionPercentage;
  final num discount;
  final String? confirmedAt;
  final String? startedAt;
  final String? completedAt;

  SingleFinishedTripModel({
    required this.id,
    required this.date,
    required this.time,
    required this.startAddress,
    required this.destinationAddress,
    required this.totalPrice,
    required this.price,
    required this.distanceKmMeters,
    required this.durationMinutes,
    required this.durationInsideCar,
    required this.waitingDuration,
    required this.paymentWay,
    required this.status,
    required this.driverName,
    required this.driverPhone,
    required this.driverRating,
    this.driverImage,
    required this.clientName,
    required this.clientPhone,
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

  factory SingleFinishedTripModel.fromJson(Map<String, dynamic> json) {
    final createdAt = json['createdAt'] != null
        ? DateTime.parse(json['createdAt']).toLocal()
        : null;

    final formattedDate =
    createdAt != null ? DateFormat('d MMM', 'ar').format(createdAt) : '';
    final formattedTime =
    createdAt != null ? DateFormat('hh:mm a').format(createdAt) : '';

    final driverJson = (json['driver'] as Map<String, dynamic>?) ?? {};
    final clientJson = (json['client'] as Map<String, dynamic>?) ?? {};
    final carJson = (driverJson['car'] as Map<String, dynamic>?) ?? {};

    var dName =
    "${driverJson['firstName'] ?? ''} ${driverJson['lastName'] ?? ''}".trim();
    if (dName.isEmpty) dName = "سفير غير معروف";
    var clientName =
    "${clientJson['firstName'] ?? ''} ${clientJson['lastName'] ?? ''}".trim();
    if (clientName.isEmpty) clientName = "سفير غير معروف";


    final dPhone = driverJson['emergencyNumber']?.toString() ?? "لا يوجد رقم";
    final dRating = driverJson['rating'] ?? 0;
    final clientNumber = clientJson["authUser"]["mobilePhone"] ?? "لا يوجد رقم";

    final cName = carJson['carName']?.toString() ?? "سيارة عامة";
    final cPlate = carJson['carPlateNumber']?.toString() ?? "";
    final cImage = carJson['carImage']?.toString();

    return SingleFinishedTripModel(
      id: json['_id']?.toString() ?? '',
      date: formattedDate,
      time: formattedTime,
      startAddress: json['startLocation']?['address']?.toString() ?? 'موقع البداية',
      destinationAddress: json['destinationLocation']?['address']?.toString() ?? 'موقع النهاية',
      totalPrice: json['totalPrice'] ?? 0,
      price: json['price'] ?? 0,
      distanceKmMeters: json['distanceKmMeters'] ?? 0,
      durationMinutes: json['durationMinutes'] ?? 0,
      durationInsideCar: json['durationInsideCar'] ?? 0,
      waitingDuration: json['waitingDuration'] ?? 0,
      paymentWay: json['paymentWay']?.toString() ?? 'cash',
      status: json['status']?.toString() ?? '',
      driverName: dName,
      driverPhone: dPhone,
      driverRating: dRating,
      driverImage: driverJson['profileImage']?.toString(),
      clientName: clientName,
      clientPhone: clientNumber,
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
}