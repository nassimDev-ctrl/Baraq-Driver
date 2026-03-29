class GovernorateModel {
  final String id;
  final String name;
  final bool status;
  final int? numberOfVipCars;

  GovernorateModel({
    required this.id,
    required this.name,
    required this.status,
    this.numberOfVipCars,
  });

  factory GovernorateModel.fromJson(Map<String, dynamic> json) {
    return GovernorateModel(
      id: json['_id'],
      name: json['name'],
      status: json['status'],
      numberOfVipCars: json['numberOfVipCars'] ?? 0,
    );
  }
}