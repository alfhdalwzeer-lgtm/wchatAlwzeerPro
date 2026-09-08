import 'package:flutter/material.dart';

void main() {
  runApp(const AlWazirChatApp());
}

class AlWazirChatApp extends StatelessWidget {
  const AlWazirChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Al-Wazir Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFFD4AF37),
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = '+967';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: Color(0xFFD4AF37),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('👑', style: TextStyle(fontSize: 45)),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '👑 Al-Wazir Chat',
                style: TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'أدخل رقم هاتفك بترميز الدولة للاشتراك',
                style: TextStyle(color: Colors.white70, fontSize: 15),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFD4AF37)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: const Color(0xFF1E232A),
                        value: _selectedCountryCode,
                        items: ['+967', '+966', '+971', '+1', '+20']
                            .map((code) => DropdownMenuItem(
                                  value: code,
                                  child: Text(
                                    code,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedCountryCode = val);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'رقم الهاتف',
                        labelStyle: const TextStyle(color: Color(0xFFD4AF37)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFF9C27B0)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const MainTabsScreen()),
                    );
                  },
                  child: const Text(
                    'دخول / تسجيل',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class MainTabsScreen extends StatefulWidget {
  const MainTabsScreen({super.key});

  @override
  State<MainTabsScreen> createState() => _MainTabsScreenState();
}

class _MainTabsScreenState extends State<MainTabsScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    ChatsTab(),
    StatusTab(),
    GroupsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFF181818),
        selectedItemColor: const Color(0xFFD4AF37),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_rounded),
            label: 'المحادثات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.style_rounded),
            label: 'الحالات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_rounded),
            label: 'المجموعات',
          ),
        ],
      ),
    );
  }
}

class ChatsTab extends StatelessWidget {
  const ChatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E232A),
        title: const Row(
          children: [
            Text('👑 ', style: TextStyle(fontSize: 20)),
            Text('Al-Wazir Chat', style: TextStyle(color: Color(0xFFD4AF37))),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.phone, color: Color(0xFFD4AF37)), onPressed: () {}),
          IconButton(icon: const Icon(Icons.videocam, color: Color(0xFFD4AF37)), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert, color: Color(0xFFD4AF37)), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          const Expanded(
            child: Center(
              child: Text(
                'لا توجد محادثات حالياً',
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            color: const Color(0xFF181818),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.camera_alt, color: Color(0xFFD4AF37)), onPressed: () {}),
                IconButton(icon: const Icon(Icons.image, color: Color(0xFFD4AF37)), onPressed: () {}),
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
                IconButton(icon: const Icon(Icons.send, color: Color(0xFFD4AF37)), onPressed: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatusTab extends StatelessWidget {
  const StatusTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E232A),
        centerTitle: true,
        title: const Text('الحالات', style: TextStyle(color: Color(0xFFD4AF37))),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'اضغط + لإضافة حالة جديدة (صور / فيديو)',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 20),
            FloatingActionButton(
              backgroundColor: const Color(0xFFD4AF37),
              onPressed: () {},
              child: const Icon(Icons.add_a_photo, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

class GroupsTab extends StatelessWidget {
  const GroupsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E232A),
        centerTitle: true,
        title: const Text('المجموعات', style: TextStyle(color: Color(0xFFD4AF37))),
      ),
      body: const Center(
        child: Text(
          'لا توجد مجموعات حتى الآن',
          style: TextStyle(color: Colors.white54, fontSize: 16),
        ),
      ),
    );
  }
}
