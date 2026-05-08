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
  final String? fieldToUpdate;
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

  // 🔽 NEW FIELDS FROM JSON
  final bool? usedOverdraft;
  final int? registrationStep;
  final String? createdAt;
  final String? updatedAt;
  final int? mongoVersion; // maps to __v
  final String? personalCardImageBack;
  final String? personalCardImageFront;
  final AddressModel? driverLocation; // Reuses AddressModel (same structure)
  final List<EvaluationModel>? evaluations;

  ProfileData({
    this.id,
    this.firstName,
    this.lastName,
    this.gender,
    this.city,
    this.emergencyNumber,
    this.status,
    this.fieldToUpdate,
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
    this.usedOverdraft,
    this.registrationStep,
    this.createdAt,
    this.updatedAt,
    this.mongoVersion,
    this.personalCardImageBack,
    this.personalCardImageFront,
    this.driverLocation,
    this.evaluations,
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
      fieldToUpdate: json['fieldToUpdate'],
      frozenBy: json['frozenBy'] is List
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
      // 🔽 NEW MAPPINGS
      usedOverdraft: json['usedOverdraft'],
      registrationStep: json['registrationStep'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      mongoVersion: json['__v'],
      personalCardImageBack: json['personalCardImageBack'],
      personalCardImageFront: json['personalCardImageFront'],
      driverLocation: json['driverLocation'] is Map<String, dynamic>
          ? AddressModel.fromJson(json['driverLocation'])
          : null,
      evaluations: json['evaluations'] is List
          ? (json['evaluations'] as List)
          .map((e) => EvaluationModel.fromJson(e))
          .toList()
          : [],
    );
  }
}

class CarModel {
  final String? category; // 🔽 NEW
  final String? carName;
  final String? carImage;
  final String? carPlateNumber;
  final String? carPlateImage; // 🔽 NEW
  final int? carYearMade;
  final String? carColor;

  CarModel({
    this.category,
    this.carName,
    this.carImage,
    this.carPlateNumber,
    this.carPlateImage,
    this.carYearMade,
    this.carColor,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      category: json['category'],
      carName: json['carName'],
      carImage: json['carImage'],
      carPlateNumber: json['carPlateNumber'],
      carPlateImage: json['carPlateImage'],
      carYearMade: json['carYearMade'],
      carColor: json['carColor'],
    );
  }
}

class AddressModel {
  final String? type; // 🔽 NEW (GeoJSON type, usually "Point")
  final String? address;
  final List<dynamic>? coordinates;

  AddressModel({this.type, this.address, this.coordinates});

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      type: json['type'],
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
  final String? nameKu; // 🔽 NEW
  final bool? status;
  final int? mongoVersion; // 🔽 NEW (maps to __v)

  City({
    this.id,
    this.name,
    this.nameAr,
    this.nameEn,
    this.nameKu,
    this.status,
    this.mongoVersion,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['_id'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
      nameKu: json['nameKu'],
      name: json['nameAr'] ?? json['nameEn'] ?? '',
      status: json['status'],
      mongoVersion: json['__v'],
    );
  }
}

class AuthUser {
  final String? id;
  final String? mobilePhone;
  final String? email;
  // 🔽 NEW FIELDS
  final String? password;
  final List<String>? roles;
  final String? userType;
  final String? language;
  final String? profileId; // maps to "profile" in JSON
  final int? tokenVersion;
  final String? createdAt;
  final String? updatedAt;
  final int? mongoVersion;
  final String? fcmToken;

  AuthUser({
    this.id,
    this.mobilePhone,
    this.email,
    this.password,
    this.roles,
    this.userType,
    this.language,
    this.profileId,
    this.tokenVersion,
    this.createdAt,
    this.updatedAt,
    this.mongoVersion,
    this.fcmToken,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['_id'],
      mobilePhone: json['mobilePhone'],
      email: json['email'],
      password: json['password'],
      roles: json['roles'] is List ? List<String>.from(json['roles']) : [],
      userType: json['userType'],
      language: json['language'],
      profileId: json['profile'],
      tokenVersion: json['tokenVersion'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      mongoVersion: json['__v'],
      fcmToken: json['fcmToken'],
    );
  }
}

// 🔽 NEW MODEL: Evaluations
class EvaluationModel {
  final String? id;
  final String? rating;
  final String? note;
  final String? driverId;
  final String? clientId;
  final String? tripId;
  final String? createdAt;
  final String? updatedAt;
  final int? mongoVersion;

  EvaluationModel({
    this.id,
    this.rating,
    this.note,
    this.driverId,
    this.clientId,
    this.tripId,
    this.createdAt,
    this.updatedAt,
    this.mongoVersion,
  });

  factory EvaluationModel.fromJson(Map<String, dynamic> json) {
    return EvaluationModel(
      id: json['_id'] ?? json['id'],
      rating: json['rating']?.toString(),
      note: json['note'],
      driverId: json['driverId'],
      clientId: json['clientId'],
      tripId: json['tripId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      mongoVersion: json['__v'],
    );
  }
}