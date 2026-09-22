import 'package:flutter/material.dart';

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
  int _currentIndex = 3; // تبويب الدردشات افتراضياً (حسب ترتيب الصورة يمين)

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

// شاشة الدردشات الرئيسية
class ChatsListScreen extends StatelessWidget {
  const ChatsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF1F2C34),
            child: const Icon(Icons.person, color: Color(0xFFFFD700)),
          ),
          title: const Text(
            'مستخدم الفهد',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: const Text(
            'وعليكم السلام! تطبيق ممتاز جداً.',
            style: TextStyle(color: Colors.grey),
          ),
          trailing: const Text(
            '10:01 ص',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          onTap: () {},
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFFFFD700),
            child: const Icon(Icons.star, color: Color(0xFF111B21)),
          ),
          title: const Text(
            'الفهد',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: const Text(
            'مرحباً بك في التطبيق',
            style: TextStyle(color: Colors.grey),
          ),
          trailing: const Text(
            '09:45 ص',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          onTap: () {},
        ),
      ],
    );
  }
}

// شاشات مؤقتة لباقي التبويبات
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
