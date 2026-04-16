class CarCategoryModel {
  final String? id;
  final String? name;

  CarCategoryModel({this.id, this.name});

  factory CarCategoryModel.fromJson(Map<String, dynamic> json) {
    return CarCategoryModel(
      id: json['_id'],  
      name:
          json['nameAr'] ??
          json['nameEn'],  
    );
  }
}
