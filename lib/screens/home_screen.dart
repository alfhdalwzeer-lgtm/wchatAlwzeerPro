import 'package:flutter/material.dart';

import 'screens/chat_screen.dart';
import 'screens/profile_screen.dart';
import 'status_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color gold = Color(0xFFD4AF37);
  static const Color background = Color(0xFF101820);
  static const Color cardColor = Color(0xFF1A252E);

  int _currentIndex = 0;

  final List<Map<String, dynamic>> _chats = [
    {
      'name': 'مستخدم الفهد',
      'message': 'مرحباً 👋',
      'time': 'الآن',
      'unread': 0,
    },
    {
      'name': 'الفهد',
      'message': 'آخر رسالة',
      'time': '10:30 ص',
      'unread': 2,
    },
    {
      'name': 'الصادق موبايل',
      'message': 'السلام عليكم',
      'time': 'أمس',
      'unread': 0,
    },
  ];

  void _openChat(String name) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(userName: name),
      ),
    );
  }

  void _openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ProfileScreen(),
      ),
    );
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SettingsScreen(),
      ),
    );
  }

  void _showContacts() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A252E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'جهات الاتصال',
                    style: TextStyle(
                      color: gold,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: gold,
                      child: Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                    ),
                    title: const Text(
                      'مستخدم الفهد',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: const Text(
                      'فتح محادثة',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _openChat('مستخدم الفهد');
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCalls() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A252E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return const Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.phone_in_talk_outlined,
                    color: gold,
                    size: 55,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'المكالمات',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'لا توجد مكالمات حتى الآن',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChats() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 8),
        itemCount: _chats.length,
        separatorBuilder: (_, __) => const Divider(
          height: 1,
          indent: 75,
          color: Color(0xFF26333D),
        ),
        itemBuilder: (context, index) {
          final chat = _chats[index];

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 5,
            ),
            leading: const CircleAvatar(
              radius: 27,
              backgroundColor: gold,
              child: Icon(
                Icons.person,
                color: Colors.black,
                size: 30,
              ),
            ),
            title: Text(
              chat['name'] as String,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                chat['message'] as String,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  chat['time'] as String,
                  style: TextStyle(
                    color: (chat['unread'] as int) > 0
                        ? Colors.green
                        : Colors.grey,
                    fontSize: 11,
                  ),
                ),
                if ((chat['unread'] as int) > 0) ...[
                  const SizedBox(height: 5),
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.green,
                    child: Text(
                      '${chat['unread']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            onTap: () => _openChat(chat['name'] as String),
          );
        },
      ),
    );
  }

  Widget _buildGroups() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.groups_outlined,
              size: 70,
              color: gold,
            ),
            const SizedBox(height: 15),
            const Text(
              'المجموعات',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'لا توجد مجموعات حالياً',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('إنشاء المجموعات سيتم إضافته لاحقاً'),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('إنشاء مجموعة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: gold,
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalls() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.call_outlined,
              size: 70,
              color: gold,
            ),
            const SizedBox(height: 15),
            const Text(
              'المكالمات',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'لا توجد مكالمات حتى الآن',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatus() {
    return const StatusScreen();
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildChats();
      case 1:
        return _buildGroups();
      case 2:
        return _buildCalls();
      case 3:
        return _buildStatus();
      default:
        return _buildChats();
    }
  }

  void _onMenuSelected(String value) {
    switch (value) {
      case 'profile':
        _openProfile();
        break;

      case 'contacts':
        _showContacts();
        break;

      case 'calls':
        _showCalls();
        break;

      case 'settings':
        _openSettings();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: background,

        appBar: AppBar(
          backgroundColor: background,
          elevation: 0,
          title: const Text(
            'الفهد',
            style: TextStyle(
              color: gold,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: ChatSearchDelegate(
                    chats: _chats,
                    onChatSelected: _openChat,
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('الكاميرا ستتوفر مع ميزة الحالة'),
                  ),
                );
              },
            ),
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              color: cardColor,
              onSelected: _onMenuSelected,
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: 'profile',
                  child: Text(
                    'الملف الشخصي',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                PopupMenuItem(
                  value: 'contacts',
                  child: Text(
                    'جهات الاتصال',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                PopupMenuItem(
                  value: 'calls',
                  child: Text(
                    'المكالمات',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                PopupMenuItem(
                  value: 'settings',
                  child: Text(
                    'الإعدادات',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),

        body: _buildBody(),

        floatingActionButton: _currentIndex == 0
            ? FloatingActionButton(
                backgroundColor: gold,
                foregroundColor: Colors.black,
                onPressed: () {
                  _showContacts();
                },
                child: const Icon(Icons.chat),
              )
            : null,

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF17212B),
          selectedItemColor: gold,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'الدردشات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.groups_outlined),
              activeIcon: Icon(Icons.groups),
              label: 'المجموعات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.call_outlined),
              activeIcon: Icon(Icons.call),
              label: 'المكالمات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.circle_outlined),
              activeIcon: Icon(Icons.circle),
              label: 'الحالة',
            ),
          ],
        ),
      ),
    );
  }
}

class ChatSearchDelegate extends SearchDelegate<String> {
  final List<Map<String, dynamic>> chats;
  final void Function(String name) onChatSelected;

  ChatSearchDelegate({
    required this.chats,
    required this.onChatSelected,
  });

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      scaffoldBackgroundColor: const Color(0xFF101820),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF17212B),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.grey),
        border: InputBorder.none,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildResults();
  }

  Widget _buildResults() {
    final results = chats.where((chat) {
      final name = chat['name'].toString().toLowerCase();
      final message = chat['message'].toString().toLowerCase();
      final search = query.toLowerCase();

      return name.contains(search) || message.contains(search);
    }).toList();

    return Container(
      color: const Color(0xFF101820),
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final chat = results[index];
          final name = chat['name'] as String;

          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFD4AF37),
              child: Icon(
                Icons.person,
                color: Colors.black,
              ),
            ),
            title: Text(
              name,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              chat['message'] as String,
              style: const TextStyle(color: Colors.grey),
            ),
            onTap: () {
              close(context, name);
              onChatSelected(name);
            },
          );
        },
      ),
    );
  }
}
