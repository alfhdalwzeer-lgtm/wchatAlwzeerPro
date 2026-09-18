import 'package:flutter/material.dart';

// ==========================================
// 1. ألوان التطبيق (App Colors)
// ==========================================
class AppColors {
  static const Color gold = Color(0xFFFFD700);
  static const Color goldDark = Color(0xFFB8860B);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
}

// ==========================================
// 2. نقطة بداية التطبيق (Main Entry)
// ==========================================
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
   return MaterialApp(
      title: 'wchatAlwzeerPro',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.backgroundDark,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surfaceDark,
          elevation: 0,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

// ==========================================
// 3. شاشة التنقل الرئيسية (Bottom Navigation)
// ==========================================
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.gold,
        unselectedItemColor: Colors.grey,
        backgroundColor: AppColors.surfaceDark,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'المحادثات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'الملف الشخصي',
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 4. الصفحة الرئيسية (Home Screen)
// ==========================================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الرئيسية', style: TextStyle(color: AppColors.gold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.gold),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: AppColors.surfaceDark,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.goldDark),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: AppColors.gold,
                    child: Icon(Icons.person, size: 40, color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'الفهد',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: AppColors.gold),
              title: const Text('الإعدادات', style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: AppColors.gold),
              title: const Text('الملف الشخصي', style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          'مرحباً بك في تطبيق الفهد',
          style: TextStyle(fontSize: 22, color: AppColors.gold),
        ),
      ),
    );
  }
}

// ==========================================
// 5. شاشة المحادثات (Chat Screen)
// ==========================================
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المحادثات', style: TextStyle(color: AppColors.gold)),
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const AvatarCircle(),
            title: Text('محادثة ${index + 1}'),
            subtitle: const Text('آخر رسالة مرسلة...'),
            trailing: const Text('12:00 م', style: TextStyle(fontSize: 12)),
          );
        },
      ),
    );
  }
}

// ==========================================
// 6. شاشة الملف الشخصي (Profile Screen)
// ==========================================
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي', style: TextStyle(color: AppColors.gold)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            AvatarCircle(radius: 50),
            SizedBox(height: 15),
            Text(
              'اسم المستخدم',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text('user@example.com', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 7. عنصر صورة المستخدم (AvatarCircle Widget)
// ==========================================
class AvatarCircle extends StatelessWidget {
  final double radius;
  const AvatarCircle({super.key, this.radius = 24});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.gold,
      child: Icon(Icons.person, size: radius * 1.2, color: Colors.black),
    );
  }
}

// ==========================================
// 8. شاشة الإعدادات الشاملة (Settings Screen)
// ==========================================
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
          Icon(icon, color: AppColors.gold, size: 30),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.gold,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget toggle(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.gold,
      activeTrackColor: AppColors.goldDark,
      title: Text(title, style: const TextStyle(fontSize: 21)),
      subtitle: subtitle.isEmpty
          ? null
          : Text(subtitle, style: const TextStyle(fontSize: 15)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 28),
    );
  }

  Widget arrow(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 3),
      leading: Icon(icon, color: AppColors.gold, size: 30),
      title: Text(title, style: const TextStyle(fontSize: 21)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 15)),
      trailing: const Icon(Icons.chevron_right, size: 30),
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
          style: TextStyle(
            color: AppColors.gold,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          sectionTitle('الحساب', Icons.account_circle),
          arrow(
            'الملف الشخصي',
            'الاسم والصورة والنبذة',
            Icons.person,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
          const Divider(),
          sectionTitle('الإشعارات', Icons.notifications),
          toggle(
            'إشعارات الرسائل',
            'إظهار إشعار عند وصول رسالة جديدة',
            notifications,
            (v) => setState(() => notifications = v),
          ),
          toggle(
            'أصوات الإشعارات',
            '',
            sounds,
            (v) => setState(() => sounds = v),
          ),
          toggle(
            'الاهتزاز',
            '',
            vibration,
            (v) => setState(() => vibration = v),
          ),
          toggle('معاينة الرسائل', 'إظهار محتوى الرسالة في الإشعار', true, (v) {}),
          const Divider(),
          sectionTitle('الخصوصية والأمان', Icons.lock),
          toggle(
            'إيصالات القراءة',
            'إظهار علامة قراءة الرسائل',
            readReceipts,
            (v) => setState(() => readReceipts = v),
          ),
          toggle(
            'حالة الاتصال',
            'السماح للآخرين برؤية حالة اتصالك',
            online,
            (v) => setState(() => online = v),
          ),
          arrow('الأمان', 'إعدادات حماية الحساب', Icons.security, () {}),
          const Divider(),
          sectionTitle('الدردشات', Icons.chat_bubble),
          arrow('حجم الخط', 'متوسط', Icons.text_fields, () {}),
          toggle(
            'حفظ الوسائط',
            'حفظ الصور والوسائط على الجهاز',
            saveMedia,
            (v) => setState(() => saveMedia = v),
          ),
          const Divider(),
          sectionTitle('البيانات والتخزين', Icons.storage),
          toggle(
            'التنزيل التلقائي للصور',
            '',
            autoImages,
            (v) => setState(() => autoImages = v),
          ),
          toggle(
            'التنزيل التلقائي للصوت',
            '',
            autoAudio,
            (v) => setState(() => autoAudio = v),
          ),
          arrow(
            'استخدام البيانات والتخزين',
            'إدارة الوسائط والبيانات',
            Icons.data_usage,
            () {},
          ),
          const Divider(),
          sectionTitle('المظهر', Icons.palette),
          toggle(
            'الوضع الداكن',
            'المظهر الداكن لـ الفهد',
            darkMode,
            (v) => setState(() => darkMode = v),
          ),
          arrow('لون الفهد', 'ذهبي', Icons.palette_outlined, () {}),
          const Divider(),
          sectionTitle('اللغة', Icons.language),
          arrow('لغة التطبيق', 'العربية', Icons.translate, () {}),
          const Divider(),
          sectionTitle('حول التطبيق', Icons.info),
          arrow('حول الفهد', 'الإصدار 1.0.0', Icons.info_outline, () {}),
          arrow('المساعدة', 'الأسئلة والمساعدة', Icons.help_outline, () {}),
          arrow(
            'الخصوصية',
            'سياسة الخصوصية',
            Icons.privacy_tip_outlined,
            () {},
          ),
          const SizedBox(height: 18),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent, size: 30),
            title: const Text(
              'تسجيل الخروج',
              style: TextStyle(color: Colors.redAccent, fontSize: 21),
            ),
            onTap: () {},
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'الفهد',
              style: TextStyle(
                color: AppColors.gold,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }
}
