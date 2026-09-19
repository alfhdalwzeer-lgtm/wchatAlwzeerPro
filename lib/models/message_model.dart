class MessageModel {
  final String text;
  final bool isMe;
  final String time;
  final bool isRead;

  MessageModel({
    required this.text,
    required this.isMe,
    required this.time,
    this.isRead = false,
  });
}
