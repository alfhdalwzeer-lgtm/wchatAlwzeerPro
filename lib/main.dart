import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

void main() {
  runApp(const AlWazirChatApp());
}

class AlWazirChatApp extends StatelessWidget {
  const AlWazirChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Al-Wazir Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF111B21),
        primaryColor: const Color(0xFF00A884),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F2C34),
          elevation: 0,
        ),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  // ترتيب التبويبات من اليمين لليسار كما طلبت: الدردشات، المجموعات، المكالمات، التحديثات
  final List<Widget> _screens = [
    const ChatsScreen(),
    const GroupsScreen(),
    const CallsScreen(),
    const UpdatesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1F2C34),
        selectedItemColor: const Color(0xFF00A884),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'الدردشات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'المجموعات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'المكالمات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.update),
            label: 'التحديثات',
          ),
        ],
      ),
    );
  }
}

// 1. شاشة الدردشات
class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Al-Wazir Chat 👑'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFF00A884),
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text('مستخدم رقم ${index + 1}'),
            subtitle: const Text('أهلاً بك، تم إرسال الرسالة بنجاح...'),
            trailing: const Text('19:19', style: TextStyle(color: Colors.grey, fontSize: 12)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatDetailScreen()),
              );
            },
          );
        },
      ),
    );
  }
}

// 2. شاشة تفاصيل الدردشة (تحتوي على خيارات الاتصال، الملصقات، وإرسال مستند أو تطبيق)
class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({Key? key}) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _showEmojiPicker = false;

  void _showAttachmentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F2C34),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 220,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAttachmentOption(Icons.insert_drive_file, Colors.indigo, 'مستند', () {}),
              _buildAttachmentOption(Icons.android, Colors.green, 'تطبيق APK', () {}),
              _buildAttachmentOption(Icons.image, Colors.purple, 'الصور', () {}),
              _buildAttachmentOption(Icons.camera_alt, Colors.pink, 'الكاميرا', () {}),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption(IconData icon, Color color, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('محادثة احترافية'),
        actions: [
          // قائمة الاتصال الصوتية والفيديو ورابط المكالمة
          PopupMenuButton<String>(
            icon: const Icon(Icons.phone_outlined),
            onSelected: (value) {
              // تنفيذ إجراء الاتصال المحدد
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'audio', child: ListTile(leading: Icon(Icons.phone), title: Text('مكالمة صوتية'))),
              const PopupMenuItem(value: 'video', child: ListTile(leading: Icon(Icons.videocam), title: Text('مكالمة فيديو'))),
              const PopupMenuItem(value: 'link', child: ListTile(leading: Icon(Icons.link), title: Text('إرسال رابط المكالمة'))),
            ],
          ),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: const [
                Center(child: Text('أصبحت الرسائل والمكالمات مشفرة بين الطرفين', style: TextStyle(color: Colors.grey, fontSize: 11))),
              ],
            ),
          ),
          // شريط إدخال الرسائل
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            color: const Color(0xFF1F2C34),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A3942),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              _showEmojiPicker = !_showEmojiPicker;
                            });
                          },
                        ),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              hintText: 'اكتب رسالتك...',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.attach_file, color: Colors.grey),
                          onPressed: () => _showAttachmentSheet(context),
                        ),
                        IconButton(
                          icon: const Icon(Icons.camera_alt, color: Colors.grey),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const CircleAvatar(
                  backgroundColor: Color(0xFF00A884),
                  child: Icon(Icons.mic, color: Colors.white),
                ),
              ],
            ),
          ),
          // لوحة الملصقات والإيموجي عند التفعيل
          if (_showEmojiPicker)
            SizedBox(
              height: 250,
              child: EmojiPicker(
                textEditingController: _controller,
                config: const Config(
                  columns: 7,
                  emojiSizeMax: 32,
                  bgColor: Color(0xFF111B21),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// 3. شاشة المجموعات
class GroupsScreen extends StatelessWidget {
  const GroupsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المجموعات')),
      body: const Center(child: Text('لا توجد مجموعات بعد', style: TextStyle(color: Colors.grey))),
    );
  }
}

// 4. شاشة المكالمات
class CallsScreen extends StatelessWidget {
  const CallsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المكالمات')),
      body: const Center(child: Text('سجل المكالمات فارغ', style: TextStyle(color: Colors.grey))),
    );
  }
}

// 5. شاشة التحديثات (الحالة والقنوات)
class UpdatesScreen extends StatelessWidget {
  const UpdatesScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التحديثات')),
      body: const Center(child: Text('الحالة والقنوات', style: TextStyle(color: Colors.grey))),
    );
  }
}
