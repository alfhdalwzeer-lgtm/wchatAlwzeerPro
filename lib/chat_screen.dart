import 'package:flutter/material.dart';
import 'settings_screen.dart';
import 'chat_screen.dart'; // استدعاء شاشة المحادثة التي أنشأناها

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الفهد'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.camera_alt_outlined), onPressed: () {}),
          
          // القائمة المنسدلة (ثلاث نقاط)
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
      
      // الشريط السفلي
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
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
      
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFC107),
        onPressed: () {},
        child: Icon(_currentIndex == 3 ? Icons.camera_alt : Icons.chat, color: Colors.black),
      ),
    );
  }

  // التبديل بين محتوى الشاشات
  Widget _buildBody() {
    if (_currentIndex == 3) {
      // تبويب التحديثات
      return Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFFFC107),
              child: Icon(Icons.person, color: Colors.black),
            ),
            title: const Text('حالتي', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
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
                  Text('لا توجد تحديثات بعد', style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
            ),
          )
        ],
      );
    }

    // تبويب الدردشات الرئيسية (عند الضغط عليها يفتح شاشة الشات الحية)
    return ListView(
      children: [
        ListTile(
          leading: const CircleAvatar(
            backgroundColor: Color(0xFFFFC107),
            child: Icon(Icons.person, color: Colors.black),
          ),
          title: const Text('المحادثة العامة (Al-Wazir Chat)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: const Text('اضغط للبدء بالمراسلة الحية...', style: TextStyle(color: Colors.grey)),
          trailing: const Text('الآن', style: TextStyle(color: Colors.grey, fontSize: 12)),
          onTap: () {
            // الانتقال إلى شاشة الشات الفعلي المرتبط بـ Firebase
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatScreen()),
            );
          },
        ),
      ],
    );
  }
}
