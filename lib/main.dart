import 'package0:flutter/material.dart';
import 'settings_screen.dart'; // استدعاء شاشة الإعدادات

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الرئيسية'),
      ),
      // القائمة الجانبية
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // رأس القائمة الجانبية
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'قائمة التطبيق',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            // خيار الانتقال لصفحة الإعدادات
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('الإعدادات'),
              onTap: () {
                // إغلاق القائمة الجانبية أولاً
                Navigator.pop(context);
                
                // الانتقال إلى شاشة الإعدادات
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('مرحباً بك في الصفحة الرئيسية'),
      ),
    );
  }
}
