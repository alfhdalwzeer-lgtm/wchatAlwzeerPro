import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AlWazirChatApp());
}

// ============================================================
// APP
// ============================================================

class AlWazirChatApp extends StatelessWidget {
  const AlWazirChatApp({super.key});

  static const Color gold = Color(0xFFD4AF37);
  static const Color background = Color(0xFF0B0B0B);
  static const Color surface = Color(0xFF151515);
  static const Color message = Color(0xFF1B1B1B);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'الفهد',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: gold,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: background,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color(0xFF111111),
          indicatorColor: gold.withOpacity(.18),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surface,
          hintStyle: const TextStyle(color: Colors.white54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// ============================================================
// HOME
// ============================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 3;

  static const titles = [
    'الحالة',
    'المكالمات',
    'المجموعات',
    'الدردشات',
  ];

  final pages = const [
    StatusScreen(),
    CallsScreen(),
    GroupsScreen(),
    ChatsScreen(),
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
                shape: BoxShape.circle,
                color: AlWazirChatApp.gold.withOpacity(.15),
                border: Border.all(
                  color: AlWazirChatApp.gold,
                ),
              ),
              child: const Icon(
                Icons.pets,
                color: AlWazirChatApp.gold,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              titles[currentIndex],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'بحث',
            onPressed: () {
              showSearch(
                context: context,
                delegate: ChatSearchDelegate(),
              );
            },
            icon: const Icon(Icons.search),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'settings') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SettingsScreen(),
                  ),
                );
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'settings',
                child: Text('الإعدادات'),
              ),
            ],
          ),
        ],
      ),
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
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

// ============================================================
// CHAT MODEL
// ============================================================

class ChatItem {
  final String name;
  final String message;
  final String time;
  final int unread;
  final bool online;

  const ChatItem({
    required this.name,
    required this.message,
    required this.time,
    this.unread = 0,
    this.online = false,
  });
}

// ============================================================
// CHATS
// ============================================================

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  static const chats = [
    ChatItem(
      name: 'مستخدم الفهد',
      message: 'مرحباً بك في الفهد',
      time: '20:10',
      unread: 2,
      online: true,
    ),
    ChatItem(
      name: 'الفهد',
      message: 'كيف حالك؟',
      time: '19:45',
      online: true,
    ),
    ChatItem(
      name: 'الصادق موبايل',
      message: 'رسالة جديدة',
      time: '18:20',
      unread: 1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 8),
      itemCount: chats.length,
      separatorBuilder: (_, __) => const Divider(
        color: Colors.white10,
        height: 1,
        indent: 88,
      ),
      itemBuilder: (context, index) {
        final chat = chats[index];

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 6,
          ),
          leading: Stack(
            children: [
              const CircleAvatar(
                radius: 29,
                backgroundColor: Color(0x26D4AF37),
                child: Icon(
                  Icons.person,
                  color: AlWazirChatApp.gold,
                  size: 29,
                ),
              ),
              if (chat.online)
                Positioned(
                  right: 0,
                  bottom: 1,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AlWazirChatApp.background,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          title: Text(
            chat.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              chat.message,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white54,
              ),
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                chat.time,
                style: TextStyle(
                  color: chat.unread > 0
                      ? AlWazirChatApp.gold
                      : Colors.white38,
                  fontSize: 12,
                ),
              ),
              if (chat.unread > 0) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: const BoxDecoration(
                    color: AlWazirChatApp.gold,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${chat.unread}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SingleChatScreen(
                  name: chat.name,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ============================================================
// SINGLE CHAT
// ============================================================

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
  final controller = TextEditingController();
  final scrollController = ScrollController();

  final List<ChatMessage> messages = [
    ChatMessage(
      text: 'السلام عليكم',
      mine: false,
      time: '20:01',
    ),
    ChatMessage(
      text: 'وعليكم السلام ورحمة الله',
      mine: true,
      time: '20:02',
      seen: true,
    ),
    ChatMessage(
      text: 'مرحباً بك في الفهد 🐆',
      mine: false,
      time: '20:03',
    ),
  ];

  void sendMessage() {
    final text = controller.text.trim();

    if (text.isEmpty) return;

    setState(() {
      messages.add(
        ChatMessage(
          text: text,
          mine: true,
          time: _currentTime(),
          seen: true,
        ),
      );
    });

    controller.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _currentTime() {
    final now = DateTime.now();

    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'متصل الآن',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'فيديو',
            onPressed: () {},
            icon: const Icon(Icons.videocam_outlined),
          ),
          IconButton(
            tooltip: 'اتصال',
            onPressed: () {},
            icon: const Icon(Icons.call_outlined),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {},
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'search',
                child: Text('بحث'),
              ),
              PopupMenuItem(
                value: 'mute',
                child: Text('كتم الإشعارات'),
              ),
              PopupMenuItem(
                value: 'lock',
                child: Text('قفل المحادثة'),
              ),
              PopupMenuItem(
                value: 'clear',
                child: Text('مسح المحادثة'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return MessageBubble(
                  message: messages[index],
                );
              },
            ),
          ),
          MessageComposer(
            controller: controller,
            onSend: sendMessage,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// MESSAGE MODEL
// ============================================================

class ChatMessage {
  final String text;
  final bool mine;
  final String time;
  final bool seen;

  ChatMessage({
    required this.text,
    required this.mine,
    required this.time,
    this.seen = false,
  });
}

// ============================================================
// MESSAGE BUBBLE
// ============================================================

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.mine
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.fromLTRB(
          14,
          9,
          10,
          7,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * .80,
        ),
        decoration: BoxDecoration(
          color: message.mine
              ? AlWazirChatApp.gold.withOpacity(.20)
              : AlWazirChatApp.message,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: message.mine
                ? AlWazirChatApp.gold.withOpacity(.20)
                : Colors.white10,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                message.text,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.time,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 10,
                  ),
                ),
                if (message.mine) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.seen
                        ? Icons.done_all
                        : Icons.done,
                    size: 15,
                    color: message.seen
                        ? AlWazirChatApp.gold
                        : Colors.white38,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// MESSAGE COMPOSER
// ============================================================

class MessageComposer extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const MessageComposer({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(7, 5, 7, 8),
        child: Row(
          children: [
            IconButton(
              tooltip: 'ملصقات',
              onPressed: () {},
              icon: const Icon(
                Icons.emoji_emotions_outlined,
                color: AlWazirChatApp.gold,
              ),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                textDirection: TextDirection.rtl,
                minLines: 1,
                maxLines: 5,
                textInputAction: TextInputAction.newline,
                decoration: const InputDecoration(
                  hintText: 'اكتب رسالة...',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            IconButton(
              tooltip: 'إرفاق',
              onPressed: () {
                _showAttachmentMenu(context);
              },
              icon: const Icon(
                Icons.attach_file,
                color: AlWazirChatApp.gold,
              ),
            ),
            IconButton(
              tooltip: 'إرسال',
              onPressed: onSend,
              icon: const Icon(
                Icons.send,
                color: AlWazirChatApp.gold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AlWazirChatApp.surface,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.photo,
                  color: AlWazirChatApp.gold,
                ),
                title: const Text('المعرض'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(
                  Icons.camera_alt,
                  color: AlWazirChatApp.gold,
                ),
                title: const Text('الكاميرا'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(
                  Icons.insert_drive_file,
                  color: AlWazirChatApp.gold,
                ),
                title: const Text('ملف'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(
                  Icons.location_on,
                  color: AlWazirChatApp.gold,
                ),
                title: const Text('الموقع'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
// STATUS
// ============================================================

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
        const SizedBox(height: 12),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const CircleAvatar(
            radius: 29,
            backgroundColor: AlWazirChatApp.gold,
            child: Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
          title: const Text(
            'إضافة حالة',
            style: TextStyle(
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
        const SizedBox(height: 10),
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

// ============================================================
// CALLS
// ============================================================

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: AlWazirChatApp.gold,
            child: Icon(
              Icons.person,
              color: Colors.black,
            ),
          ),
          title: Text(
            'مستخدم الفهد',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            'مكالمة صوتية • اليوم',
            style: TextStyle(
              color: Colors.white54,
            ),
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

// ============================================================
// GROUPS
// ============================================================

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        ListTile(
          leading: const CircleAvatar(
            backgroundColor: AlWazirChatApp.gold,
            child: Icon(
              Icons.groups,
              color: Colors.black,
            ),
          ),
          title: const Text(
            'مجموعة الفهد',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: const Text(
            'لا توجد رسائل جديدة',
            style: TextStyle(
              color: Colors.white54,
            ),
          ),
          onTap: () {},
        ),
        ListTile(
          leading: const CircleAvatar(
            backgroundColor: Color(0x26D4AF37),
            child: Icon(
              Icons.add,
              color: AlWazirChatApp.gold,
            ),
          ),
          title: const Text('إنشاء مجموعة'),
          onTap: () {},
        ),
      ],
    );
  }
}

// ============================================================
// SEARCH
// ============================================================

class ChatSearchDelegate extends SearchDelegate<String> {
  final names = const [
    'مستخدم الفهد',
    'الفهد',
    'الصادق موبايل',
    'مجموعة الفهد',
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () => query = '',
          icon: const Icon(Icons.clear),
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, ''),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _results();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _results();
  }

  Widget _results() {
    final results = names
        .where(
          (name) => name.contains(query),
        )
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (_, index) {
        return ListTile(
          leading: const CircleAvatar(
            backgroundColor: AlWazirChatApp.gold,
            child: Icon(
              Icons.person,
              color: Colors.black,
            ),
          ),
          title: Text(results[index]),
        );
      },
    );
  }
}

// ============================================================
// SETTINGS
// ============================================================

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الإعدادات',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: AlWazirChatApp.surface,
            ),
            accountName: Text(
              'الفهد',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              'حساب الفهد',
              style: TextStyle(
                color: Colors.white54,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: AlWazirChatApp.gold,
              child: Icon(
                Icons.pets,
                color: Colors.black,
                size: 30,
              ),
            ),
          ),
          _setting(
            icon: Icons.lock_outline,
            title: 'الخصوصية والأمان',
            subtitle: 'إعدادات الخصوصية والحماية',
          ),
          _setting(
            icon: Icons.devices,
            title: 'الأجهزة المرتبطة',
            subtitle: 'إدارة الأجهزة المرتبطة بالحساب',
          ),
          _setting(
            icon: Icons.lock,
            title: 'قفل التطبيق',
            subtitle: 'حماية التطبيق برمز أو بصمة',
          ),
          _setting(
            icon: Icons.chat_outlined,
            title: 'قفل المحادثات',
            subtitle: 'حماية المحادثات الخاصة',
          ),
          _setting(
            icon: Icons.verified_user_outlined,
            title: 'التحقق بخطوتين',
            subtitle: 'إضافة طبقة حماية إضافية',
          ),
          _setting(
            icon: Icons.storage_outlined,
            title: 'مساحة التخزين',
            subtitle: 'إدارة الصور والفيديو والملفات',
          ),
          _setting(
            icon: Icons.notifications_outlined,
            title: 'الإشعارات',
            subtitle: 'إدارة إشعارات الرسائل والمكالمات',
          ),
          _setting(
            icon: Icons.info_outline,
            title: 'حول الفهد',
            subtitle: 'Al-Wazir Chat',
          ),
        ],
      ),
    );
  }

  static Widget _setting({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AlWazirChatApp.gold,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Colors.white54,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_left,
        color: Colors.white38,
      ),
      onTap: () {},
    );
  }
}
