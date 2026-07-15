class UpdateLocationResponseModel {
  final bool success;
  final DriverDataModel data;

  UpdateLocationResponseModel({
    required this.success,
    required this.data,
  });

  factory UpdateLocationResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateLocationResponseModel(
      success: json['success'] ?? false,
      data: DriverDataModel.fromJson(json['data']),
    );
  }
}

class DriverDataModel {
  final String id;
  final String firstName;
  final String lastName;
  final bool isAvailable;
  final int balance;
  final String status;
  final DriverLocationModel driverLocation;

  DriverDataModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.isAvailable,
    required this.balance,
    required this.status,
    required this.driverLocation,
  });

  factory DriverDataModel.fromJson(Map<String, dynamic> json) {
    return DriverDataModel(
      id: json['_id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      isAvailable: json['isAvailable'] ?? false,
      balance: json['balance'] ?? 0,
      status: json['status'] ?? '',
      driverLocation: DriverLocationModel.fromJson(json['driverLocation'] ?? {}),
    );
  }
}

class DriverLocationModel {
  final String type;
  final List<double> coordinates;
  final String address;

  DriverLocationModel({
    required this.type,
    required this.coordinates,
    required this.address,
  });

  factory DriverLocationModel.fromJson(Map<String, dynamic> json) {
    return DriverLocationModel(
      type: json['type'] ?? 'Point',
      coordinates: (json['coordinates'] as List<dynamic>? ?? [])
          .map((e) => (e as num).toDouble())
          .toList(),
      address: json['address'] ?? '',
    );
  }
}