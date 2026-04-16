import 'package:intl/intl.dart';

class FinishedTripModel {
  final String id;
  final String date;
  final String time;
  final String startAddress;
  final String destinationAddress;
  final num totalPrice;
  final num distance;
  final num durationInsideCar;
  final num waitingDuration;
  final String paymentWay;

  
  final String driverName;
  final String driverPhone;
  final String? driverImage; 

  
  final String carName;
  final String carPlateNumber;

  FinishedTripModel({
    required this.id,
    required this.date,
    required this.time,
    required this.startAddress,
    required this.destinationAddress,
    required this.totalPrice,
    required this.distance,
    required this.durationInsideCar,
    required this.waitingDuration,
    required this.paymentWay,
    required this.driverName,
    required this.driverPhone,
    this.driverImage,
    required this.carName,
    required this.carPlateNumber,
  });

  factory FinishedTripModel.fromJson(Map<String, dynamic> json) {
    
    DateTime? createdAt = json['createdAt'] != null
        ? DateTime.parse(json['createdAt']).toLocal()
        : null;

    String formattedDate = createdAt != null
        ? DateFormat('d MMM', 'ar').format(createdAt)
        : '';
    String formattedTime = createdAt != null
        ? DateFormat('hh:mm a').format(createdAt)
        : '';

    
    var driverJson = json['driver'] ?? {};

   
    String dName =
        "${driverJson['firstName'] ?? ''} ${driverJson['lastName'] ?? ''}"
            .trim();
    if (dName.isEmpty) dName = "سفير غير معروف";

   
    String dPhone =
        driverJson['authUser']?['mobilePhone']?.toString() ?? "لا يوجد رقم";

   
    var carJson = driverJson['car'] ?? {};
    String cName = carJson['carName'] ?? "سيارة عامة";
    String cPlate = carJson['carPlateNumber']?.toString() ?? "";
    String? cImage =
        carJson['carImage'];  
    return FinishedTripModel(
      id: json['_id'] ?? '',
      date: formattedDate,
      time: formattedTime,
      startAddress: json['startLocation']?['address'] ?? 'موقع البداية',
      destinationAddress:
          json['destinationLocation']?['address'] ?? 'موقع النهاية',
      totalPrice: json['totalPrice'] ?? 0,
      distance: json['distanceKmMeters'] ?? 0,
      durationInsideCar: json['durationInsideCar'] ?? 0,
      waitingDuration: json['waitingDuration'] ?? 0,
      paymentWay: json['paymentWay'] ?? 'cash',
      driverName: dName,
      driverPhone: dPhone,
      driverImage: cImage,  
      carName: cName,
      carPlateNumber: cPlate,
    );
  }
}
