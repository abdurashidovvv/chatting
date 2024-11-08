class Message {
  final String messageId;
  final String message;
  final String timestamp;
  final String senderId;
  final String receiverId;

  Message({
    required this.messageId,
    required this.message,
    required this.timestamp,
    required this.senderId,
    required this.receiverId,
  });

  Map<String, dynamic> toMap() {
    return {
      'message_id': messageId,
      'content': message,
      'timestamp': timestamp,
      'senderId': senderId,
      'receiverId': receiverId,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      messageId: map['message_id'] as String ?? '',
      message: map['content'] as String? ?? '',
      timestamp: map['timestamp'] as String? ?? '',
      senderId: map['senderId'] as String? ?? '',
      receiverId: map['receiverId'] as String? ?? '',
    );
  }
}
