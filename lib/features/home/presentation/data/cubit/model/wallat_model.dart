class WalletResponseModel {
  final num driverBalance;
  final List<WalletOperationModel> operations;

  WalletResponseModel({required this.driverBalance, required this.operations});

  factory WalletResponseModel.fromJson(Map<String, dynamic> json) {
    
    final data = json['operations'] ?? {};
    final list = data['operations'] as List? ?? [];

    return WalletResponseModel(
      driverBalance: data['driverBalance'] ?? 0,
      operations: list.map((e) => WalletOperationModel.fromJson(e)).toList(),
    );
  }
}

class WalletOperationModel {
  final String id;
  final num amount;
  final String type;
  final String date;

  WalletOperationModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.date,
  });

  factory WalletOperationModel.fromJson(Map<String, dynamic> json) {
    return WalletOperationModel(
      id: json['_id'] ?? '',
      amount: json['balance'] ?? 0,  
      type: json['operation'] ?? '',  
      date: json['createdAt'] ?? '',
    );
  }
}