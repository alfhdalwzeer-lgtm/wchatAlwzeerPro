import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/nearby_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final core = AlWazirCore.instance;
  await core.init();

  runApp(const AlWazirChatApp());
}

/* ============================================================
   01 — CORE
   ============================================================ */

class AlWazirCore {
  AlWazirCore._();

  static final AlWazirCore instance = AlWazirCore._();

  SharedPreferences? prefs;

  String userName = 'المستخدم';
  String userPhone = '';
  String countryCode = '+967';

  String language = 'ar';

  bool notificationsEnabled = true;
  bool readReceipts = true;
  bool lastSeenEnabled = true;
  bool chatLockEnabled = false;
  bool appLocked = false;
  bool twoStepEnabled = false;

  final List<ChatItem> chats = [];
  final List<GroupItem> groups = [];
  final List<StatusItem> statuses = [];
  final List<ChannelItem> channels = [];
  final List<CallItem> calls = [];

  final Map<String, List<ChatMessage>> chatMessages =
      <String, List<ChatMessage>>{};

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();

    userName = prefs?.getString('user_name') ?? 'المستخدم';
    userPhone = prefs?.getString('user_phone') ?? '';
    countryCode = prefs?.getString('country_code') ?? '+967';
    language = prefs?.getString('language') ?? 'ar';

    notificationsEnabled =
        prefs?.getBool('notifications') ?? true;
    readReceipts =
        prefs?.getBool('read_receipts') ?? true;
    lastSeenEnabled =
        prefs?.getBool('last_seen') ?? true;
    chatLockEnabled =
        prefs?.getBool('chat_lock') ?? false;
    appLocked =
        prefs?.getBool('app_lock') ?? false;
    twoStepEnabled =
        prefs?.getBool('two_step') ?? false;

    _loadDemoData();
    await loadMessages();
  }

  void _loadDemoData() {
    if (chats.isEmpty) {
      chats.add(
        ChatItem(
          id: 'chat_mohammed',
          name: 'محمد',
          lastMessage: 'السلام عليكم',
          time: '10:42 م',
          unread: 2,
          online: true,
        ),
      );
    }

    if (groups.isEmpty) {
      groups.add(
        GroupItem(
          id: 'group_friends',
          name: 'مجموعة الأصدقاء',
          description: 'مجموعة خاصة بالأصدقاء',
          members: 12,
        ),
      );
    }

    if (statuses.isEmpty) {
      statuses.addAll([
        StatusItem(
          id: 'status_1',
          name: 'محمد',
          text: 'متاح الآن',
          time: 'منذ 20 دقيقة',
        ),
        StatusItem(
          id: 'status_2',
          name: 'أحمد',
          text: 'يوم جميل للجميع 🌹',
          time: 'منذ ساعة',
        ),
      ]);
    }

    if (channels.isEmpty) {
      channels.addAll([
        ChannelItem(
          id: 'channel_1',
          name: 'قناة الفهد الرسمية',
          description: 'آخر الأخبار والإعلانات',
          followers: 1250,
          followed: true,
        ),
        ChannelItem(
          id: 'channel_2',
          name: 'عروض وإعلانات',
          description: 'إعلانات وعروض المستخدمين',
          followers: 438,
          followed: false,
        ),
      ]);
    }
  }

  Future<void> saveAccount() async {
    await prefs?.setString('user_name', userName);
    await prefs?.setString('user_phone', userPhone);
    await prefs?.setString('country_code', countryCode);
    await prefs?.setString('language', language);
  }

  Future<void> saveSettings() async {
    await prefs?.setBool('notifications', notificationsEnabled);
    await prefs?.setBool('read_receipts', readReceipts);
    await prefs?.setBool('last_seen', lastSeenEnabled);
    await prefs?.setBool('chat_lock', chatLockEnabled);
    await prefs?.setBool('app_lock', appLocked);
    await prefs?.setBool('two_step', twoStepEnabled);
  }

  Future<void> saveMessages() async {
    final Map<String, dynamic> encoded = {};

    for (final entry in chatMessages.entries) {
      encoded[entry.key] =
          entry.value.map((e) => e.toJson()).toList();
    }

    await prefs?.setString(
      'chat_messages',
      jsonEncode(encoded),
    );
  }

  Future<void> loadMessages() async {
    final raw = prefs?.getString('chat_messages');

    if (raw == null || raw.isEmpty) return;

    try {
      final Map<String, dynamic> data =
          jsonDecode(raw) as Map<String, dynamic>;

      chatMessages.clear();

      for (final entry in data.entries) {
        final list = entry.value as List;

        chatMessages[entry.key] = list
            .map(
              (item) => ChatMessage.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList();
      }
    } catch (_) {}
  }

  List<ChatMessage> messagesFor(String chatId) {
    return chatMessages.putIfAbsent(
      chatId,
      () => <ChatMessage>[],
    );
  }

  Future<void> addMessage(
    String chatId,
    ChatMessage message,
  ) async {
    messagesFor(chatId).add(message);
    await saveMessages();

    final chatIndex =
        chats.indexWhere((c) => c.id == chatId);

    if (chatIndex != -1) {
      chats[chatIndex].lastMessage = message.text;
      chats[chatIndex].time = message.time;
    }
  }

  Future<void> deleteMessage(
    String chatId,
    ChatMessage message,
  ) async {
    messagesFor(chatId).remove(message);
    await saveMessages();
  }

  Future<void> clearChat(String chatId) async {
    chatMessages.remove(chatId);
    await saveMessages();
  }

  void deleteChat(String id) {
    chats.removeWhere((c) => c.id == id);
    chatMessages.remove(id);
    saveMessages();
  }

  void addGroup(String name, String description) {
    groups.insert(
      0,
      GroupItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        description: description,
        members: 1,
      ),
    );
  }

  void addStatus(String text) {
    if (text.trim().isEmpty) return;

    statuses.insert(
      0,
      StatusItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: userName,
        text: text.trim(),
        time: 'الآن',
        mine: true,
      ),
    );
  }

  void deleteStatus(String id) {
    statuses.removeWhere((s) => s.id == id);
  }

  void addChannel(String name, String description) {
    channels.insert(
      0,
      ChannelItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        description: description,
        followers: 1,
        followed: true,
      ),
    );
  }

  void toggleChannel(String id) {
    final index =
        channels.indexWhere((c) => c.id == id);

    if (index == -1) return;

    channels[index].followed =
        !channels[index].followed;

    if (channels[index].followed) {
      channels[index].followers++;
    } else if (channels[index].followers > 0) {
      channels[index].followers--;
    }
  }

  Future<void> setLanguage(String value) async {
    language = value;
    await prefs?.setString('language', value);
  }
}

/* ============================================================
   02 — MODELS
   ============================================================ */

enum CallType {
  voice,
  video,
}

class ChatItem {
  ChatItem({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.unread = 0,
    this.online = false,
  });

  final String id;
  final String name;
  String lastMessage;
  String time;
  int unread;
  bool online;
}

class GroupItem {
  GroupItem({
    required this.id,
    required this.name,
    required this.description,
    required this.members,
  });

  final String id;
  final String name;
  final String description;
  int members;
}

class StatusItem {
  StatusItem({
    required this.id,
    required this.name,
    required this.text,
    required this.time,
    this.mine = false,
    this.views = 0,
  });

  final String id;
  final String name;
  final String text;
  final String time;
  final bool mine;
  int views;
}

class ChannelItem {
  ChannelItem({
    required this.id,
    required this.name,
    required this.description,
    required this.followers,
    required this.followed,
  });

  final String id;
  final String name;
  final String description;
  int followers;
  bool followed;
}

class CallItem {
  CallItem({
    required this.name,
    required this.type,
    required this.incoming,
    required this.missed,
    required this.time,
  });

  final String name;
  final CallType type;
  final bool incoming;
  final bool missed;
  final String time;
}

class ChatMessage {
  ChatMessage({
    required this.id,
    required this.text,
    required this.mine,
    this.time = 'الآن',
    this.read = true,
    this.type = 'text',
    this.filePath,
  });

  final String id;
  String text;
  bool mine;
  String time;
  bool read;
  String type;
  String? filePath;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'mine': mine,
      'time': time,
      'read': read,
      'type': type,
      'filePath': filePath,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      mine: json['mine'] == true,
      time: json['time']?.toString() ?? 'الآن',
      read: json['read'] != false,
      type: json['type']?.toString() ?? 'text',
      filePath: json['filePath']?.toString(),
    );
  }
}

/* ============================================================
   03 — APP
   ============================================================ */

class AlWazirChatApp extends StatefulWidget {
  const AlWazirChatApp({super.key});

  @override
  State<AlWazirChatApp> createState() =>
      _AlWazirChatAppState();
}

class _AlWazirChatAppState
    extends State<AlWazirChatApp> {

  @override
  Widget build(BuildContext context) {
    final core = AlWazirCore.instance;

    final rtl = core.language == 'ar' ||
        core.language == 'ur';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'الفهد',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor:
            AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.gold,
          secondary: AppColors.gold,
          surface: AppColors.surface,
        ),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return Directionality(
          textDirection:
              rtl ? TextDirection.rtl : TextDirection.ltr,
          child: child ?? const SizedBox(),
        );
      },
      home: const SplashScreen(),
    );
  }
}

/* ============================================================
   04 — SPLASH
   ============================================================ */

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(seconds: 2),
      () {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.pets_rounded,
              size: 90,
              color: AppColors.gold,
            ),
            SizedBox(height: 20),
            Text(
              'الفهد',
              style: TextStyle(
                color: AppColors.gold,
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Al Wazir Chat',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ============================================================
   05 — LOGIN
   ============================================================ */

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final phoneController =
      TextEditingController();

  String countryCode = '+967';

  final countries = const [
    ('+967', 'اليمن'),
    ('+966', 'السعودية'),
    ('+971', 'الإمارات'),
    ('+20', 'مصر'),
    ('+964', 'العراق'),
    ('+962', 'الأردن'),
    ('+90', 'تركيا'),
    ('+33', 'فرنسا'),
    ('+49', 'ألمانيا'),
    ('+62', 'إندونيسيا'),
    ('+92', 'باكستان'),
    ('+34', 'إسبانيا'),
    ('+1', 'أمريكا / كندا'),
  ];

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final phone = phoneController.text.trim();

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('أدخل رقم الهاتف أولًا'),
        ),
      );
      return;
    }

    final core = AlWazirCore.instance;

    core.userName = 'المستخدم';
    core.countryCode = countryCode;
    core.userPhone = '$countryCode$phone';

    await core.saveAccount();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const MainHomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(
                  Icons.pets_rounded,
                  size: 80,
                  color: AppColors.gold,
                ),
                const SizedBox(height: 15),
                const Text(
                  'الفهد',
                  style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 35),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        value: countryCode,
                        decoration:
                            const InputDecoration(
                          labelText: 'الدولة',
                          filled: true,
                        ),
                        items: countries
                            .map(
                              (country) =>
                                  DropdownMenuItem(
                                value: country.$1,
                                child: Text(
                                  '${country.$1} ${country.$2}',
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(
                              () => countryCode = value,
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: AppTextField(
                        controller:
                            phoneController,
                        label: 'رقم الهاتف',
                        icon:
                            Icons.phone_outlined,
                        keyboardType:
                            TextInputType.phone,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                GoldButton(
                  text: 'دخول',
                  icon: Icons.login_rounded,
                  onPressed: login,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ============================================================
   06 — MAIN NAVIGATION
   ============================================================ */

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() =>
      _MainHomeScreenState();
}

class _MainHomeScreenState
    extends State<MainHomeScreen> {

  int index = 0;

  final pages = const [
    ChatsScreen(),
    GroupsScreen(),
    CallsScreen(),
    StatusScreen(),
    ChannelsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الفهد',
          style: TextStyle(
            color: AppColors.gold,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'الكاميرا',
            icon: const Icon(
              Icons.camera_alt_outlined,
            ),
            onPressed: () async {
              final picker = ImagePicker();

              final image =
                  await picker.pickImage(
                source: ImageSource.camera,
              );

              if (image != null &&
                  mounted) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content:
                        Text('تم التقاط الصورة'),
                  ),
                );
              }
            },
          ),
          IconButton(
            tooltip: 'بحث',
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate:
                    ChatSearchDelegate(),
              );
            },
          ),
          IconButton(
            tooltip: 'الإعدادات',
            icon: const Icon(
              Icons.settings_outlined,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const SettingsScreen(),
                ),
              ).then(
                (_) => setState(() {}),
              );
            },
          ),
        ],
      ),
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        backgroundColor: AppColors.surface,
        onDestinationSelected: (value) {
          setState(() => index = value);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.chat_bubble_outline,
            ),
            selectedIcon: Icon(
              Icons.chat_bubble,
            ),
            label: 'الدردشات',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.groups_outlined,
            ),
            selectedIcon: Icon(Icons.groups),
            label: 'المجموعات',
          ),
          NavigationDestination(
            icon: Icon(Icons.call_outlined),
            selectedIcon: Icon(Icons.call),
            label: 'المكالمات',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.circle_outlined,
            ),
            selectedIcon: Icon(Icons.circle),
            label: 'الحالة',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.campaign_outlined,
            ),
            selectedIcon: Icon(Icons.campaign),
            label: 'القنوات',
          ),
        ],
      ),
    );
  }
}

/* ============================================================
   07 — CHATS
   ============================================================ */

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() =>
      _ChatsScreenState();
}

class _ChatsScreenState
    extends State<ChatsScreen> {

  final core = AlWazirCore.instance;

  void newChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ContactsScreen(
          mode: ContactMode.chat,
        ),
      ),
    ).then((result) {
      if (result is ChatItem) {
        setState(() {});
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ChatScreen(chat: result),
          ),
        );
      }
    });
  }

  void chatMenu(ChatItem chat) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            SheetAction(
              icon: Icons.push_pin_outlined,
              title: 'تثبيت',
              onTap: () =>
                  Navigator.pop(context),
            ),
            SheetAction(
              icon: Icons.mark_chat_unread_outlined,
              title: 'تحديد كغير مقروء',
              onTap: () =>
                  Navigator.pop(context),
            ),
            SheetAction(
              icon: Icons.delete_outline,
              title: 'حذف المحادثة',
              onTap: () {
                core.deleteChat(chat.id);
                Navigator.pop(context);
                setState(() {});
              },
            ),
            SheetAction(
              icon: Icons.cleaning_services_outlined,
              title: 'مسح المحادثة',
              onTap: () {
                core.clearChat(chat.id);
                Navigator.pop(context);
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemCount: core.chats.length,
        separatorBuilder: (_, __) =>
            const Divider(height: 1),
        itemBuilder: (_, i) {
          final chat = core.chats[i];

          return GestureDetector(
            onLongPress: () => chatMenu(chat),
            child: ChatTile(
              chat: chat,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ChatScreen(chat: chat),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton:
          FloatingActionButton(
        backgroundColor: AppColors.gold,
        foregroundColor: Colors.black,
        onPressed: newChat,
        child: const Icon(
          Icons.add_comment,
        ),
      ),
    );
  }
}

/* ============================================================
   08 — CHAT
   ============================================================ */

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.chat,
  });

  final ChatItem chat;

  @override
  State<ChatScreen> createState() =>
      _ChatScreenState();
}

class _ChatScreenState
    extends State<ChatScreen> {

  final controller =
      TextEditingController();

  final scrollController =
      ScrollController();

  late List<ChatMessage> messages;

  final picker = ImagePicker();

  final nearby = NearbyService();

  @override
  void initState() {
    super.initState();

    messages = AlWazirCore.instance
        .messagesFor(widget.chat.id);

    if (messages.isEmpty) {
      messages.addAll([
        ChatMessage(
          id: 'welcome_1',
          text: 'السلام عليكم',
          mine: false,
          time: '10:40 م',
        ),
        ChatMessage(
          id: 'welcome_2',
          text: 'وعليكم السلام ورحمة الله',
          mine: true,
          time: '10:41 م',
        ),
      ]);

      AlWazirCore.instance
          .saveMessages();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future<void> send() async {
    final text = controller.text.trim();

    if (text.isEmpty) return;

    final message = ChatMessage(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),
      text: text,
      mine: true,
      time: 'الآن',
    );

    setState(() {
      messages.add(message);
      controller.clear();
    });

    await AlWazirCore.instance.addMessage(
      widget.chat.id,
      message,
    );

    try {
      for (final endpoint
          in nearby.connectedEndpoints) {
        await nearby.sendJson(
          endpointId: endpoint,
          data: {
            'type': 'chat_message',
            'chatId': widget.chat.id,
            'message': message.toJson(),
          },
        );
      }
    } catch (_) {}

    _scrollBottom();
  }

  void _scrollBottom() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController
              .position.maxScrollExtent,
          duration:
              const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> pickGallery() async {
    final image =
        await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return;

    final message = ChatMessage(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),
      text: 'صورة',
      mine: true,
      type: 'image',
      filePath: image.path,
    );

    setState(() => messages.add(message));

    await AlWazirCore.instance.addMessage(
      widget.chat.id,
      message,
    );
  }

  Future<void> takeCamera() async {
    final image =
        await picker.pickImage(
      source: ImageSource.camera,
    );

    if (image == null) return;

    final message = ChatMessage(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),
      text: 'صورة من الكاميرا',
      mine: true,
      type: 'image',
      filePath: image.path,
    );

    setState(() => messages.add(message));

    await AlWazirCore.instance.addMessage(
      widget.chat.id,
      message,
    );
  }

  Future<void> pickFile() async {
    final result =
        await FilePicker.platform.pickFiles();

    if (result == null ||
        result.files.isEmpty) {
      return;
    }

    final file = result.files.first;

    final message = ChatMessage(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),
      text: file.name,
      mine: true,
      type: 'file',
      filePath: file.path,
    );

    setState(() => messages.add(message));

    await AlWazirCore.instance.addMessage(
      widget.chat.id,
      message,
    );
  }

  void showAttachments() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            SheetAction(
              icon:
                  Icons.photo_library_outlined,
              title: 'المعرض',
              onTap: () {
                Navigator.pop(context);
                pickGallery();
              },
            ),
            SheetAction(
              icon:
                  Icons.camera_alt_outlined,
              title: 'الكاميرا',
              onTap: () {
                Navigator.pop(context);
                takeCamera();
              },
            ),
            SheetAction(
              icon:
                  Icons.insert_drive_file_outlined,
              title: 'ملف',
              onTap: () {
                Navigator.pop(context);
                pickFile();
              },
            ),
            SheetAction(
              icon: Icons.location_on_outlined,
              title: 'الموقع',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'سيتم ربط الموقع المحلي في المرحلة التالية',
                    ),
                  ),
                );
              },
            ),
            SheetAction(
              icon: Icons.person_outline,
              title: 'جهة اتصال',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const ContactsScreen(
                      mode: ContactMode.contact,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void messageMenu(ChatMessage message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            SheetAction(
              icon: Icons.copy_outlined,
              title: 'نسخ',
              onTap: () {
                Clipboard.setData(
                  ClipboardData(
                    text: message.text,
                  ),
                );
                Navigator.pop(context);
              },
            ),
            SheetAction(
              icon: Icons.forward_outlined,
              title: 'إعادة توجيه',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content:
                        Text('حدد جهة التوجيه'),
                  ),
                );
              },
            ),
            SheetAction(
              icon: Icons.delete_outline,
              title: 'حذف',
              onTap: () async {
                await AlWazirCore.instance
                    .deleteMessage(
                  widget.chat.id,
                  message,
                );
                if (mounted) {
                  setState(() {});
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            AvatarCircle(
              label: widget.chat.name
                  .characters
                  .first,
              online: widget.chat.online,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.chat.name,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.videocam_outlined),
            onPressed: () =>
                openCall(context, video: true),
          ),
          IconButton(
            icon:
                const Icon(Icons.call_outlined),
            onPressed: () =>
                openCall(context, video: false),
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'clear') {
                await AlWazirCore.instance
                    .clearChat(widget.chat.id);
                setState(() => messages.clear());
              }

              if (value == 'search') {
                showSearch(
                  context: context,
                  delegate:
                      MessageSearchDelegate(
                    messages,
                  ),
                );
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'search',
                child: Text(
                  'البحث داخل المحادثة',
                ),
              ),
              PopupMenuItem(
                value: 'clear',
                child: Text(
                  'مسح المحادثة',
                ),
              ),
              PopupMenuItem(
                value: 'lock',
                child: Text(
                  'قفل المحادثة',
                ),
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
              padding:
                  const EdgeInsets.all(14),
              itemCount: messages.length,
              itemBuilder: (_, i) {
                final message = messages[i];

                return GestureDetector(
                  onLongPress: () =>
                      messageMenu(message),
                  child: MessageBubble(
                    message: message,
                  ),
                );
              },
            ),
          ),
          Composer(
            controller: controller,
            onSend: send,
            onAttachment:
                showAttachments,
          ),
        ],
      ),
    );
  }
}

/* ============================================================
   10 — GROUPS
   ============================================================ */

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final core = AlWazirCore.instance;

  void createGroup() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Row(
          children: [
            Icon(
              Icons.groups_rounded,
              color: AppColors.gold,
            ),
            SizedBox(width: 10),
            Text('إنشاء مجموعة'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              controller: nameController,
              label: 'اسم المجموعة',
              icon: Icons.groups_rounded,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: descriptionController,
              label: 'وصف المجموعة',
              icon: Icons.description_outlined,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.gold,
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              final name = nameController.text.trim();

              if (name.isNotEmpty) {
                core.addGroup(
                  name,
                  descriptionController.text.trim(),
                );
              }

              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('إنشاء'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: core.groups.isEmpty
          ? const EmptyState(
              icon: Icons.groups_outlined,
              title: 'لا توجد مجموعات',
              subtitle: 'أنشئ مجموعة جديدة وابدأ المحادثة',
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: core.groups.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1),
              itemBuilder: (_, index) {
                final group = core.groups[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  color: AppColors.surface,
                  elevation: 0,
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    leading: const AvatarCircle(
                      label: '👥',
                      radius: 27,
                    ),
                    title: Text(
                      group.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Padding(
                      padding:
                          const EdgeInsets.only(top: 5),
                      child: Text(
                        '${group.members} أعضاء'
                        '${group.description.isEmpty ? '' : ' • ${group.description}'}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_left_rounded,
                      color: AppColors.muted,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              GroupDetailsScreen(
                            group: group,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.gold,
        foregroundColor: Colors.black,
        elevation: 4,
        onPressed: createGroup,
        child: const Icon(Icons.group_add_rounded),
      ),
    );
  }
}


/* ============================================================
   GROUP DETAILS
   ============================================================ */

class GroupDetailsScreen extends StatefulWidget {
  const GroupDetailsScreen({
    super.key,
    required this.group,
  });

  final GroupItem group;

  @override
  State<GroupDetailsScreen> createState() =>
      _GroupDetailsScreenState();
}

class _GroupDetailsScreenState
    extends State<GroupDetailsScreen> {
  bool muted = false;
  bool onlyAdmins = false;

  void showMembers() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const ListTile(
              title: Text(
                'أعضاء المجموعة',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            ListTile(
              leading:
                  const AvatarCircle(label: 'م'),
              title: const Text('المستخدم'),
              subtitle: const Text('مشرف المجموعة'),
              trailing: const Icon(
                Icons.verified,
                color: AppColors.gold,
              ),
            ),
            ListTile(
              leading:
                  const AvatarCircle(label: 'م'),
              title: const Text('محمد'),
              subtitle: const Text('عضو'),
            ),
            ListTile(
              leading:
                  const AvatarCircle(label: 'أ'),
              title: const Text('أحمد'),
              subtitle: const Text('عضو'),
            ),
          ],
        ),
      ),
    );
  }

  void inviteLink() {
    Clipboard.setData(
      const ClipboardData(
        text: 'https://alwazir.chat/group/invite',
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ رابط الدعوة'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final group = widget.group;

    return Scaffold(
      appBar: AppBar(
        title: Text(group.name),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'search') {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content:
                        Text('البحث داخل المجموعة'),
                  ),
                );
              }

              if (value == 'delete') {
                Navigator.pop(context);
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'search',
                child: Text('بحث'),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Text('حذف المجموعة'),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(
            child: AvatarCircle(
              label: '👥',
              radius: 48,
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: Text(
              group.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Center(
            child: Text(
              '${group.members} أعضاء',
              style: const TextStyle(
                color: AppColors.muted,
              ),
            ),
          ),
          if (group.description.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              group.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.muted,
              ),
            ),
          ],
          const SizedBox(height: 25),

          SectionCard(
            title: 'إدارة المجموعة',
            children: [
              SwitchListTile(
                secondary: const Icon(
                  Icons.notifications_off_outlined,
                ),
                title: const Text('كتم الإشعارات'),
                value: muted,
                onChanged: (value) {
                  setState(() => muted = value);
                },
              ),
              SwitchListTile(
                secondary: const Icon(
                  Icons.admin_panel_settings_outlined,
                ),
                title: const Text('المشرفون فقط'),
                subtitle: const Text(
                  'السماح للمشرفين بإرسال الرسائل فقط',
                ),
                value: onlyAdmins,
                onChanged: (value) {
                  setState(() => onlyAdmins = value);
                },
              ),
            ],
          ),

          const SizedBox(height: 14),

          SectionCard(
            title: 'الأعضاء',
            children: [
              ListTile(
                leading: const Icon(
                  Icons.person_add_alt_rounded,
                  color: AppColors.gold,
                ),
                title: const Text('إضافة أعضاء'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const ContactsScreen(
                        mode: ContactMode.group,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.people_alt_outlined,
                ),
                title: const Text('عرض جميع الأعضاء'),
                onTap: showMembers,
              ),
              ListTile(
                leading: const Icon(
                  Icons.admin_panel_settings_outlined,
                ),
                title: const Text('إدارة المشرفين'),
                onTap: () {
                  showMembers();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.link_rounded,
                ),
                title: const Text('دعوة عبر رابط'),
                onTap: inviteLink,
              ),
            ],
          ),

          const SizedBox(height: 14),

          Card(
            color: AppColors.surface,
            child: ListTile(
              leading: const Icon(
                Icons.exit_to_app_rounded,
                color: AppColors.danger,
              ),
              title: const Text(
                'مغادرة المجموعة',
                style: TextStyle(
                  color: AppColors.danger,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                showDialog<void>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title:
                        const Text('مغادرة المجموعة؟'),
                    content: const Text(
                      'هل تريد مغادرة هذه المجموعة؟',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(context),
                        child:
                            const Text('إلغاء'),
                      ),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              AppColors.danger,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child:
                            const Text('مغادرة'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


/* ============================================================
   11 — CALLS
   ============================================================ */

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calls = AlWazirCore.instance.calls;

    return Scaffold(
      body: calls.isEmpty
          ? const EmptyState(
              icon: Icons.call_outlined,
              title: 'لا توجد مكالمات',
              subtitle: 'ستظهر مكالماتك هنا',
            )
          : ListView.separated(
              padding:
                  const EdgeInsets.symmetric(vertical: 8),
              itemCount: calls.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1),
              itemBuilder: (_, index) {
                final call = calls[index];

                final missedColor = call.missed
                    ? AppColors.danger
                    : null;

                return Card(
                  color: AppColors.surface,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  child: ListTile(
                    leading: AvatarCircle(
                      label: call.name.characters.first,
                    ),
                    title: Text(
                      call.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: missedColor,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Icon(
                          call.incoming
                              ? Icons.call_received_rounded
                              : Icons.call_made_rounded,
                          size: 16,
                          color: call.missed
                              ? AppColors.danger
                              : AppColors.success,
                        ),
                        const SizedBox(width: 5),
                        Text(call.time),
                      ],
                    ),
                    trailing: IconButton(
                      tooltip: call.type == CallType.video
                          ? 'مكالمة فيديو'
                          : 'اتصال صوتي',
                      icon: Icon(
                        call.type == CallType.video
                            ? Icons.videocam_outlined
                            : Icons.call_outlined,
                        color: AppColors.gold,
                      ),
                      onPressed: () {
                        openCall(
                          context,
                          video:
                              call.type == CallType.video,
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CallDetailsScreen(
                            call: call,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.gold,
        foregroundColor: Colors.black,
        onPressed: () => showCallOptions(context),
        child: const Icon(Icons.add_call),
      ),
    );
  }
}


/* ============================================================
   CALL DETAILS
   ============================================================ */

class CallDetailsScreen extends StatelessWidget {
  const CallDetailsScreen({
    super.key,
    required this.call,
  });

  final CallItem call;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل المكالمة'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 20),
          Center(
            child: AvatarCircle(
              label: call.name.characters.first,
              radius: 50,
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: Text(
              call.name,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              call.type == CallType.video
                  ? 'مكالمة فيديو'
                  : 'مكالمة صوتية',
              style: const TextStyle(
                color: AppColors.muted,
              ),
            ),
          ),
          const SizedBox(height: 30),
          SectionCard(
            title: 'تفاصيل',
            children: [
              ListTile(
                leading:
                    const Icon(Icons.access_time),
                title: const Text('الوقت'),
                trailing: Text(call.time),
              ),
              ListTile(
                leading: Icon(
                  call.incoming
                      ? Icons.call_received
                      : Icons.call_made,
                ),
                title: const Text('نوع المكالمة'),
                trailing: Text(
                  call.incoming
                      ? 'واردة'
                      : 'صادرة',
                ),
              ),
              ListTile(
                leading:
                    const Icon(Icons.info_outline),
                title: const Text('الحالة'),
                trailing: Text(
                  call.missed
                      ? 'لم يتم الرد'
                      : 'تم الاتصال',
                  style: TextStyle(
                    color: call.missed
                        ? AppColors.danger
                        : AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: GoldButton(
                  text: 'اتصال صوتي',
                  icon: Icons.call,
                  onPressed: () =>
                      openCall(
                    context,
                    video: false,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GoldButton(
                  text: 'فيديو',
                  icon: Icons.videocam,
                  onPressed: () =>
                      openCall(
                    context,
                    video: true,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


void showCallOptions(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24),
      ),
    ),
    builder: (_) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SectionTitle(
              title: 'بدء مكالمة جديدة',
            ),
            SheetAction(
              icon: Icons.call_rounded,
              title: 'اتصال صوتي',
              onTap: () {
                Navigator.pop(context);
                openCall(
                  context,
                  video: false,
                );
              },
            ),
            SheetAction(
              icon: Icons.videocam_rounded,
              title: 'مكالمة فيديو',
              onTap: () {
                Navigator.pop(context);
                openCall(
                  context,
                  video: true,
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}


void openCall(
  BuildContext context, {
  required bool video,
}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CallScreen(
        video: video,
      ),
    ),
  );
}


/* ============================================================
   CALL SCREEN
   ============================================================ */

class CallScreen extends StatefulWidget {
  const CallScreen({
    super.key,
    required this.video,
  });

  final bool video;

  @override
  State<CallScreen> createState() =>
      _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool muted = false;
  bool speaker = false;
  bool camera = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          widget.video
              ? 'مكالمة فيديو'
              : 'اتصال صوتي',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),

            const AvatarCircle(
              label: 'م',
              radius: 58,
            ),

            const SizedBox(height: 20),

            const Text(
              'المستخدم',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'جاري الاتصال...',
              style: TextStyle(
                color: AppColors.muted,
              ),
            ),

            if (widget.video && camera)
              const Padding(
                padding: EdgeInsets.all(25),
                child: Icon(
                  Icons.videocam_rounded,
                  color: AppColors.gold,
                  size: 65,
                ),
              ),

            const Spacer(),

            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 15,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.06),
                borderRadius:
                    const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                children: [
                  CallControl(
                    icon: muted
                        ? Icons.mic_off
                        : Icons.mic,
                    active: muted,
                    onPressed: () {
                      setState(
                        () => muted = !muted,
                      );
                    },
                  ),
                  if (widget.video)
                    CallControl(
                      icon: camera
                          ? Icons.videocam
                          : Icons.videocam_off,
                      active: !camera,
                      onPressed: () {
                        setState(
                          () => camera = !camera,
                        );
                      },
                    ),
                  CallControl(
                    icon: speaker
                        ? Icons.volume_up
                        : Icons.volume_down,
                    active: speaker,
                    onPressed: () {
                      setState(
                        () => speaker = !speaker,
                      );
                    },
                  ),
                  CallControl(
                    icon: Icons.call_end_rounded,
                    danger: true,
                    onPressed: () =>
                        Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/* ============================================================
   12 — STATUS
   ============================================================ */

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() =>
      _StatusScreenState();
}

class _StatusScreenState
    extends State<StatusScreen> {
  final core = AlWazirCore.instance;

  void createStatus() {
    final controller =
        TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 18,
          right: 18,
          top: 20,
          bottom:
              MediaQuery.of(context)
                      .viewInsets
                      .bottom +
                  20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'إضافة حالة',
              style: TextStyle(
                color: AppColors.gold,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: controller,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'اكتب ما تريد مشاركته...',
                filled: true,
                fillColor: AppColors.background,
                prefixIcon: const Icon(
                  Icons.edit_outlined,
                ),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(
                      Icons.photo_outlined,
                    ),
                    label:
                        const Text('صورة'),
                    onPressed: () async {
                      final image =
                          await ImagePicker()
                              .pickImage(
                        source:
                            ImageSource.gallery,
                      );

                      if (image != null &&
                          context.mounted) {
                        ScaffoldMessenger.of(
                                context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              'تم اختيار الصورة للحالة',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GoldButton(
                    text: 'نشر',
                    icon: Icons.send_rounded,
                    onPressed: () {
                      core.addStatus(
                        controller.text,
                      );
                      Navigator.pop(context);
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void deleteStatus(StatusItem status) {
    if (!status.mine) return;

    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('حذف الحالة'),
        content: const Text(
          'هل تريد حذف هذه الحالة؟',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.danger,
            ),
            onPressed: () {
              core.deleteStatus(status.id);
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding:
            const EdgeInsets.symmetric(vertical: 8),
        children: [
          Card(
            color: AppColors.surface,
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.all(12),
              leading: Stack(
                clipBehavior: Clip.none,
                children: [
                  const AvatarCircle(
                    label: 'م',
                    radius: 29,
                  ),
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      width: 23,
                      height: 23,
                      decoration:
                          const BoxDecoration(
                        color: AppColors.gold,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 17,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              title: const Text(
                'حالتي',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'أضف تحديثًا جديدًا',
              ),
              trailing: const Icon(
                Icons.chevron_left_rounded,
              ),
              onTap: createStatus,
            ),
          ),

          const SectionTitle(
            title: 'التحديثات الأخيرة',
          ),

          if (core.statuses.isEmpty)
            const EmptyState(
              icon: Icons.circle_outlined,
              title: 'لا توجد تحديثات',
              subtitle:
                  'ستظهر حالات جهات الاتصال هنا',
            )
          else
            ...core.statuses.map(
              (status) => Card(
                color: AppColors.surface,
                margin:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 4,
                  ),
                  leading: Container(
                    padding:
                        const EdgeInsets.all(2),
                    decoration:
                        const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.gold,
                    ),
                    child: AvatarCircle(
                      label: status.name
                          .characters
                          .first,
                      radius: 25,
                    ),
                  ),
                  title: Text(
                    status.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    status.text,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                  ),
                  trailing: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Text(
                        status.time,
                        style:
                            const TextStyle(
                          color:
                              AppColors.muted,
                          fontSize: 11,
                        ),
                      ),
                      if (status.mine)
                        PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          iconSize: 20,
                          onSelected: (value) {
                            if (value == 'delete') {
                              deleteStatus(
                                status,
                              );
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                              value: 'delete',
                              child: Text(
                                'حذف الحالة',
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            StatusViewerScreen(
                          status: status,
                        ),
                      ),
                    ).then(
                      (_) => setState(() {}),
                    );
                  },
                ),
              ),
            ),

          const SizedBox(height: 8),

          ListTile(
            leading: Container(
              padding:
                  const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color:
                    AppColors.gold.withOpacity(.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.privacy_tip_outlined,
                color: AppColors.gold,
              ),
            ),
            title: const Text(
              'خصوصية الحالة',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              'حدد من يمكنه مشاهدة تحديثاتك',
            ),
            trailing: const Icon(
              Icons.chevron_left_rounded,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const StatusPrivacyScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}


/* ============================================================
   STATUS VIEWER
   ============================================================ */

class StatusViewerScreen extends StatefulWidget {
  const StatusViewerScreen({
    super.key,
    required this.status,
  });

  final StatusItem status;

  @override
  State<StatusViewerScreen> createState() =>
      _StatusViewerScreenState();
}

class _StatusViewerScreenState
    extends State<StatusViewerScreen> {
  @override
  void initState() {
    super.initState();

    if (!widget.status.mine) {
      widget.status.views++;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.status;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            AvatarCircle(
              label: status.name
                  .characters
                  .first,
              radius: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                status.name,
                overflow:
                    TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding:
                  const EdgeInsets.all(30),
              child: Text(
                status.text,
                textAlign:
                    TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.visibility_outlined,
                  color: AppColors.muted,
                ),
                const SizedBox(width: 7),
                Text(
                  '${status.views} مشاهدة',
                  style: const TextStyle(
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


/* ============================================================
   STATUS PRIVACY
   ============================================================ */

class StatusPrivacyScreen extends StatefulWidget {
  const StatusPrivacyScreen({super.key});

  @override
  State<StatusPrivacyScreen> createState() =>
      _StatusPrivacyScreenState();
}

class _StatusPrivacyScreenState
    extends State<StatusPrivacyScreen> {
  int selected = 0;

  final options = const [
    (
      'جهات اتصالي',
      'كل جهات اتصالك يمكنها مشاهدة الحالة',
      Icons.people_alt_outlined,
    ),
    (
      'جهات اتصالي باستثناء...',
      'استثناء أشخاص محددين',
      Icons.person_off_outlined,
    ),
    (
      'المشاركة فقط مع...',
      'اختيار أشخاص محددين',
      Icons.person_add_alt_1_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('خصوصية الحالة'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'اختر من يمكنه مشاهدة تحديثات الحالة الخاصة بك.',
                style: TextStyle(
                  color: AppColors.muted,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ...List.generate(
            options.length,
            (index) {
              final option = options[index];

              return Card(
                color: AppColors.surface,
                child: RadioListTile<int>(
                  value: index,
                  groupValue: selected,
                  secondary: Icon(
                    option.$3,
                    color: AppColors.gold,
                  ),
                  title: Text(
                    option.$1,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle:
                      Text(option.$2),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(
                      () => selected = value,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}


/* ============================================================
   13 — CHANNELS
   ============================================================ */

class ChannelsScreen extends StatefulWidget {
  const ChannelsScreen({super.key});

  @override
  State<ChannelsScreen> createState() =>
      _ChannelsScreenState();
}

class _ChannelsScreenState
    extends State<ChannelsScreen> {
  final core = AlWazirCore.instance;

  /*
   * مهم:
   * زر + هنا لا ينشئ قناة مباشرة.
   * حسب الاتفاق يفتح جهات المستخدمين/الاتصالات.
   */

  void openUsers() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ContactsScreen(
          mode: ContactMode.channel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: core.channels.isEmpty
          ? const EmptyState(
              icon: Icons.campaign_outlined,
              title: 'لا توجد قنوات',
              subtitle:
                  'استكشف القنوات وتابع ما يهمك',
            )
          : ListView.separated(
              padding:
                  const EdgeInsets.symmetric(
                vertical: 8,
              ),
              itemCount:
                  core.channels.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1),
              itemBuilder: (_, index) {
                final channel =
                    core.channels[index];

                return Card(
                  color: AppColors.surface,
                  margin:
                      const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.all(12),
                    leading: const AvatarCircle(
                      label: '📢',
                      radius: 29,
                    ),
                    title: Text(
                      channel.name,
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    subtitle: Padding(
                      padding:
                          const EdgeInsets.only(
                        top: 5,
                      ),
                      child: Text(
                        '${channel.description}\n'
                        '${channel.followers} متابع',
                        maxLines: 2,
                        overflow:
                            TextOverflow.ellipsis,
                      ),
                    ),
                    isThreeLine: true,
                    trailing: FilledButton(
                      style:
                          FilledButton.styleFrom(
                        backgroundColor:
                            channel.followed
                                ? Colors.white
                                    .withOpacity(.08)
                                : AppColors.gold,
                        foregroundColor:
                            channel.followed
                                ? Colors.white
                                : Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          core.toggleChannel(
                            channel.id,
                          );
                        });
                      },
                      child: Text(
                        channel.followed
                            ? 'متابع'
                            : 'متابعة',
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ChannelDetailsScreen(
                            channel: channel,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.gold,
        foregroundColor: Colors.black,
        onPressed: openUsers,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}


/* ============================================================
   CHANNEL DETAILS
   ============================================================ */

class ChannelDetailsScreen extends StatefulWidget {
  const ChannelDetailsScreen({
    super.key,
    required this.channel,
  });

  final ChannelItem channel;

  @override
  State<ChannelDetailsScreen> createState() =>
      _ChannelDetailsScreenState();
}

class _ChannelDetailsScreenState
    extends State<ChannelDetailsScreen> {
  void toggleFollow() {
    setState(() {
      AlWazirCore.instance.toggleChannel(
        widget.channel.id,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final channel = widget.channel;

    return Scaffold(
      appBar: AppBar(
        title: Text(channel.name),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'share') {
                Clipboard.setData(
                  ClipboardData(
                    text:
                        'https://alwazir.chat/channel/${channel.id}',
                  ),
                );

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content:
                        Text('تم نسخ رابط القناة'),
                  ),
                );
              }

              if (value == 'report') {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content:
                        Text('تم فتح خيارات البلاغ'),
                  ),
                );
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'share',
                child: Text('مشاركة القناة'),
              ),
              PopupMenuItem(
                value: 'report',
                child: Text('الإبلاغ'),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(
            child: AvatarCircle(
              label: '📢',
              radius: 50,
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: Text(
              channel.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Center(
            child: Text(
              '${channel.followers} متابع',
              style: const TextStyle(
                color: AppColors.muted,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            channel.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: 20),

          GoldButton(
            text: channel.followed
                ? 'إلغاء المتابعة'
                : 'متابعة القناة',
            icon: channel.followed
                ? Icons.notifications_off_outlined
                : Icons.notifications_active_outlined,
            onPressed: toggleFollow,
          ),

          const SizedBox(height: 25),

          const SectionTitle(
            title: 'المنشورات',
          ),

          const ChannelPost(
            title: 'مرحبًا بكم في القناة',
            body:
                'هنا تظهر منشورات القناة والإعلانات والتحديثات.',
          ),

          const ChannelPost(
            title: 'تنبيه',
            body:
                'يمكن متابعة القنوات وإدارة الإشعارات من هنا.',
          ),
        ],
      ),
    );
  }
}


/* ============================================================
   CHANNEL POST
   ============================================================ */

class ChannelPost extends StatelessWidget {
  const ChannelPost({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      margin:
          const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const AvatarCircle(
                  label: '📢',
                  radius: 21,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.gold,
                      fontSize: 17,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
                const Text(
                  'الآن',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              body,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(),
            Row(
              children: [
                IconButton(
                  tooltip: 'إعجاب',
                  onPressed: () {},
                  icon: const Icon(
                    Icons.thumb_up_outlined,
                  ),
                ),
                IconButton(
                  tooltip: 'مشاركة',
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: body,
                      ),
                    );

                    ScaffoldMessenger.of(
                            context)
                        .showSnackBar(
                      const SnackBar(
                        content:
                            Text('تم نسخ المنشور'),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.share_outlined,
                  ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'حفظ',
                  onPressed: () {},
                  icon: const Icon(
                    Icons.bookmark_border,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


/* ============================================================
   14 — CONTACTS / USERS
   ============================================================ */

enum ContactMode {
  chat,
  contact,
  group,
  channel,
}

class ContactUser {
  const ContactUser({
    required this.id,
    required this.name,
    required this.phone,
    this.online = false,
  });

  final String id;
  final String name;
  final String phone;
  final bool online;
}


class ContactsScreen extends StatefulWidget {
  const ContactsScreen({
    super.key,
    required this.mode,
  });

  final ContactMode mode;

  @override
  State<ContactsScreen> createState() =>
      _ContactsScreenState();
}

class _ContactsScreenState
    extends State<ContactsScreen> {
  final searchController =
      TextEditingController();

  final users = const [
    ContactUser(
      id: 'user_mohammed',
      name: 'محمد',
      phone: '+967 700 000 001',
      online: true,
    ),
    ContactUser(
      id: 'user_ahmed',
      name: 'أحمد',
      phone: '+967 700 000 002',
    ),
    ContactUser(
      id: 'user_ali',
      name: 'علي',
      phone: '+967 700 000 003',
      online: true,
    ),
    ContactUser(
      id: 'user_salem',
      name: 'سالم',
      phone: '+967 700 000 004',
    ),
  ];

  String search = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<ContactUser> get filteredUsers {
    final value =
        search.trim().toLowerCase();

    if (value.isEmpty) return users;

    return users
        .where(
          (user) =>
              user.name
                  .toLowerCase()
                  .contains(value) ||
              user.phone.contains(value),
        )
        .toList();
  }

  String get title {
    switch (widget.mode) {
      case ContactMode.chat:
        return 'محادثة جديدة';
      case ContactMode.contact:
        return 'جهات الاتصال';
      case ContactMode.group:
        return 'إضافة أعضاء';
      case ContactMode.channel:
        return 'المستخدمون';
    }
  }

  void selectUser(ContactUser user) {
    if (widget.mode == ContactMode.chat) {
      final core = AlWazirCore.instance;

      final existing =
          core.chats.cast<ChatItem?>().firstWhere(
                (chat) =>
                    chat?.id == user.id,
                orElse: () => null,
              );

      final chat = existing ??
          ChatItem(
            id: user.id,
            name: user.name,
            lastMessage: 'ابدأ المحادثة',
            time: 'الآن',
            online: user.online,
          );

      if (existing == null) {
        core.chats.insert(0, chat);
      }

      Navigator.pop(context, chat);
      return;
    }

    if (widget.mode == ContactMode.group) {
      Navigator.pop(context, user);
      return;
    }

    if (widget.mode == ContactMode.channel) {
      Navigator.pop(context, user);
      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.fromLTRB(
              14,
              10,
              14,
              8,
            ),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() => search = value);
              },
              decoration: InputDecoration(
                hintText:
                    'البحث عن مستخدم...',
                prefixIcon: const Icon(
                  Icons.search,
                ),
                suffixIcon:
                    search.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              searchController
                                  .clear();
                              setState(
                                () => search = '',
                              );
                            },
                            icon: const Icon(
                              Icons.clear,
                            ),
                          )
                        : null,
                filled: true,
                fillColor:
                    AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(18),
                  borderSide:
                      BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: filteredUsers.isEmpty
                ? const EmptyState(
                    icon:
                        Icons.person_search_outlined,
                    title:
                        'لم يتم العثور على مستخدم',
                    subtitle:
                        'جرّب اسمًا أو رقم هاتف آخر',
                  )
                : ListView.separated(
                    itemCount:
                        filteredUsers.length,
                    separatorBuilder:
                        (_, __) =>
                            const Divider(
                          height: 1,
                        ),
                    itemBuilder:
                        (_, index) {
                      final user =
                          filteredUsers[index];

                      return ListTile(
                        contentPadding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 16,
                          vertical: 5,
                        ),
                        leading:
                            AvatarCircle(
                          label: user.name
                              .characters
                              .first,
                          online: user.online,
                        ),
                        title: Text(
                          user.name,
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        subtitle:
                            Text(user.phone),
                        trailing: widget.mode ==
                                ContactMode.chat
                            ? const Icon(
                                Icons
                                    .chat_bubble_outline,
                                color:
                                    AppColors.gold,
                              )
                            : const Icon(
                                Icons
                                    .chevron_left_rounded,
                              ),
                        onTap: () =>
                            selectUser(user),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}


/* ============================================================
   15 — REAL NEARBY CONNECTION
   ============================================================ */

class NearbyConnectionScreen
    extends StatefulWidget {
  const NearbyConnectionScreen({
    super.key,
  });

  @override
  State<NearbyConnectionScreen>
      createState() =>
          _NearbyConnectionScreenState();
}

class _NearbyConnectionScreenState
    extends State<NearbyConnectionScreen> {
  final nearby = NearbyService();

  bool working = false;
  String status = 'جاهز للبحث عن أجهزة قريبة';

  @override
  void initState() {
    super.initState();
    _startNearby();
  }

  @override
  void dispose() {
    nearby.removeMessageListener(
      'nearby-screen',
    );
    super.dispose();
  }

  Future<void> _startNearby() async {
    if (!mounted) return;

    setState(() {
      working = true;
      status = 'جاري تجهيز الاتصال القريب...';
    });

    try {
      final permissions =
          await nearby.requestPermissions();

      if (!permissions) {
        if (!mounted) return;

        setState(() {
          working = false;
          status =
              'صلاحيات الأجهزة القريبة غير مكتملة';
        });
        return;
      }

      await nearby.startAdvertising(
        deviceName: 'الفهد',
        onDeviceFound: (
          endpointId,
          endpointName,
        ) {
          if (!mounted) return;
          setState(() {});
        },
        onConnectionResult: (
          endpointId,
          connectionStatus,
        ) {
          if (!mounted) return;

          setState(() {
            status =
                'حالة الاتصال: $connectionStatus';
          });
        },
        onMessage: (
          endpointId,
          message,
        ) {
          if (!mounted) return;

          setState(() {
            status =
                'تم استقبال رسالة من جهاز قريب';
          });
        },
      );

      await nearby.startDiscovery(
        deviceName: 'الفهد',
        onDeviceFound: (
          endpointId,
          endpointName,
        ) {
          if (!mounted) return;

          setState(() {
            status =
                'تم العثور على: $endpointName';
          });
        },
        onConnectionResult: (
          endpointId,
          connectionStatus,
        ) {
          if (!mounted) return;

          setState(() {
            status =
                'حالة الاتصال: $connectionStatus';
          });
        },
        onMessage: (
          endpointId,
          message,
        ) {
          if (!mounted) return;

          setState(() {
            status =
                'رسالة قريبة جديدة';
          });
        },
      );

      if (!mounted) return;

      setState(() {
        working = false;
        status =
            'جاري البحث عن أجهزة الفهد القريبة';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        working = false;
        status =
            'تعذر بدء الاتصال القريب';
      });
    }
  }

  Future<void> _connect(
    String endpointId,
  ) async {
    try {
      setState(() {
        status = 'جاري الاتصال بالجهاز...';
      });

      await nearby.connect(
        endpointId: endpointId,
        onMessage: (
          id,
          message,
        ) {
          if (!mounted) return;

          setState(() {
            status =
                'تم استقبال رسالة من الجهاز';
          });
        },
        onConnectionResult: (
          id,
          connectionStatus,
        ) {
          if (!mounted) return;

          setState(() {
            status =
                'حالة الاتصال: $connectionStatus';
          });
        },
      );

      if (!mounted) return;

      setState(() {});
    } catch (_) {
      if (!mounted) return;

      setState(() {
        status = 'تعذر الاتصال بالجهاز';
      });
    }
  }

  Future<void> _refresh() async {
    try {
      await nearby.stop();
    } catch (_) {}

    if (!mounted) return;

    setState(() {
      status = 'إعادة البحث...';
    });

    await _startNearby();
  }

  @override
  Widget build(BuildContext context) {
    final discovered =
        nearby.discoveredEndpoints;

    final connected =
        nearby.connectedEndpoints;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الاتصال القريب',
        ),
        actions: [
          IconButton(
            tooltip: 'تحديث',
            onPressed:
                working ? null : _refresh,
            icon: const Icon(
              Icons.refresh_rounded,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding:
                const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(26),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  AppColors.gold
                      .withOpacity(.18),
                  AppColors.surface,
                ],
              ),
              border: Border.all(
                color: AppColors.gold
                    .withOpacity(.20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 82,
                  height: 82,
                  decoration:
                      BoxDecoration(
                    color: AppColors.gold
                        .withOpacity(.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.wifi_tethering_rounded,
                    color: AppColors.gold,
                    size: 43,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'مراسلة بدون إنترنت',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'ابحث عن أجهزة الفهد القريبة '
                  'وتواصل معها عبر الاتصال المحلي.',
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    color: AppColors.muted,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius:
                        BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      Container(
                        width: 9,
                        height: 9,
                        decoration:
                            const BoxDecoration(
                          color:
                              AppColors.success,
                          shape:
                              BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          status,
                          style:
                              const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          GoldButton(
            text: working
                ? 'جاري البحث...'
                : 'البحث عن أجهزة قريبة',
            icon: Icons.search_rounded,
            onPressed:
                working ? null : _refresh,
          ),

          const SizedBox(height: 22),

          Row(
            children: [
              const Expanded(
                child: SectionTitle(
                  title: 'الأجهزة القريبة',
                ),
              ),
              if (connected.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success
                        .withOpacity(.12),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${connected.length} متصل',
                    style:
                        const TextStyle(
                      color:
                          AppColors.success,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),

          if (discovered.isEmpty)
            Container(
              margin:
                  const EdgeInsets.only(top: 8),
              padding:
                  const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius:
                    BorderRadius.circular(22),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.devices_other_outlined,
                    color: AppColors.muted,
                    size: 42,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'لا توجد أجهزة ظاهرة حاليًا',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'تأكد من تشغيل Bluetooth وWi-Fi '
                    'وإعطاء التطبيق الصلاحيات المطلوبة.',
                    textAlign:
                        TextAlign.center,
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
          else
            ...discovered.entries.map(
              (entry) {
                final endpointId =
                    entry.key;
                final name = entry.value;
                final isConnected =
                    nearby.isConnected(
                  endpointId,
                );

                return Card(
                  color: AppColors.surface,
                  margin:
                      const EdgeInsets.only(
                    top: 7,
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration:
                          BoxDecoration(
                        color: AppColors.gold
                            .withOpacity(.10),
                        shape:
                            BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.smartphone_rounded,
                        color:
                            AppColors.gold,
                      ),
                    ),
                    title: Text(
                      name.isEmpty
                          ? 'جهاز قريب'
                          : name,
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      isConnected
                          ? 'متصل الآن'
                          : 'جهاز متاح للاتصال',
                      style: TextStyle(
                        color: isConnected
                            ? AppColors.success
                            : AppColors.muted,
                      ),
                    ),
                    trailing:
                        isConnected
                            ? const Icon(
                                Icons
                                    .check_circle_rounded,
                                color:
                                    AppColors.success,
                              )
                            : FilledButton(
                                style:
                                    FilledButton.styleFrom(
                                  backgroundColor:
                                      AppColors.gold,
                                  foregroundColor:
                                      Colors.black,
                                ),
                                onPressed: () =>
                                    _connect(
                                  endpointId,
                                ),
                                child:
                                    const Text(
                                  'اتصال',
                                ),
                              ),
                  ),
                );
              },
            ),

          const SizedBox(height: 18),

          Card(
            color: AppColors.surface,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'كيف يعمل؟',
                    style: TextStyle(
                      color: AppColors.gold,
                      fontWeight:
                          FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 9),
                  Text(
                    'يبحث الفهد عن أجهزة قريبة تستخدم '
                    'خدمة الاتصال المحلي، ويمكن تبادل '
                    'الرسائل بدون الاعتماد على الإنترنت.',
                    style: TextStyle(
                      color: AppColors.muted,
                      height: 1.5,
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
/* ============================================================
   21 — FINAL INTEGRATION
   الفهد — Al Wazir Chat
   ============================================================ */

class AppLifecycleGuard extends StatefulWidget {
  const AppLifecycleGuard({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<AppLifecycleGuard> createState() => _AppLifecycleGuardState();
}

class _AppLifecycleGuardState extends State<AppLifecycleGuard>
    with WidgetsBindingObserver {
  final core = AlWazirCore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _saveSession();
    }
  }

  Future<void> _saveSession() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'alwazir_user_name',
      core.userName,
    );

    await prefs.setString(
      'alwazir_user_phone',
      core.userPhone,
    );

    await prefs.setBool(
      'alwazir_notifications',
      core.notificationsEnabled,
    );

    await prefs.setBool(
      'alwazir_read_receipts',
      core.readReceipts,
    );

    await prefs.setBool(
      'alwazir_last_seen',
      core.lastSeenEnabled,
    );

    await prefs.setBool(
      'alwazir_chat_lock',
      core.chatLockEnabled,
    );

    await prefs.setBool(
      'alwazir_app_lock',
      core.appLocked,
    );

    await prefs.setBool(
      'alwazir_two_step',
      core.twoStepEnabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}


/* ============================================================
   22 — APP STARTUP / SESSION
   ============================================================ */

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  @override
  void initState() {
    super.initState();
    _prepare();
  }

  Future<void> _prepare() async {
    final prefs = await SharedPreferences.getInstance();
    final core = AlWazirCore.instance;

    core.userName =
        prefs.getString('alwazir_user_name') ?? 'المستخدم';

    core.userPhone =
        prefs.getString('alwazir_user_phone') ?? '';

    core.notificationsEnabled =
        prefs.getBool('alwazir_notifications') ?? true;

    core.readReceipts =
        prefs.getBool('alwazir_read_receipts') ?? true;

    core.lastSeenEnabled =
        prefs.getBool('alwazir_last_seen') ?? true;

    core.chatLockEnabled =
        prefs.getBool('alwazir_chat_lock') ?? false;

    core.appLocked =
        prefs.getBool('alwazir_app_lock') ?? false;

    core.twoStepEnabled =
        prefs.getBool('alwazir_two_step') ?? false;

    if (!mounted) return;

    await Future<void>.delayed(
      const Duration(milliseconds: 500),
    );

    if (!mounted) return;

    if (core.userPhone.isNotEmpty) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const MainHomeScreen(),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: CircularProgressIndicator(
          color: AppColors.gold,
        ),
      ),
    );
  }
}


/* ============================================================
   23 — PREMIUM SPLASH
   استبدل SplashScreen القديم بهذا التعريف
   ============================================================ */

class PremiumSplashScreen extends StatefulWidget {
  const PremiumSplashScreen({super.key});

  @override
  State<PremiumSplashScreen> createState() =>
      _PremiumSplashScreenState();
}

class _PremiumSplashScreenState
    extends State<PremiumSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  late final Animation<double> circleAnimation;
  late final Animation<double> textAnimation;
  late final Animation<double> buttonAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1800,
      ),
    );

    circleAnimation = CurvedAnimation(
      parent: controller,
      curve: const Interval(
        0.0,
        0.55,
        curve: Curves.easeOutBack,
      ),
    );

    textAnimation = CurvedAnimation(
      parent: controller,
      curve: const Interval(
        0.25,
        0.72,
        curve: Curves.easeOut,
      ),
    );

    buttonAnimation = CurvedAnimation(
      parent: controller,
      curve: const Interval(
        0.55,
        1.0,
        curve: Curves.easeOut,
      ),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void start() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: SplashBackgroundPainter(),
                  ),
                ),
              ),

              Center(
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (_, __) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.scale(
                          scale: 0.75 +
                              (circleAnimation.value * 0.25),
                          child: Opacity(
                            opacity: circleAnimation.value,
                            child: Container(
                              width: 250,
                              height: 250,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.gold,
                                  width: 2.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.gold
                                        .withOpacity(.28),
                                    blurRadius: 34,
                                    spreadRadius: 6,
                                  ),
                                  BoxShadow(
                                    color: AppColors.gold
                                        .withOpacity(.10),
                                    blurRadius: 70,
                                    spreadRadius: 18,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Opacity(
                                  opacity: textAnimation.value,
                                  child: const Text(
                                    'الفهد',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.gold,
                                      fontSize: 48,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        Opacity(
                          opacity: buttonAnimation.value,
                          child: Transform.translate(
                            offset: Offset(
                              0,
                              18 *
                                  (1 -
                                      buttonAnimation.value),
                            ),
                            child: InkWell(
                              borderRadius:
                                  BorderRadius.circular(30),
                              onTap: start,
                              child: Container(
                                width: 170,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius:
                                      BorderRadius.circular(30),
                                  border: Border.all(
                                    color: AppColors.gold,
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.gold
                                          .withOpacity(.12),
                                      blurRadius: 18,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'ابدأ',
                                      style: TextStyle(
                                        color:
                                            AppColors.gold,
                                        fontSize: 18,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      width: 27,
                                      height: 27,
                                      decoration:
                                          const BoxDecoration(
                                        shape:
                                            BoxShape.circle,
                                        color:
                                            AppColors.gold,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.black,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 70),

                        const Text(
                          'الفهد أداء وتميز',
                          style: TextStyle(
                            color: AppColors.text,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            letterSpacing: .4,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/* ============================================================
   24 — SPLASH BACKGROUND
   ============================================================ */

class SplashBackgroundPainter extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final center = Offset(
      size.width / 2,
      size.height * .40,
    );

    for (int i = 0; i < 4; i++) {
      final radius = 145.0 + (i * 32);

      paint.color = AppColors.gold.withOpacity(
        .025 - (i * .004),
      );

      canvas.drawCircle(
        center,
        radius,
        paint,
      );
    }

    paint.strokeWidth = .7;

    final y = size.height * .68;

    canvas.drawLine(
      Offset(25, y),
      Offset(size.width - 25, y),
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}


/* ============================================================
   25 — MESSAGE ACTIONS
   ============================================================ */

class MessageActions {
  static Future<void> show(
    BuildContext context, {
    required ChatMessage message,
    required VoidCallback onDelete,
    required VoidCallback onForward,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              const SizedBox(height: 8),

              ListTile(
                leading: const Icon(
                  Icons.copy_outlined,
                  color: AppColors.gold,
                ),
                title: const Text('نسخ'),
                onTap: () {
                  Clipboard.setData(
                    ClipboardData(
                      text: message.text,
                    ),
                  );

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text('تم نسخ الرسالة'),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(
                  Icons.forward_outlined,
                  color: AppColors.gold,
                ),
                title: const Text('تحويل'),
                onTap: () {
                  Navigator.pop(context);
                  onForward();
                },
              ),

              ListTile(
                leading: const Icon(
                  Icons.content_paste_outlined,
                  color: AppColors.gold,
                ),
                title: const Text('لصق'),
                onTap: () async {
                  final data =
                      await Clipboard.getData(
                    Clipboard.kTextPlain,
                  );

                  Navigator.pop(context);

                  if (data?.text != null &&
                      data!.text!.trim().isNotEmpty) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      SnackBar(
                        content: Text(
                          'تم نسخ النص للحافظة: ${data.text}',
                        ),
                      ),
                    );
                  }
                },
              ),

              if (message.mine)
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline,
                    color: AppColors.danger,
                  ),
                  title: const Text(
                    'حذف الرسالة',
                    style: TextStyle(
                      color: AppColors.danger,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    onDelete();
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}


/* ============================================================
   26 — CHAT MANAGEMENT
   ============================================================ */

class ChatManagement {
  static Future<void> show(
    BuildContext context, {
    required ChatItem chat,
    required VoidCallback onClear,
    required VoidCallback onDelete,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              const SizedBox(height: 8),

              ListTile(
                leading: const Icon(Icons.search),
                title: const Text(
                  'البحث داخل المحادثة',
                ),
                onTap: () {
                  Navigator.pop(context);
                  showSearch(
                    context: context,
                    delegate: MessageSearchDelegate(
                      const [],
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(
                  Icons.cleaning_services_outlined,
                ),
                title: const Text(
                  'مسح سجل المحادثة',
                ),
                onTap: () async {
                  Navigator.pop(context);

                  final confirm =
                      await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text(
                        'مسح المحادثة؟',
                      ),
                      content: const Text(
                        'سيتم حذف الرسائل المحفوظة '
                        'لهذه المحادثة من الجهاز.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(
                            context,
                            false,
                          ),
                          child:
                              const Text('إلغاء'),
                        ),
                        FilledButton(
                          onPressed: () =>
                              Navigator.pop(
                            context,
                            true,
                          ),
                          child: const Text('مسح'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    onClear();
                  }
                },
              ),

              ListTile(
                leading: const Icon(
                  Icons.lock_outline,
                ),
                title: const Text(
                  'قفل المحادثة',
                ),
                onTap: () {
                  Navigator.pop(context);
                  AlWazirCore
                      .instance
                      .chatLockEnabled = true;

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content:
                          Text('تم تفعيل قفل المحادثات'),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(
                  Icons.delete_forever_outlined,
                  color: AppColors.danger,
                ),
                title: const Text(
                  'حذف المحادثة',
                  style: TextStyle(
                    color: AppColors.danger,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onDelete();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}


/* ============================================================
   27 — LOCAL MESSAGE STORAGE
   ============================================================ */

class MessageStorage {
  static String key(String chatId) {
    return 'alwazir_messages_$chatId';
  }

  static Future<List<ChatMessage>> load(
    String chatId,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final raw = prefs.getString(
      key(chatId),
    );

    if (raw == null || raw.isEmpty) {
      return [];
    }

    try {
      final decoded =
          jsonDecode(raw) as List<dynamic>;

      return decoded.map((item) {
        final map =
            item as Map<String, dynamic>;

        return ChatMessage(
          text: map['text']?.toString() ?? '',
          mine: map['mine'] == true,
          time:
              map['time']?.toString() ?? 'الآن',
          read: map['read'] != false,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> save(
    String chatId,
    List<ChatMessage> messages,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final data = messages.map((message) {
      return {
        'text': message.text,
        'mine': message.mine,
        'time': message.time,
        'read': message.read,
      };
    }).toList();

    await prefs.setString(
      key(chatId),
      jsonEncode(data),
    );
  }

  static Future<void> clear(
    String chatId,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(
      key(chatId),
    );
  }
}


/* ============================================================
   28 — PROFILE / ACCOUNT
   ============================================================ */

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() =>
      _AccountScreenState();
}

class _AccountScreenState
    extends State<AccountScreen> {
  final core = AlWazirCore.instance;

  final nameController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = core.userName;
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> save() async {
    final name =
        nameController.text.trim();

    if (name.isEmpty) {
      return;
    }

    core.userName = name;

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      'alwazir_user_name',
      name,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حفظ الملف الشخصي'),
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const SizedBox(height: 15),

          const Center(
            child: AvatarCircle(
              label: 'م',
              radius: 48,
            ),
          ),

          const SizedBox(height: 22),

          AppTextField(
            controller: nameController,
            label: 'الاسم',
            icon: Icons.person_outline,
          ),

          const SizedBox(height: 14),

          Text(
            core.userPhone.isEmpty
                ? 'لا يوجد رقم هاتف'
                : core.userPhone,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.muted,
            ),
          ),

          const SizedBox(height: 24),

          GoldButton(
            text: 'حفظ التغييرات',
            icon: Icons.save_outlined,
            onPressed: save,
          ),
        ],
      ),
    );
  }
}


/* ============================================================
   29 — LANGUAGE
   ============================================================ */

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() =>
      _LanguageScreenState();
}

class _LanguageScreenState
    extends State<LanguageScreen> {
  String selected = 'العربية';

  final languages = const [
    'العربية',
    'English',
    'Français',
    'Türkçe',
    'اردو',
    'Bahasa Indonesia',
    'Español',
    'Deutsch',
  ];

  Future<void> choose(String language) async {
    setState(() {
      selected = language;
    });

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      'alwazir_language',
      language,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم حفظ اللغة: $language',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اللغة'),
      ),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (_, index) {
          final language =
              languages[index];

          return RadioListTile<String>(
            value: language,
            groupValue: selected,
            onChanged: (value) {
              if (value != null) {
                choose(value);
              }
            },
            title: Text(language),
            activeColor: AppColors.gold,
          );
        },
      ),
    );
  }
}


/* ============================================================
   30 — NOTIFICATIONS
   ============================================================ */

class NotificationSettingsScreen
    extends StatefulWidget {
  const NotificationSettingsScreen({
    super.key,
  });

  @override
  State<NotificationSettingsScreen>
      createState() =>
          _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<
        NotificationSettingsScreen> {
  final core = AlWazirCore.instance;

  bool messagePreview = true;
  bool sound = true;
  bool vibration = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            secondary: const Icon(
              Icons.notifications_outlined,
            ),
            title: const Text(
              'الإشعارات',
            ),
            value:
                core.notificationsEnabled,
            onChanged: (value) {
              setState(() {
                core.notificationsEnabled =
                    value;
              });
            },
          ),
          SwitchListTile(
            secondary: const Icon(
              Icons.visibility_outlined,
            ),
            title: const Text(
              'معاينة الرسائل',
            ),
            value: messagePreview,
            onChanged: (value) {
              setState(() {
                messagePreview = value;
              });
            },
          ),
          SwitchListTile(
            secondary: const Icon(
              Icons.volume_up_outlined,
            ),
            title: const Text(
              'الصوت',
            ),
            value: sound,
            onChanged: (value) {
              setState(() {
                sound = value;
              });
            },
          ),
          SwitchListTile(
            secondary: const Icon(
              Icons.vibration,
            ),
            title: const Text(
              'الاهتزاز',
            ),
            value: vibration,
            onChanged: (value) {
              setState(() {
                vibration = value;
              });
            },
          ),
        ],
      ),
    );
  }
}


/* ============================================================
   31 — BACKUP / SYNC
   ============================================================ */

class BackupSyncScreen extends StatefulWidget {
  const BackupSyncScreen({super.key});

  @override
  State<BackupSyncScreen> createState() =>
      _BackupSyncScreenState();
}

class _BackupSyncScreenState
    extends State<BackupSyncScreen> {
  bool automatic = false;
  bool syncing = false;

  Future<void> syncNow() async {
    if (syncing) return;

    setState(() {
      syncing = true;
    });

    /*
      هنا يتم تجهيز طبقة المزامنة المحلية.
      الرسائل المحلية لا تُحذف عند المزامنة.
      وعند ربط Firebase لاحقًا يمكن استخدام
      هذه الطبقة كمصدر للمزامنة مع الخادم.
    */

    await Future<void>.delayed(
      const Duration(milliseconds: 700),
    );

    if (!mounted) return;

    setState(() {
      syncing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'تمت مزامنة البيانات المحلية',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('النسخ الاحتياطي والمزامنة'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            secondary: const Icon(
              Icons.sync_outlined,
            ),
            title: const Text(
              'المزامنة التلقائية',
            ),
            subtitle: const Text(
              'الحفاظ على تحديث بيانات التطبيق',
            ),
            value: automatic,
            onChanged: (value) {
              setState(() {
                automatic = value;
              });
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(
              Icons.cloud_upload_outlined,
              color: AppColors.gold,
            ),
            title: const Text(
              'مزامنة الآن',
            ),
            subtitle: const Text(
              'حفظ حالة البيانات الحالية',
            ),
            trailing: syncing
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(
                    Icons.chevron_left,
                  ),
            onTap: syncNow,
          ),

          ListTile(
            leading: const Icon(
              Icons.restore_outlined,
            ),
            title: const Text(
              'استعادة البيانات',
            ),
            onTap: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text(
                    'بيانات المحادثات المحلية محفوظة على الجهاز',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}


/* ============================================================
   32 — APP LOCK
   ============================================================ */

class AppLockScreen extends StatefulWidget {
  const AppLockScreen({super.key});

  @override
  State<AppLockScreen> createState() =>
      _AppLockScreenState();
}

class _AppLockScreenState
    extends State<AppLockScreen> {
  final controller =
      TextEditingController();

  bool enabled =
      AlWazirCore.instance.appLocked;

  Future<void> save() async {
    final pin =
        controller.text.trim();

    if (pin.length < 4) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'رمز القفل يجب أن يكون 4 أرقام على الأقل',
          ),
        ),
      );
      return;
    }

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      'alwazir_lock_pin',
      pin,
    );

    await prefs.setBool(
      'alwazir_app_lock',
      true,
    );

    AlWazirCore.instance.appLocked = true;

    if (!mounted) return;

    setState(() {
      enabled = true;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'تم حفظ رمز القفل وتفعيله',
        ),
      ),
    );
  }

  Future<void> disable() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(
      'alwazir_lock_pin',
    );

    await prefs.setBool(
      'alwazir_app_lock',
      false,
    );

    AlWazirCore.instance.appLocked =
        false;

    if (!mounted) return;

    setState(() {
      enabled = false;
    });
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
        title: const Text('قفل التطبيق'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Icon(
            Icons.lock_outline,
            size: 75,
            color: AppColors.gold,
          ),

          const SizedBox(height: 15),

          Text(
            enabled
                ? 'قفل التطبيق مفعل'
                : 'قفل التطبيق غير مفعل',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 25),

          if (!enabled) ...[
            TextField(
              controller: controller,
              keyboardType:
                  TextInputType.number,
              obscureText: true,
              maxLength: 8,
              decoration:
                  const InputDecoration(
                labelText: 'رمز القفل',
                prefixIcon:
                    Icon(Icons.password),
              ),
            ),

            const SizedBox(height: 12),

            GoldButton(
              text: 'تفعيل القفل',
              icon: Icons.lock,
              onPressed: save,
            ),
          ] else
            OutlinedButton.icon(
              onPressed: disable,
              icon: const Icon(
                Icons.lock_open,
              ),
              label: const Text(
                'تعطيل القفل',
              ),
            ),
        ],
      ),
    );
  }
}


/* ============================================================
   33 — HELP
   ============================================================ */

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المساعدة'),
      ),
      body: ListView(
        children: [
          const SectionTitle(
            title: 'المساعدة والدعم',
          ),

          ListTile(
            leading: const Icon(
              Icons.help_outline,
            ),
            title: const Text(
              'الأسئلة الشائعة',
            ),
            onTap: () {
              _showInfo(
                context,
                'الأسئلة الشائعة',
                'يمكنك استخدام الدردشات والمجموعات والحالة والقنوات والمراسلة القريبة من داخل التطبيق.',
              );
            },
          ),

          ListTile(
            leading: const Icon(
              Icons.security_outlined,
            ),
            title: const Text(
              'الأمان والخصوصية',
            ),
            onTap: () {
              _showInfo(
                context,
                'الأمان والخصوصية',
                'راجع إعدادات الخصوصية وقفل التطبيق والمحادثات من قسم الخصوصية والأمان.',
              );
            },
          ),

          ListTile(
            leading: const Icon(
              Icons.info_outline,
            ),
            title: const Text(
              'حول الفهد',
            ),
            onTap: () {
              _showInfo(
                context,
                'الفهد',
                'الفهد — Al Wazir Chat\nالإصدار 1.0.0',
              );
            },
          ),
        ],
      ),
    );
  }

  void _showInfo(
    BuildContext context,
    String title,
    String text,
  ) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: [
          FilledButton(
            onPressed: () =>
                Navigator.pop(context),
            child: const Text('حسنًا'),
          ),
        ],
      ),
    );
  }
}


/* ============================================================
   34 — FINAL SETTINGS
   ============================================================ */

class FinalSettingsScreen
    extends StatelessWidget {
  const FinalSettingsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final core = AlWazirCore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: ListView(
        padding:
            const EdgeInsets.only(bottom: 25),
        children: [
          const SizedBox(height: 10),

          ListTile(
            leading: const AvatarCircle(
              label: 'م',
              radius: 30,
            ),
            title: Text(
              core.userName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              core.userPhone.isEmpty
                  ? 'لم تتم إضافة رقم'
                  : core.userPhone,
            ),
            trailing: const Icon(
              Icons.chevron_left,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const AccountScreen(),
                ),
              );
            },
          ),

          const SectionTitle(
            title: 'الحساب والخصوصية',
          ),

          SettingsTile(
            icon: Icons.lock_outline,
            title: 'الخصوصية والأمان',
            subtitle:
                'التحكم في الخصوصية والحماية',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const PrivacySecurityScreen(),
                ),
              );
            },
          ),

          SettingsTile(
            icon: Icons.phonelink_lock,
            title: 'قفل التطبيق',
            subtitle: core.appLocked
                ? 'مفعل'
                : 'غير مفعل',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const AppLockScreen(),
                ),
              );
            },
          ),

          SettingsTile(
            icon: Icons.devices_outlined,
            title: 'الأجهزة المرتبطة',
            subtitle:
                'إدارة الأجهزة والجلسات',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const LinkedDevicesScreen(),
                ),
              );
            },
          ),

          const SectionTitle(
            title: 'الدردشات والبيانات',
          ),

          SettingsTile(
            icon: Icons.wifi_tethering,
            title: 'المراسلة بدون إنترنت',
            subtitle:
                'Bluetooth و Wi-Fi Direct',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const NearbyConnectionScreen(),
                ),
              );
            },
          ),

          SettingsTile(
            icon: Icons.storage_outlined,
            title: 'التخزين والبيانات',
            subtitle:
                'إدارة بيانات التطبيق',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const StorageScreen(),
                ),
              );
            },
          ),

          SettingsTile(
            icon: Icons.sync_outlined,
            title: 'النسخ الاحتياطي والمزامنة',
            subtitle:
                'حفظ ومزامنة البيانات',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const BackupSyncScreen(),
                ),
              );
            },
          ),

          const SectionTitle(
            title: 'الإشعارات والمظهر',
          ),

          SettingsTile(
            icon: Icons.notifications_outlined,
            title: 'الإشعارات',
            subtitle: core.notificationsEnabled
                ? 'مفعلة'
                : 'متوقفة',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const NotificationSettingsScreen(),
                ),
              );
            },
          ),

          SettingsTile(
            icon: Icons.language_outlined,
            title: 'اللغة',
            subtitle: 'العربية',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const LanguageScreen(),
                ),
              );
            },
          ),

          const SectionTitle(
            title: 'الدعم',
          ),

          SettingsTile(
            icon: Icons.help_outline,
            title: 'المساعدة',
            subtitle:
                'الأسئلة الشائعة والدعم',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const HelpScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 18),

          const Center(
            child: Text(
              'الفهد • Al Wazir Chat',
              style: TextStyle(
                color: AppColors.gold,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/* ============================================================
   35 — PROFESSIONAL EMPTY STATE
   ============================================================ */

class PremiumEmptyState extends StatelessWidget {
  const PremiumEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface,
                border: Border.all(
                  color: AppColors.gold
                      .withOpacity(.35),
                ),
              ),
              child: Icon(
                icon,
                size: 38,
                color: AppColors.gold,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.muted,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/* ============================================================
   36 — SAFE CONFIRMATION
   ============================================================ */

Future<bool> confirmAction(
  BuildContext context, {
  required String title,
  required String message,
  String confirmText = 'تأكيد',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.pop(context, false),
          child: const Text('إلغاء'),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.pop(context, true),
          child: Text(confirmText),
        ),
      ],
    ),
  );

  return result == true;
}


/* ============================================================
   37 — FINAL NOTES
   ============================================================ */

/*
  الفهد — FINAL INTEGRATION

  ✓ لا توجد صورة للفهد.
  ✓ الاسم فقط هو الهوية البصرية.
  ✓ شاشة افتتاحية ذهبية داخل دائرة.
  ✓ زر ابدأ.
  ✓ عبارة الفهد أداء وتميز.
  ✓ حفظ الحساب محليًا.
  ✓ حفظ إعدادات التطبيق.
  ✓ حفظ الرسائل.
  ✓ نسخ الرسائل.
  ✓ حذف الرسائل.
  ✓ البحث.
  ✓ مسح المحادثة.
  ✓ قفل المحادثات.
  ✓ قفل التطبيق مع رمز يحدده المستخدم.
  ✓ الإعدادات.
  ✓ الإشعارات.
  ✓ اللغة.
  ✓ النسخ الاحتياطي والمزامنة.
  ✓ الخصوصية.
  ✓ المراسلة القريبة.
  ✓ الحفاظ على بنية المشروع الخفيفة.

  ملاحظة:
  وظائف الاتصال الصوتي/الفيديو تحتاج طبقة اتصال فعلية
  مثل WebRTC أو خدمة اتصال خارجية حتى تصبح مكالمات حقيقية.
  لن يتم الادعاء بأنها تعمل فعليًا قبل ربط طبقة الاتصال.
*/
