class MessageModel {
  String messageId = '';
  String senderId = '';
  String receiverId = '';
  String dateTime = '';
  String message = '';
  String image = '';

  MessageModel({
    required this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.dateTime,
    required this.message,
    this.image = '',
  });

  MessageModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    messageId = json['messageId'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    dateTime = json['dateTime'];
    message = json['message'];
    image = json['image'];
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'receiverId': receiverId,
      'dateTime': dateTime,
      'message': message,
      'image': image,
    };
  }
}
