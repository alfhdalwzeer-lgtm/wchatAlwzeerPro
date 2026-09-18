import 'package:flutter/material.dart';

void main() {
  runApp(const AlWazirChatApp());
}

class AppColors {
  static const Color background = Color(0xFF111820);
  static const Color cardBg = Color(0xFF1A232E);
  static const Color gold = Color(0xFFE5B842);
  static const Color goldDark = Color(0xFF8A6D22);
  static const Color textWhite = Colors.white;
  static const Color textGrey = Colors.grey;
}

class AlWazirChatApp extends StatelessWidget {
  const AlWazirChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'الفهد',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
        ),
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
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const ChatsScreen(),
    const GroupsScreen(),
    const CallsScreen(),
    const StatusScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: AppColors.gold,
        unselectedItemColor: AppColors.textGrey,
        backgroundColor: AppColors.cardBg,
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
            icon: Icon(Icons.donut_large),
            label: 'الحالة',
          ),
        ],
      ),
    );
  }
}

// ------------------- شاشة الدردشات -------------------
class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الفهد',
          style: TextStyle(
            color: AppColors.gold,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.camera_alt_outlined), onPressed: () {}),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'settings') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: 'profile', child: Text('الملف الشخصي')),
              const PopupMenuItem(value: 'contacts', child: Text('جهات الاتصال')),
              const PopupMenuItem(value: 'calls', child: Text('المكالمات')),
              const PopupMenuItem(value: 'settings', child: Text('الإعدادات')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.cardBg,
              child: Icon(Icons.person, color: AppColors.gold),
            ),
            title: const Text('مستخدم الفهد', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: const Text('وعليكم السلام! تطبيق ممتاز جداً.', style: TextStyle(color: Colors.grey)),
            trailing: const Text('10:01 ص', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.gold,
                    child: Icon(Icons.star, color: Colors.black),
                  ),
                  title: Text('الفهد', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text('مرحباً بك في التطبيق', style: TextStyle(color: Colors.grey)),
                  trailing: Text('09:45 ص', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black46,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.gold, width: 1),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.pets, size: 60, color: AppColors.gold),
                      SizedBox(height: 10),
                      Text(
                        'الفهد أداء وتميز',
                        style: TextStyle(color: AppColors.gold, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.gold,
        onPressed: () {},
        child: const Icon(Icons.chat_bubble, color: Colors.black),
      ),
    );
  }
}

// ------------------- شاشة المجموعات -------------------
class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المجموعات', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold)),
      ),
      body: const Center(
        child: Text('لا توجد مجموعات حالياً', style: TextStyle(color: AppColors.textGrey, fontSize: 18)),
      ),
    );
  }
}

// ------------------- شاشة المكالمات -------------------
class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المكالمات', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold)),
      ),
      body: const Center(
        child: Text('سجل المكالمات فارغ', style: TextStyle(color: AppColors.textGrey, fontSize: 18)),
      ),
    );
  }
}

// ------------------- شاشة الحالة -------------------
class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الفهد', style: TextStyle(color: AppColors.gold, fontSize: 26, fontWeight: FontWeight.bold)),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'settings') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: 'profile', child: Text('الملف الشخصي')),
              const PopupMenuItem(value: 'contacts', child: Text('جهات الاتصال')),
              const PopupMenuItem(value: 'calls', child: Text('المكالمات')),
              const PopupMenuItem(value: 'settings', child: Text('الإعدادات')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.gold,
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
                  Icon(Icons.auto_awesome, size: 50, color: AppColors.gold),
                  SizedBox(height: 10),
                  Text('لا توجد حالات بعد', style: TextStyle(color: AppColors.textGrey, fontSize: 18)),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.gold,
        onPressed: () {},
        child: const Icon(Icons.camera_alt, color: Colors.black),
      ),
    );
  }
}

// ------------------- شاشة الإعدادات -------------------
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notifications = true;
  bool sounds = true;
  bool vibration = true;
  bool readReceipts = true;
  bool online = true;
  bool saveMedia = true;
  bool autoImages = true;
  bool autoAudio = true;
  bool darkMode = true;

  Widget sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.gold, size: 26),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.gold,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget toggle(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.gold,
      activeTrackColor: AppColors.goldDark,
      title: Text(title, style: const TextStyle(fontSize: 18, color: Colors.white)),
      subtitle: subtitle.isEmpty ? null : Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }

  Widget arrow(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
      leading: Icon(icon, color: AppColors.gold, size: 26),
      title: Text(title, style: const TextStyle(fontSize: 18, color: Colors.white)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      trailing: const Icon(Icons.chevron_right, size: 26, color: Colors.grey),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'الإعدادات',
          style: TextStyle(color: AppColors.gold, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          sectionTitle('الحساب', Icons.account_circle),
          arrow('الملف الشخصي', 'الاسم والصورة والنبذة', Icons.person, () {}),
          const Divider(color: Colors.white10),
          sectionTitle('الإشعارات', Icons.notifications),
          toggle('إشعارات الرسائل', 'إظهار إشعار عند وصول رسالة جديدة', notifications, (v) => setState(() => notifications = v)),
          toggle('أصوات الإشعارات', '', sounds, (v) => setState(() => sounds = v)),
          toggle('الاهتزاز', '', vibration, (v) => setState(() => vibration = v)),
          toggle('معاينة الرسائل', 'إظهار محتوى الرسالة في الإشعار', true, (v) {}),
          const Divider(color: Colors.white10),
          sectionTitle('الخصوصية والأمان', Icons.lock),
          toggle('إيصالات القراءة', 'إظهار علامة قراءة الرسائل', readReceipts, (v) => setState(() => readReceipts = v)),
          toggle('حالة الاتصال', 'السماح للآخرين برؤية حالة اتصالك', online, (v) => setState(() => online = v)),
          arrow('الأمان', 'إعدادات حماية الحساب', Icons.security, () {}),
          const Divider(color: Colors.white10),
          sectionTitle('الدردشات', Icons.chat_bubble),
          arrow('حجم الخط', 'متوسط', Icons.text_fields, () {}),
          toggle('حفظ الوسائط', 'حفظ الصور والوسائط على الجهاز', saveMedia, (v) => setState(() => saveMedia = v)),
          const Divider(color: Colors.white10),
          sectionTitle('البيانات والتخزين', Icons.storage),
          toggle('التنزيل التلقائي للصور', '', autoImages, (v) => setState(() => autoImages = v)),
          toggle('التنزيل التلقائي للصوت', '', autoAudio, (v) => setState(() => autoAudio = v)),
          arrow('استخدام البيانات والتخزين', 'إدارة الوسائط والبيانات', Icons.data_usage, () {}),
          const Divider(color: Colors.white10),
          sectionTitle('المظهر', Icons.palette),
          toggle('الوضع الداكن', 'المظهر الداكن لـ الفهد', darkMode, (v) => setState(() => darkMode = v)),
          arrow('لون الفهد', 'ذهبي', Icons.palette_outlined, () {}),
          const Divider(color: Colors.white10),
          sectionTitle('حول التطبيق', Icons.info),
          arrow('حول الفهد', 'الإصدار 1.0.0', Icons.info_outline, () {}),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
