class ChatMessageModel {
  final String id;
  final String senderId;   // ← maps to API's "senderId"
  final String receiverId; // ← maps to API's "receiverId"
  final String message;    // ← maps to API's "text"
  final bool seen;
  final DateTime? createdAt;

  const ChatMessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.seen,
    this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['_id'] ?? json['id'] ?? '',
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      message: json['text'] ?? json['message'] ?? '',   // accept both keys
      seen: json['seen'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'senderId': senderId,
    'receiverId': receiverId,
    'text': message,
    'seen': seen,
    'createdAt': createdAt?.toIso8601String(),
  };

  /// Creates a copy with optional overrides — useful for optimistic updates.
  ChatMessageModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? message,
    bool? seen,
    DateTime? createdAt,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      seen: seen ?? this.seen,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}