class DriverAvailabilityResponseModel {
  final bool success;
  final DriverAvailabilityDataModel data;

  DriverAvailabilityResponseModel({
    required this.success,
    required this.data,
  });

  factory DriverAvailabilityResponseModel.fromJson(Map<String, dynamic> json) {
    return DriverAvailabilityResponseModel(
      success: json['success'] ?? false,
      data: DriverAvailabilityDataModel.fromJson(json['data'] ?? {}),
    );
  }
}

class DriverAvailabilityDataModel {
  final String id;
  final bool isAvailable;

  DriverAvailabilityDataModel({
    required this.id,
    required this.isAvailable,
  });

  factory DriverAvailabilityDataModel.fromJson(Map<String, dynamic> json) {
    return DriverAvailabilityDataModel(
      id: json['_id'] ?? json['id'] ?? '',
      isAvailable: json['isAvailable'] ?? false,
    );
  }
}