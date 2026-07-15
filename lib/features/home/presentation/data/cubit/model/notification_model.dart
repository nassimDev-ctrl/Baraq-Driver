class NotificationResponseModel {
  final List<NotificationItemModel> notifications;

  NotificationResponseModel({required this.notifications});

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    final list = json['notifications'] as List? ?? [];
    return NotificationResponseModel(
      notifications:
          list.map((e) => NotificationItemModel.fromJson(e)).toList(),
    );
  }
}

class NotificationItemModel {
  final String id;
  final String titleEn;
  final String titleAr;
  final String titleKu;
  final String messageEn;
  final String messageAr;
  final String messageKu;
  final String usersType;
  final String createdAt;

  NotificationItemModel({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.titleKu,
    required this.messageEn,
    required this.messageAr,
    required this.messageKu,
    required this.usersType,
    required this.createdAt,
  });

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) {
    return NotificationItemModel(
      id: json['_id'] ?? '',
      titleEn: json['titleEn'] ?? '',
      titleAr: json['titleAr'] ?? '',
      titleKu: json['titleKu'] ?? '',
      messageEn: json['messageEn'] ?? '',
      messageAr: json['messageAr'] ?? '',
      messageKu: json['messageKu'] ?? '',
      usersType: json['usersType'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }

  String getTitle(String lang) {
    switch (lang) {
      case 'en':
        return titleEn;
      case 'ku':
        return titleKu;
      default:
        return titleAr;
    }
  }

  String getMessage(String lang) {
    switch (lang) {
      case 'en':
        return messageEn;
      case 'ku':
        return messageKu;
      default:
        return messageAr;
    }
  }
}
