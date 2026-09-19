import 'package:flutter/material.dart';
import 'home_screen.dart'; // يستدعي الشاشة الرئيسية التي قمت بإنشائها
import 'settings_screen.dart'; // يستدعي شاشة الإعدادات

void main() {
  runApp(const AlWazirChatApp());
}

class AlWazirChatApp extends StatelessWidget {
  const AlWazirChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Al-Wazir Chat - الفهد',
      debugShowCheckedModeBanner: false,
      
      // ثيم الفهد الداكن والذهبي الجديد
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF11171D), // الخلفية الداكنة
        primaryColor: const Color(0xFFFFC107), // اللون الذهبي
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFC107),
          secondary: Color(0xFFFFC107),
          surface: Color(0xFF1E2730),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF17212B),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFFFFC107), 
            fontSize: 20, 
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Color(0xFFFFC107)),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF17212B),
          selectedItemColor: Color(0xFFFFC107),
          unselectedItemColor: Colors.grey,
        ),
        useMaterial3: true,
      ),
      
      // الشاشة الرئيسية المحدثة
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
  // الحفاظ على المنطق القديم لإرسال وحفظ الرسائل
  final List<String> _messages = [];
  final TextEditingController _controller = TextEditingController();
  int _currentIndex = 0;

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(_controller.text.trim());
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الفهد'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.camera_alt_outlined), onPressed: () {}),
          
          // القائمة المنسدلة (ثلاث نقاط) للانتقال للإعدادات أو جهات الاتصال
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'settings') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(value: 'profile', child: Text('الملف الشخصي')),
              const PopupMenuItem<String>(value: 'contacts', child: Text('جهات الاتصال')),
              const PopupMenuItem<String>(value: 'calls', child: Text('المكالمات')),
              const PopupMenuItem<String>(value: 'settings', child: Text('الإعدادات')),
            ],
          ),
        ],
      ),
      
      body: _buildBody(),
      
      // شريط الملاحة السفلي (الدردشات، المجموعات، المكالمات، الحالة)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'الدردشات'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'المجموعات'),
          BottomNavigationBarItem(icon: Icon(Icons.call), label: 'المكالمات'),
          BottomNavigationBarItem(icon: Icon(Icons.donut_large), label: 'الحالة'),
        ],
      ),
      
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFC107),
        onPressed: () {},
        child: Icon(
          _currentIndex == 3 ? Icons.camera_alt : Icons.chat,
          color: Colors.black,
        ),
      ),
    );
  }

  // التحكم بمحتوى الشاشة بناءً على التبويب المختار
  Widget _buildBody() {
    if (_currentIndex == 3) {
      // شاشة الحالة الجديدة
      return Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFFFC107),
              child: Icon(Icons.person, color: Colors.black),
            ),
            title: const Text('حالتي', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: const Text('اضغط لإضافة حالة جديدة', style: TextStyle(color: Colors.grey)),
            onTap: () {},
          ),
          const Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome, color: Color(0xFFFFC107), size: 48),
                  SizedBox(height: 12),
                  Text('لا توجد حالات بعد', style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
            ),
          )
        ],
      );
    }

    // شاشة الدردشة والتفاعل القديمة (مع المظهر الذهبي والأسود الجديد)
    return Column(
      children: [
        Expanded(
          child: _messages.isEmpty
              ? const Center(
                  child: Text(
                    'لا توجد رسائل بعد',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: const Color(0xFF1E2730),
                      child: ListTile(
                        title: Text(
                          _messages[index],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
        ),
        
        // مربع كتابة الرسالة والإرسال المحدث
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'اكتب رسالتك هنا...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFFC107)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _sendMessage,
                color: const Color(0xFFFFC107), // زر الإرسال باللون الذهبي
              ),
            ],
          ),
        ),
      ],
    );
  }
}
