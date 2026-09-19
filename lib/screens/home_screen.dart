import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('واتساب', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          actions: [
            IconButton(icon: const Icon(Icons.camera_alt_outlined), onPressed: () {}),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              color: const Color(0xFF1E2834),
              onSelected: (value) {
                if (value == 'settings') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'ad', child: Text('الإعلان')),
                const PopupMenuItem(value: 'new_group', child: Text('مجموعة جديدة')),
                const PopupMenuItem(value: 'broadcast', child: Text('الرسائل الجماعية التجارية')),
                const PopupMenuItem(value: 'communities', child: Text('المجتمعات')),
                const PopupMenuItem(value: 'lists', child: Text('القوائم')),
                const PopupMenuItem(value: 'linked_devices', child: Text('الأجهزة المرتبطة')),
                const PopupMenuItem(value: 'starred', child: Text('مميزة بنجمة')),
                const PopupMenuItem(value: 'settings', child: Text('الإعدادات')),
              ],
            ),
          ],
        ),
        body: ListView(
          children: [
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: const Text('اسامه حسين الوزير'),
              subtitle: const Text('تم تحديث مؤقت الرسائل...'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatScreen(userName: 'اسامه حسين الوزير'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
