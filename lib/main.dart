import 'package:flutter/material.dart';

void main() {
  runApp(const AlWazirChatApp());
}

class AppColors {
  static const Color background = Color(0xFF111827);
  static const Color cardBg = Color(0xFF1F2937);
  static const Color gold = Color(0xFFE5B842);
  static const Color goldDark = Color(0xFF8A6D21);
  static const Color textWhite = Colors.white;
  static const Color textGrey = Colors.grey;
}

class AlWazirChatApp extends StatelessWidget {
  const AlWazirChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Al-Wazir Chat Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.gold,
          surface: AppColors.cardBg,
        ),
      ),
      home: const ChatHomeScreen(),
    );
  }
}

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  final List<Map<String, String>> _messages = [
    {'sender': 'Al-Wazir Support', 'text': 'مرحباً بك في تطبيق الوزير شات برو!', 'time': '10:00 AM'},
  ];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _messages.add({
        'sender': 'أنت',
        'text': _controller.text.trim(),
        'time': '${TimeOfDay.now().hour}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}',
      });
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.cardBg,
        title: const Text(
          'Al-Wazir Chat Pro',
          style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: AppColors.gold),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.videocam, color: AppColors.gold),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg['sender'] == 'أنت';
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: isMe ? AppColors.goldDark : AppColors.cardBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg['sender']!,
                          style: TextStyle(
                            color: isMe ? AppColors.gold : Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          msg['text']!,
                          style: const TextStyle(color: AppColors.textWhite, fontSize: 15),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          msg['time']!,
                          style: const TextStyle(color: AppColors.textGrey, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            color: AppColors.cardBg,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.mic, color: AppColors.gold),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file, color: AppColors.gold),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'اكتب رسالتك هنا...',
                      hintStyle: const TextStyle(color: AppColors.textGrey),
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                CircleAvatar(
                  backgroundColor: AppColors.gold,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: AppColors.background),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
