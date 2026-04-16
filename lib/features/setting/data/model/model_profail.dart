 
class ProfileModel {
  final bool? success;
  final String? message;
  final ProfileData? data;

  ProfileModel({this.success, this.message, this.data});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? ProfileData.fromJson(json['data']) : null,
    );
  }
}

 
class ProfileData {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final City? city;
  final String? emergencyNumber;
  final String? status;
  final List<String>? frozenBy;
  final String? profileImage;
  final bool? isBlocked;
  final bool? isFrozen;
  final bool? isAvailable;
  final bool? isRegistrationComplete;
  final num? balance;
  final num? rating;
  final int? numberOfTrips;
  final num? distancePassed;
  final AuthUser? authUser;
  final CarModel? car;  
  final AddressModel? address;  

  ProfileData({
    this.id,
    this.firstName,
    this.lastName,
    this.gender,
    this.city,
    this.emergencyNumber,
    this.status,
    this.frozenBy,
    this.profileImage,
    this.isBlocked,
    this.isFrozen,
    this.isAvailable,
    this.isRegistrationComplete,
    this.balance,
    this.rating,
    this.numberOfTrips,
    this.distancePassed,
    this.authUser,
    this.car,
    this.address,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: json['gender'],
      city: json['city'] is Map<String, dynamic>
          ? City.fromJson(json['city'])
          : null,
      emergencyNumber: json['emergencyNumber'],
      status: json['status'],
      frozenBy: json['frozenBy'] != null
          ? List<String>.from(json['frozenBy'])
          : [],
      profileImage: json['profileImage'],
      isBlocked: json['isBlocked'],
      isFrozen: json['isFrozen'],
      isAvailable: json['isAvailable'],
      isRegistrationComplete: json['isRegistrationComplete'],
      balance: json['balance'],
      rating: json['rating'] ?? 0,
      numberOfTrips: json['numberOfTrips'] ?? 0,
      distancePassed: json['distancePassed'] ?? 0,
      authUser: json['authUser'] is Map<String, dynamic>
          ? AuthUser.fromJson(json['authUser'])
          : null,
      car: json['car'] is Map<String, dynamic>
          ? CarModel.fromJson(json['car'])
          : null,
      address: json['address'] is Map<String, dynamic>
          ? AddressModel.fromJson(json['address'])
          : null,
    );
  }
}

 
class CarModel {
  final String? carName;
  final String? carImage;
  final String? carPlateNumber;
  final int? carYearMade;
  final String? carColor;

  CarModel({
    this.carName,
    this.carImage,
    this.carPlateNumber,
    this.carYearMade,
    this.carColor,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      carName: json['carName'],
      carImage: json['carImage'],
      carPlateNumber: json['carPlateNumber'],
      carYearMade: json['carYearMade'],
      carColor: json['carColor'],
    );
  }
}

 
class AddressModel {
  final String? address;
  final List<dynamic>? coordinates;

  AddressModel({this.address, this.coordinates});

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      address: json['address'],
      coordinates: json['coordinates'],
    );
  }
}

 
class City {
  final String? id;
  final String? name;
  final String? nameAr;
  final String? nameEn;
  final bool? status;

  City({this.id, this.name, this.nameAr, this.nameEn, this.status});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['_id'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
      name: json['nameAr'] ?? json['nameEn'] ?? '',
      status: json['status'],
    );
  }
}

 
class AuthUser {
  final String? id;
  final String? mobilePhone;
  final String? email;

  AuthUser({this.id, this.mobilePhone, this.email});

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['_id'],
      mobilePhone: json['mobilePhone'],
      email: json['email'],
    );
  }
}