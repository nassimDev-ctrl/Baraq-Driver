class GovernorateModel {
  final String id;
  final String name;
  final String? nameEn;
  final bool status;
  final int? numberOfVipCars;

  GovernorateModel({
    required this.id,
    required this.name,
    this.nameEn,
    required this.status,
    this.numberOfVipCars,
  });

  factory GovernorateModel.fromJson(Map<String, dynamic> json) {
    return GovernorateModel(
      id: json['_id']?.toString() ?? '',
      name: json['nameAr']?.toString() ??
          json['name']?.toString() ??
          json['nameEn']?.toString() ??
          '',
      nameEn: json['nameEn']?.toString(),
      status: json['status'] as bool? ?? true,
      numberOfVipCars: json['numberOfVipCars'] as int? ?? 0,
    );
  }
}
