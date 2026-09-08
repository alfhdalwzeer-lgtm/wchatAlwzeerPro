import 'package:flutter/material.dart';
import 'screens/chat_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const WchatAlwzeerApp());
}

class WchatAlwzeerApp extends StatelessWidget {
  const WchatAlwzeerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'wchatAlwzeer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFFD4AF37),
        useMaterial3: false,
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

class _MainHomeScreenState extends State<MainHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E232A),
        title: const Text('Al-Wazir Chat', style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Color(0xFFD4AF37)),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
            },
          ),
          IconButton(icon: const Icon(Icons.search, color: Color(0xFFD4AF37)), onPressed: () {}),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFD4AF37),
          labelColor: const Color(0xFFD4AF37),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: "المحادثات"),
            Tab(text: "الحالات"),
            Tab(text: "المجموعات"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const ChatsListTab(),
          const Center(child: Text("اضغط + لإضافة حالة جديدة", style: TextStyle(color: Colors.white70))),
          const Center(child: Text("المجموعات", style: TextStyle(color: Colors.white70))),
        ],
      ),
    );
  }
}

class ChatsListTab extends StatelessWidget {
  const ChatsListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(
            backgroundColor: Color(0xFFD4AF37),
            child: Icon(Icons.person, color: Colors.black),
          ),
          title: Text("مستخدم ${index + 1}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: const Text("مرحباً بك في Al-Wazir Chat", style: TextStyle(color: Colors.grey)),
          trailing: const Text("12:00 م", style: TextStyle(color: Colors.grey, fontSize: 12)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen(userName: "مستخدم ${index + 1}")),
            );
          },
        );
      },
    );
  }
}
