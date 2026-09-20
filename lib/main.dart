import 'package:flutter/material.dart';

void main() {
  runApp(const AlWazirChatApp());
}

class AlWazirChatApp extends StatelessWidget {
  const AlWazirChatApp({super.key});

  static const Color gold = Color(0xFFD4AF37);
  static const Color dark = Color(0xFF0B0B0B);
  static const Color card = Color(0xFF151515);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'الفهد',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: gold,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: dark,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: card,
          hintStyle: const TextStyle(color: Colors.white54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 3;

  final List<Widget> pages = const [
    StatusScreen(),
    CallsScreen(),
    GroupsScreen(),
    ChatsScreen(),
  ];

  final List<String> titles = const [
    'الحالة',
    'المكالمات',
    'المجموعات',
    'الدردشات',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AlWazirChatApp.gold.withOpacity(.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AlWazirChatApp.gold,
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.pets,
                color: AlWazirChatApp.gold,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              titles[currentIndex],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: pages[currentIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF111111),
        indicatorColor: AlWazirChatApp.gold.withOpacity(.18),
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.circle_outlined),
            selectedIcon: Icon(Icons.circle),
            label: 'الحالة',
          ),
          NavigationDestination(
            icon: Icon(Icons.call_outlined),
            selectedIcon: Icon(Icons.call),
            label: 'المكالمات',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups),
            label: 'المجموعات',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'الدردشات',
          ),
        ],
      ),
    );
  }
}

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  static const List<Map<String, String>> chats = [
    {
      'name': 'مستخدم الفهد',
      'message': 'مرحباً بك في الفهد',
      'time': '20:10',
    },
    {
      'name': 'الفهد',
      'message': 'كيف حالك؟',
      'time': '19:45',
    },
    {
      'name': 'الصادق موبايل',
      'message': 'رسالة جديدة',
      'time': '18:20',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 8),
      itemCount: chats.length,
      separatorBuilder: (_, __) => const Divider(
        color: Colors.white10,
        height: 1,
        indent: 80,
      ),
      itemBuilder: (context, index) {
        final chat = chats[index];

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 5,
          ),
          leading: CircleAvatar(
            radius: 28,
            backgroundColor: AlWazirChatApp.gold.withOpacity(.18),
            child: const Icon(
              Icons.person,
              color: AlWazirChatApp.gold,
              size: 28,
            ),
          ),
          title: Text(
            chat['name']!,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              chat['message']!,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
          ),
          trailing: Text(
            chat['time']!,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 12,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SingleChatScreen(
                  name: chat['name']!,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class SingleChatScreen extends StatefulWidget {
  final String name;

  const SingleChatScreen({
    super.key,
    required this.name,
  });

  @override
  State<SingleChatScreen> createState() => _SingleChatScreenState();
}

class _SingleChatScreenState extends State<SingleChatScreen> {
  final TextEditingController controller = TextEditingController();

  final List<String> messages = [
    'السلام عليكم',
    'وعليكم السلام ورحمة الله',
    'مرحباً بك في الفهد 🐆',
  ];

  void sendMessage() {
    final text = controller.text.trim();

    if (text.isEmpty) return;

    setState(() {
      messages.add(text);
    });

    controller.clear();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: AlWazirChatApp.gold,
              child: Icon(
                Icons.person,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.videocam_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final isMine = index.isEven;

                return Align(
                  alignment: isMine
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * .78,
                    ),
                    decoration: BoxDecoration(
                      color: isMine
                          ? AlWazirChatApp.gold.withOpacity(.22)
                          : const Color(0xFF1B1B1B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isMine
                            ? AlWazirChatApp.gold.withOpacity(.25)
                            : Colors.white10,
                      ),
                    ),
                    child: Text(
                      messages[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.sticker_outline,
                      color: AlWazirChatApp.gold,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      textDirection: TextDirection.rtl,
                      onSubmitted: (_) => sendMessage(),
                      decoration: const InputDecoration(
                        hintText: 'اكتب رسالة...',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  IconButton(
                    onPressed: sendMessage,
                    icon: const Icon(
                      Icons.send,
                      color: AlWazirChatApp.gold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'حالتي',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            radius: 28,
            backgroundColor: AlWazirChatApp.gold.withOpacity(.18),
            child: const Icon(
              Icons.add,
              color: AlWazirChatApp.gold,
            ),
          ),
          title: const Text(
            'إضافة حالة',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: const Text(
            'شارك صورة أو فيديو أو نص',
            style: TextStyle(color: Colors.white54),
          ),
          onTap: () {},
        ),
        const Divider(color: Colors.white10),
        const SizedBox(height: 12),
        const Text(
          'الحالات الجديدة',
          style: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: AlWazirChatApp.gold,
            child: Icon(Icons.person, color: Colors.black),
          ),
          title: Text(
            'مستخدم الفهد',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            'مكالمة صوتية',
            style: TextStyle(color: Colors.white54),
          ),
          trailing: Icon(
            Icons.call_received,
            color: AlWazirChatApp.gold,
          ),
        ),
      ],
    );
  }
}

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: const [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: AlWazirChatApp.gold,
            child: Icon(
              Icons.groups,
              color: Colors.black,
            ),
          ),
          title: Text(
            'مجموعة الفهد',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            'لا توجد رسائل جديدة',
            style: TextStyle(color: Colors.white54),
          ),
        ),
      ],
    );
  }
}
