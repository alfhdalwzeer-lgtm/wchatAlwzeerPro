import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const AlWazirChatApp());
}

class AlWazirChatApp extends StatelessWidget {
  const AlWazirChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'تطبيق الفهد',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF111B21),
        primaryColor: const Color(0xFFFFD700),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 3;

  final List<Widget> _screens = const [
    StatusScreen(),
    CallsScreen(),
    GroupsScreen(),
    ChatsListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2C34),
        title: const Text(
          'الفهد',
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Color(0xFFFFD700)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFFFFD700)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFFFFD700)),
            onPressed: () {},
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: const Color(0xFF1F2C34),
        selectedItemColor: const Color(0xFFFFD700),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.circle_outlined),
            label: 'الحالة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'المكالمات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: 'المجموعات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'الدردشات',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFD700),
        child: const Icon(Icons.message, color: Color(0xFF111B21)),
        onPressed: () {},
      ),
    );
  }
}

class ChatsListScreen extends StatelessWidget {
  const ChatsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const CircleAvatar(
            backgroundColor: Color(0xFF1F2C34),
            child: Icon(Icons.person, color: Color(0xFFFFD700)),
          ),
          title: const Text(
            'مستخدم الفهد',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: const Text(
            'اضغط لبدء المحادثة المحفوظة...',
            style: TextStyle(color: Colors.grey),
          ),
          trailing: const Text(
            'الآن',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatDetailScreen()),
            );
          },
        ),
      ],
    );
  }
}

// شاشة المحادثة مع ميزة الحفظ المحلي (Local Storage)
class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  // تحميل الرسائل المحفوظة محلياً
  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final String? messagesString = prefs.getString('saved_chat_messages');
    if (messagesString != null) {
      setState(() {
        _messages = List<Map<String, String>>.from(
          json.decode(messagesString).map((item) => Map<String, String>.from(item)),
        );
      });
    } else {
      // رسائل افتراضية أولية
      _messages = [
        {'sender': 'them', 'text': 'السلام عليكم، مرحباً بك في تطبيق الفهد'},
        {'sender': 'me', 'text': 'وعليكم السلام! تم تفعيل الحفظ المحلي بنجاح.'},
      ];
      _saveMessages();
    }
  }

  // حفظ الرسائل محلياً
  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('saved_chat_messages', json.encode(_messages));
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'sender': 'me',
        'text': _controller.text.trim(),
      });
    });

    _controller.clear();
    _saveMessages(); // الحفظ الفوري
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2C34),
        title: Row(
          children: const [
            CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFFFD700),
              child: Icon(Icons.person, color: Color(0xFF111B21), size: 20),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('مستخدم الفهد', style: TextStyle(fontSize: 16, color: Colors.white)),
                Text('متصل الآن (محفوظ محلياً)', style: TextStyle(fontSize: 11, color: Color(0xFFFFD700))),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.videocam, color: Color(0xFFFFD700)), onPressed: () {}),
          IconButton(icon: const Icon(Icons.call, color: Color(0xFFFFD700)), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert, color: Color(0xFFFFD700)), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message['sender'] == 'me';
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF005C4B) : const Color(0xFF1F2C34),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      message['text'] ?? '',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: const Color(0xFF1F2C34),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Color(0xFFFFD700)),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: const Color(0xFF1F2C34),
                      builder: (context) => Container(
                        padding: const EdgeInsets.all(20),
                        height: 180,
                        child: Column(
                          children: [
                            const Text('مركز الوسائط', style: TextStyle(color: Color(0xFFFFD700), fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _mediaOption(Icons.camera_alt, 'الكاميرا'),
                                _mediaOption(Icons.image, 'المعرض'),
                                _mediaOption(Icons.videocam, 'فيديو'),
                                _mediaOption(Icons.insert_drive_file, 'الملفات'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'اكتب رسالة...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFFFFD700)),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mediaOption(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xFF111B21),
          child: Icon(icon, color: const Color(0xFFFFD700)),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('شاشة الحالة', style: TextStyle(color: Colors.white)));
  }
}

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('شاشة المكالمات', style: TextStyle(color: Colors.white)));
  }
}

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('شاشة المجموعات', style: TextStyle(color: Colors.white)));
  }
}
