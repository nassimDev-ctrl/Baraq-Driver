class TripResponseModel {
  final bool success;
  final TripDataModel data;

  TripResponseModel({
    required this.success,
    required this.data,
  });

  factory TripResponseModel.fromJson(Map<String, dynamic> json) {
    return TripResponseModel(
      success: json['success'] ?? false,
      data: TripDataModel.fromJson(json['data'] ?? {}),
    );
  }
}

class TripDataModel {
  final String id;
  final String status;
  final String paymentWay;
  final num price;
  final num totalPrice;
  final num distanceKmMeters;
  final num durationMinutes;
  final bool isScheduled;
  final String scheduledStatus;
  final String? confirmedAt;
  final String? startedAt;
  final String? completedAt;

  final TripUserModel? client;
  final TripUserModel? driver;
  final Map<String, dynamic>? car;
  final Map<String, dynamic>? startLocation;
  final Map<String, dynamic>? destinationLocation;
  final Map<String, dynamic>? emergency;

  TripDataModel({
    required this.id,
    required this.status,
    required this.paymentWay,
    required this.price,
    required this.totalPrice,
    required this.distanceKmMeters,
    required this.durationMinutes,
    required this.isScheduled,
    required this.scheduledStatus,
    required this.confirmedAt,
    required this.startedAt,
    required this.completedAt,
    required this.client,
    required this.driver,
    required this.car,
    required this.startLocation,
    required this.destinationLocation,
    required this.emergency,
  });

  factory TripDataModel.fromJson(Map<String, dynamic> json) {
    return TripDataModel(
      id: json['_id'] ?? '',
      status: json['status'] ?? '',
      paymentWay: json['paymentWay'] ?? '',
      price: json['price'] ?? 0,
      totalPrice: json['totalPrice'] ?? 0,
      distanceKmMeters: json['distanceKmMeters'] ?? 0,
      durationMinutes: json['durationMinutes'] ?? 0,
      isScheduled: json['isScheduled'] ?? false,
      scheduledStatus: json['scheduledStatus'] ?? '',
      confirmedAt: json['confirmedAt'],
      startedAt: json['startedAt'],
      completedAt: json['completedAt'],
      client: json['client'] != null
          ? TripUserModel.fromJson(json['client'])
          : null,
      driver: json['driver'] != null
          ? TripUserModel.fromJson(json['driver'])
          : null,
      car: json['car'],
      startLocation: json['startLocation'],
      destinationLocation: json['destinationLocation'],
      emergency: json['emergency'],
    );
  }
}

class TripUserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String? authUser;
  final String? profileImage;
  final String? mobilePhone;

  TripUserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.authUser,
    required this.profileImage,
    required this.mobilePhone,
  });

  factory TripUserModel.fromJson(Map<String, dynamic> json) {
    final authUser = json['authUser'];

    return TripUserModel(
      id: json['_id'] ?? json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      authUser: authUser is String ? authUser : authUser?['_id'],
      profileImage: json['profileImage'],
      mobilePhone: json['mobilePhone'],
    );
  }

  String get fullName => '$firstName $lastName'.trim();
}