import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AlWazirChatApp());
}

class AlWazirChatApp extends StatelessWidget {
  const AlWazirChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'الفهد',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121822),
        primaryColor: const Color(0xFFFFB300),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFB300),
          secondary: Color(0xFFFFB300),
          surface: Color(0xFF1A2230),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF161D2A),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFFFFB300),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Color(0xFFFFB300)),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF161D2A),
          selectedItemColor: Color(0xFFFFB300),
          unselectedItemColor: Colors.grey,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

// 1. الشاشة الرئيسية مع شريط التنقل السفلي
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ChatsScreen(),
    const Center(child: Text('المجموعات', style: TextStyle(color: Colors.white, fontSize: 18))),
    const Center(child: Text('المكالمات', style: TextStyle(color: Colors.white, fontSize: 18))),
    const StatusScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الفهد'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.camera_alt_outlined), onPressed: () {}),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'settings') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'settings', child: Text('الإعدادات')),
            ],
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'الدردسات'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'المجموعات'),
          BottomNavigationBarItem(icon: Icon(Icons.call), label: 'المكالمات'),
          BottomNavigationBarItem(icon: Icon(Icons.donut_large), label: 'الحالة'),
        ],
      ),
    );
  }
}

// 2. شاشة قائمة الدردسات
class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(
            backgroundColor: Color(0xFFFFB300),
            child: Icon(Icons.person, color: Colors.black),
          ),
          title: const Text('مستخدم الفهد', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: const Text('السلام عليكم، مرحباً بك في الفهد', style: TextStyle(color: Colors.grey)),
          trailing: const Text('10:00 ص', style: TextStyle(color: Colors.grey, fontSize: 12)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatRoomScreen()),
            );
          },
        );
      },
    );
  }
}

// 3. شاشة غرفة المحادثة الفردية
class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            CircleAvatar(radius: 16, backgroundColor: Color(0xFFFFB300), child: Icon(Icons.person, size: 20, color: Colors.black)),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('مستخدم الفهد', style: TextStyle(fontSize: 16)),
                Text('متصل الآن', style: TextStyle(fontSize: 12, color: Colors.green)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
          IconButton(icon: const Icon(Icons.call), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: const [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Chip(
                    backgroundColor: Color(0xFF1E2636),
                    label: Text('السلام عليكم، مرحباً بك في الفهد\n10:00 ص', style: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Chip(
                    backgroundColor: Color(0xFF004D40),
                    label: Text('وعليكم السلام! تطبيق ممتاز جداً\n10:01 ص ✓✓', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            color: const Color(0xFF161D2A),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.image, color: Color(0xFFFFB300)), onPressed: () {}),
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'اكتب رسالة...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(icon: const Icon(Icons.mic, color: Color(0xFFFFB300)), onPressed: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 4. شاشة الحالة
class StatusScreen extends StatelessWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            leading: Stack(
              children: const [
                CircleAvatar(backgroundColor: Color(0xFFFFB300), child: Icon(Icons.person, color: Colors.black)),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(radius: 8, backgroundColor: Colors.green),
                ),
              ],
            ),
            title: const Text('حالتي', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: const Text('اضغط لإضافة حالة جديدة', style: TextStyle(color: Colors.grey)),
            onTap: () {},
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('التحديثات الحديثة', style: TextStyle(color: Color(0xFFFFB300), fontWeight: FontWeight.bold)),
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: Text('لا توجد حالات بعد', style: TextStyle(color: Colors.grey)),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFB300),
        child: const Icon(Icons.camera_alt, color: Colors.black),
        onPressed: () {},
      ),
    );
  }
}

// 5. شاشة الإعدادات
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.dark_mode, color: Color(0xFFFFB300)),
            title: const Text('الوضع الداكن', style: TextStyle(color: Colors.white)),
            subtitle: const Text('المظهر الداكن لـ الفهد', style: TextStyle(color: Colors.grey)),
            trailing: Switch(
              value: true,
              activeColor: const Color(0xFFFFB300),
              onChanged: (val) {},
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language, color: Color(0xFFFFB300)),
            title: const Text('لغة التطبيق', style: TextStyle(color: Colors.white)),
            subtitle: const Text('العربية', style: TextStyle(color: Colors.grey)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Color(0xFFFFB300)),
            title: const Text('حول الفهد', style: TextStyle(color: Colors.white)),
            subtitle: const Text('الإصدار 1.0.0', style: TextStyle(color: Colors.grey)),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
