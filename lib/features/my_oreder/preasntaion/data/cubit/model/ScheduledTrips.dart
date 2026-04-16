class ScheduledTripModel {
  final String id;
  final String? clientName;
  final String? clientPhone;  
  final String sourceAddress;
  final String destinationAddress;
  final double totalPrice;
  final String status;
  final String? scheduledDate;

  ScheduledTripModel({
    required this.id,
    this.clientName,
    this.clientPhone,
    required this.sourceAddress,
    required this.destinationAddress,
    required this.totalPrice,
    required this.status,
    this.scheduledDate,
  });

  factory ScheduledTripModel.fromJson(Map<String, dynamic> json) {
    
    String? fullName;
    String? phone;
    if (json['client'] is Map) {
      final client = json['client'];
      final first = client['firstName'] ?? '';
      final last = client['lastName'] ?? '';
      fullName = '$first $last'.trim();
      if (fullName.isEmpty) fullName = "عميل واري";
      phone = client['mobilePhone']?.toString();
    } else {
      fullName = "عميل واري";
    }

    return ScheduledTripModel(
      id: json['_id']?.toString() ?? '',
      clientName: fullName,
      clientPhone: phone,
    
      sourceAddress: json['startLocation'] is Map 
          ? (json['startLocation']['address'] ?? "غير محدد") 
          : "غير محدد",
      destinationAddress: json['destinationLocation'] is Map 
          ? (json['destinationLocation']['address'] ?? "غير محدد") 
          : "غير محدد",
   
      totalPrice: _toDouble(json['totalPrice']),
      status: json['status']?.toString() ?? '',
    
      scheduledDate: json['createdAt']?.toString(), 
    );
  }

  
  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}