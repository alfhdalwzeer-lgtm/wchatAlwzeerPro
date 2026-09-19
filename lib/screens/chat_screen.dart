import 'package:flutter/material.dart';
import '../models/message_model.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final String? userImage;

  const ChatScreen({Key? key, required this.userName, this.userImage}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool showFileMenu = false;
  bool showStickers = false;
  bool isTyping = false;
  bool isOnline = true;

  final TextEditingController _controller = TextEditingController();
  final List<MessageModel> _messages = [
    MessageModel(text: 'السلام عليكم ورحمة الله', isMe: false, time: '10:30 ص', isRead: true),
    MessageModel(text: 'وعليكم السلام ورحمة الله وبركاته', isMe: true, time: '10:31 ص', isRead: true),
  ];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final newMessage = MessageModel(
      text: _controller.text.trim(),
      isMe: true,
      time: TimeOfDay.now().format(context),
      isRead: false,
    );

    setState(() {
      _messages.add(newMessage);
      _controller.clear();
      showFileMenu = false;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          int index = _messages.indexOf(newMessage);
          if (index != -1) {
            _messages[index] = MessageModel(
              text: newMessage.text,
              isMe: true,
              time: newMessage.time,
              isRead: true,
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: _buildChatAppBar(context),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _messages.length,
                itemBuilder: (context, index) => _buildMessageBubble(_messages[index]),
              ),
            ),
            _buildChatInputArea(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildChatAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: widget.userImage != null ? NetworkImage(widget.userImage!) : null,
            child: widget.userImage == null ? const Icon(Icons.person) : null,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.userName, style: const TextStyle(fontSize: 15)),
              Text(
                isTyping ? 'جاري الكتابة...' : (isOnline ? 'متصل الآن' : 'آخر ظهور اليوم 10:00 ص'),
                style: TextStyle(
                  fontSize: 11,
                  color: isTyping ? Colors.green : Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(icon: const Icon(Icons.videocam_outlined), onPressed: () {}),
        IconButton(icon: const Icon(Icons.phone_outlined), onPressed: () {}),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          color: const Color(0xFF1E2834),
          onSelected: (value) {},
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'contact', child: Text('عرض جهة الاتصال')),
            const PopupMenuItem(value: 'media', child: Text('وسائط وروابط ومستندات')),
            const PopupMenuItem(value: 'search', child: Text('بحث')),
            const PopupMenuItem(value: 'mute', child: Text('كتم الإشعارات')),
            const PopupMenuItem(value: 'disappearing', child: Text('الرسائل ذاتية الاختفاء')),
            const PopupMenuItem(value: 'wallpaper', child: Text('سمة الدردشة')),
            const PopupMenuItem(value: 'clear', child: Text('مسح محتوى الدردشة')),
            const PopupMenuItem(value: 'export', child: Text('نقل الدردشة')),
            const PopupMenuItem(value: 'shortcut', child: Text('إضافة اختصار')),
          ],
        ),
      ],
    );
  }

  Widget _buildMessageBubble(MessageModel msg) {
    return Align(
      alignment: msg.isMe ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: msg.isMe ? const Color(0xFF005C4B) : const Color(0xFF1F2C34),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(msg.text, style: const TextStyle(fontSize: 14, color: Colors.white)),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(msg.time, style: const TextStyle(fontSize: 10, color: Colors.white60)),
                if (msg.isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    msg.isRead ? Icons.done_all : Icons.done,
                    size: 15,
                    color: msg.isRead ? Colors.blue : Colors.white60,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatInputArea() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F2C34),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
                        onPressed: () => setState(() => showStickers = !showStickers),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onChanged: (text) => setState(() => isTyping = text.isNotEmpty),
                          decoration: const InputDecoration(
                            hintText: 'الرسالة',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.attach_file, color: Colors.grey),
                        onPressed: () => setState(() => showFileMenu = !showFileMenu),
                      ),
                      IconButton(
                        icon: const Icon(Icons.camera_alt_outlined, color: Colors.grey),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 6),
              CircleAvatar(
                backgroundColor: const Color(0xFF00A884),
                radius: 22,
                child: IconButton(
                  icon: Icon(_controller.text.isNotEmpty ? Icons.send : Icons.mic, color: Colors.white),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) _sendMessage();
                  },
                ),
              ),
            ],
          ),
        ),
        if (showStickers) Container(height: 200, color: const Color(0xFF121B22), child: const Center(child: Text('لوحة الملصقات'))),
      ],
    );
  }
}
