import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
                'أدخل رقم هاتفك للاشتراك',
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

class MessageItem {
  final String text;
  final String? imagePath;
  final bool isMe;
  final String time;
  String status; // 'sent', 'delivered', 'read'

  MessageItem({
    required this.text,
    this.imagePath,
    required this.isMe,
    required this.time,
    this.status = 'sent',
  });
}

class ChatsTab extends StatefulWidget {
  const ChatsTab({super.key});

  @override
  State<ChatsTab> createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> {
  final List<MessageItem> _messages = [];
  final TextEditingController _msgController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool _isBlocked = false;

  void _sendMessage({String? imagePath}) {
    if (_isBlocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يمكنك المراسلة، المستخدم محظور.')),
      );
      return;
    }

    if (_msgController.text.trim().isEmpty && imagePath == null) return;

    final newMsg = MessageItem(
      text: _msgController.text.trim(),
      imagePath: imagePath,
      isMe: true,
      time: "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}",
      status: 'sent',
    );

    setState(() {
      _messages.add(newMsg);
      _msgController.clear();
    });

    // محاكاة تغير الحالة إلى استلام وقراءة
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => newMsg.status = 'delivered');
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => newMsg.status = 'read');
      }
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _sendMessage(imagePath: image.path);
    }
  }

  void _toggleBlock() {
    setState(() {
      _isBlocked = !_isBlocked;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isBlocked ? 'تم حظر المستلم' : 'تم إلغاء الحظر')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E232A),
        title: Row(
          children: [
            const Text('👑 ', style: TextStyle(fontSize: 20)),
            Text(
              _isBlocked ? 'مستخدم محظور' : 'Al-Wazir Chat',
              style: TextStyle(color: _isBlocked ? Colors.red : const Color(0xFFD4AF37)),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Color(0xFFD4AF37)),
            onSelected: (val) {
              if (val == 'block') _toggleBlock();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'block',
                child: Text(_isBlocked ? 'إلغاء الحظر' : 'حظر المستخدم'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: Text(
                      'أرسل رسالة لبدء المحادثة',
                      style: TextStyle(color: Colors.white54, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      return Align(
                        alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: msg.isMe ? const Color(0xFF332900) : const Color(0xFF222222),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: msg.isMe ? const Color(0xFFD4AF37) : Colors.grey.shade800,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAlignment.end,
                            children: [
                              if (msg.imagePath != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(msg.imagePath!),
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              if (msg.text.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    msg.text,
                                    style: const TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    msg.time,
                                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                                  ),
                                  const SizedBox(width: 4),
                                  if (msg.isMe) ...[
                                    if (msg.status == 'sent')
                                      const Icon(Icons.check, size: 14, color: Colors.grey),
                                    if (msg.status == 'delivered')
                                      const Icon(Icons.done_all, size: 14, color: Colors.grey),
                                    if (msg.status == 'read')
                                      const Icon(Icons.done_all, size: 14, color: Color(0xFFD4AF37)),
                                  ]
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            color: const Color(0xFF181818),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image, color: Color(0xFFD4AF37)),
                  onPressed: _pickImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    enabled: !_isBlocked,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: _isBlocked ? 'لا يمكنك الكتابة لمستخدم محظور' : 'اكتب رسالة...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFFD4AF37)),
                  onPressed: () => _sendMessage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatusItem {
  final String title;
  final String time;
  final String privacy;

  StatusItem({required this.title, required this.time, required this.privacy});
}

class StatusTab extends StatefulWidget {
  const StatusTab({super.key});

  @override
  State<StatusTab> createState() => _StatusTabState();
}

class _StatusTabState extends State<StatusTab> {
  final List<StatusItem> _statuses = [];
  String _privacySetting = 'جهات اتصالي';

  void _addStatus() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E232A),
      builder: (context) {
        final TextEditingController statusText = TextEditingController();
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('إضافة حالة جديدة (تنتهي بعد 24 ساعة)',
                  style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextField(
                controller: statusText,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'اكتب حالتك هنا...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                dropdownColor: const Color(0xFF1E232A),
                value: _privacySetting,
                isExpanded: true,
                items: ['الجميع', 'جهات اتصالي', 'جهات اتصالي باستثناء...']
                    .map((val) => DropdownMenuItem(
                          value: val,
                          child: Text('من يستطيع المشاهدة: $val', style: const TextStyle(color: Colors.white)),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _privacySetting = val);
                  }
                },
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37)),
                onPressed: () {
                  if (statusText.text.isNotEmpty) {
                    setState(() {
                      _statuses.add(
                        StatusItem(
                          title: statusText.text,
                          time: 'الآن (تختفي خلال 24 ساعة)',
                          privacy: _privacySetting,
                        ),
                      );
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('نشر الحالة', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E232A),
        centerTitle: true,
        title: const Text('الحالات', style: TextStyle(color: Color(0xFFD4AF37))),
      ),
      body: _statuses.isEmpty
          ? const Center(
              child: Text('لا توجد حالات حالياً', style: TextStyle(color: Colors.white54, fontSize: 16)),
            )
          : ListView.builder(
              itemCount: _statuses.length,
              itemBuilder: (context, index) {
                final item = _statuses[index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFD4AF37),
                    child: Icon(Icons.person, color: Colors.black),
                  ),
                  title: Text(item.title, style: const TextStyle(color: Colors.white)),
                  subtitle: Text('${item.time} • الخصوصية: ${item.privacy}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD4AF37),
        onPressed: _addStatus,
        child: const Icon(Icons.add_a_photo, color: Colors.black),
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
