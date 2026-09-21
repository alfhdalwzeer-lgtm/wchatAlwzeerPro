cd ~/wchatAlwzeerPro && cat > lib/models/message_model.dart <<'EOF'
class MessageModel {
  final int? id;
  final String chatId;
  final String text;
  final bool isMe;
  final String time;
  final bool isRead;
  final String type;
  final String? filePath;
  final String? fileName;

  MessageModel({
    this.id,
    required this.chatId,
    required this.text,
    required this.isMe,
    required this.time,
    this.isRead = false,
    this.type = 'text',
    this.filePath,
    this.fileName,
  });
}
EOF
