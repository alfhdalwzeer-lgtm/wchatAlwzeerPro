import 'package:flutter/material.dart';

// نموذج يمثل بيانت الرسالة
class MessageModel {
  final String text;
  final bool isMe; // هل الرسالة صادرة أم واردة
  final String time;
  final bool isRead; // هل تم الاستلام/القرءاة

  MessageModel({
    required this.text,
    required this.isMe,
    required this.time,
    this.isRead = false,
  });
}

class ChatScreen extends StatefulWidget {
  final String userName;
  final String? userImage;

  const ChatScreen({
    Key? key,
    required this.userName,
    this.userImage,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool showFileMenu = false;
  bool showStickers = false; // لوحة الملصقات
  bool isTyping = false; // حالة "جاري الكتابة..."
  bool isOnline = true; // حالة "متصل الآن"

  final TextEditingController _controller = TextEditingController();

  // قائمة تخزين الرسائل
  final List<MessageModel> _messages = [
    MessageModel(text: 'السلام عليكم ورحمة الله', isMe: false, time: '10:30 ص', isRead: true),
    MessageModel(text: 'وعليكم السلام ورحمة الله وبركاته', isMe: true, time: '10:31 ص', isRead: true),
  ];

  // دالة إرسال الرسالة وتخزينها
  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final newMessage = MessageModel(
      text: _controller.text.trim(),
      isMe: true,
      time: TimeOfDay.now().format(context),
      isRead: false, // تبدأ بعلامة صح واحدة عند الإرسال
    );

    setState(() {
      _messages.add(newMessage);
      _controller.clear();
      showFileMenu = false;
    });

    // محاكاة استلام الرسالة (تتحول إلى ✓✓ بعد ثوانٍ)
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          int index = _messages.indexOf(newMessage);
          if (index != -1) {
            _messages[index] = MessageModel(
              text: newMessage.text,
              isMe: true,
              time: newMessage.time,
              isRead: true, // تتحول إلى صحين
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
            // 1. منطقة عرض وتخزين الرسائل
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return _buildMessageBubble(msg);
                },
              ),
            ),

            // 2. منطقة إدخال الرسائل والمرفقات والملصقات
            _buildChatInputArea(),
          ],
        ),
      ),
    );
  }

  // شريط العنوان العلوي مع حالة "متصل الآن" / "جاري الكتابة..."
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
            backgroundImage: widget.userImage != null
                ? NetworkImage(widget.userImage!)
                : null,
            child: widget.userImage == null ? const Icon(Icons.person) : null,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.userName, style: const TextStyle(fontSize: 15)),
              Text(
                isTyping
                    ? 'جاري الكتابة...'
                    : (isOnline ? 'متصل الآن' : 'آخر ظهور اليوم 10:00 ص'),
                style: TextStyle(
                  fontSize: 11,
                  color: isTyping ? Colors.green : Colors.grey.shade600,
                  fontWeight: isTyping ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.phone_outlined),
          offset: const Offset(0, 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onSelected: (value) {},
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'audio',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('مكالمة صوتية'),
                  Icon(Icons.phone_outlined, color: Colors.black54),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'video',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('مكالمة فيديو'),
                  Icon(Icons.videocam_outlined, color: Colors.black54),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'link',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('إرسال رابط المكالمة'),
                  Icon(Icons.link, color: Colors.black54),
                ],
              ),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ],
    );
  }

  // فقاعة الرسالة المصممة لمؤشرات الإرسال الاستلام (✓ / ✓✓)
  Widget _buildMessageBubble(MessageModel msg) {
    return Align(
      alignment: msg.isMe ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: msg.isMe ? const Color(0xFFE7FFDB) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 3,
              offset: const Offset(0, 1),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              msg.text,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  msg.time,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                if (msg.isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    msg.isRead ? Icons.done_all : Icons.done,
                    size: 15,
                    color: msg.isRead ? Colors.blue : Colors.grey,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  // شريط الإدخال وأدوات المرفقات
  Widget _buildChatInputArea() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 22,
                    child: IconButton(
                      icon: Icon(
                        _controller.text.isNotEmpty ? Icons.send : Icons.mic,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          _sendMessage();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.keyboard_alt_outlined, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                showStickers = !showStickers;
                              });
                            },
                          ),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              onChanged: (text) {
                                setState(() {
                                  // إرسال إشارة جاري الكتابة
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: 'الرسالة',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.attach_file, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                showFileMenu = !showFileMenu;
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.camera_alt_outlined, color: Colors.grey),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (showFileMenu)
              Positioned(
                bottom: 55,
                left: 110,
                child: Material(
                  elevation: 4,
                  color: const Color(0xFF1E2834),
                  borderRadius: BorderRadius.circular(6),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        showFileMenu = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.insert_drive_file_outlined, color: Colors.white, size: 22),
                          SizedBox(height: 2),
                          Text('ملف', style: TextStyle(color: Colors.white, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (showStickers) _buildStickerPanel(),
      ],
    );
  }

  // لوحة الملصقات والإيموجي
  Widget _buildStickerPanel() {
    return Container(
      height: 250,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(icon: const Icon(Icons.search, size: 22), onPressed: () {}),
                IconButton(icon: const Icon(Icons.sentiment_satisfied_alt, size: 22), onPressed: () {}),
                const Text('GIF', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
                IconButton(icon: const Icon(Icons.sticky_note_2_outlined, color: Colors.black, size: 22), onPressed: () {}),
                IconButton(icon: const Icon(Icons.edit_outlined, size: 22), onPressed: () {}),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 8,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(height: 4),
                        Text('إنشاء\nملصق', textAlign: TextAlign.center, style: TextStyle(fontSize: 11)),
                      ],
                    ),
                  );
                }
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text('ملصق $index'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
