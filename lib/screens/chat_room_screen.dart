import 'package:flutter/material.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  void _showMediaBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF18222C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 180,
          child: Column(
            children: [
              const Text(
                'مركز الوسائط',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _mediaOption(Icons.camera_alt, 'الكاميرا', Colors.blue, () {}),
                  _mediaOption(Icons.photo, 'المعرض', Colors.green, () {}),
                  _mediaOption(Icons.videocam, 'فيديو', Colors.red, () {}),
                  _mediaOption(Icons.insert_drive_file, 'الملفات', Colors.orange, () {}),
                  _mediaOption(Icons.emoji_emotions, 'ملصقات', Colors.amber, () {}),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _mediaOption(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121822),
      appBar: AppBar(
        backgroundColor: const Color(0xFF18222C),
        iconTheme: const IconThemeData(color: Color(0xFFE5C158)),
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFFE5C158),
              radius: 18,
              child: Icon(Icons.person, color: Colors.black, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('مستخدم الفهد', style: TextStyle(color: Colors.white, fontSize: 16)),
                Text('متصل الآن', style: TextStyle(color: Colors.green, fontSize: 12)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.call), onPressed: () {}),
          IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF18222C),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'السلام عليكم، مرحباً بك في الفهد',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF005C4B),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'وعليكم السلام! تطبيق ممتاز جداً.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            color: const Color(0xFF18222C),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Color(0xFFE5C158)),
                  onPressed: () => _showMediaBottomSheet(context),
                ),
                const Expanded(
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'اكتب رسالة...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.mic, color: Color(0xFFE5C158)),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFFE5C158)),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
