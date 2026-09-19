import 'package:flutter/material.dart';
import 'storage_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الإعدادات')),
        body: ListView(
          children: [
            const ListTile(
              leading: CircleAvatar(radius: 28, child: Icon(Icons.person, size: 30)),
              title: Text('المركز الحديث للالكترونيات'),
              subtitle: Text('مرحباً! أنا أستخدم واتساب.'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.key_outlined),
              title: const Text('الحساب'),
              subtitle: const Text('إشعارات الأمان، تغيير الرقم'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('الخصوصية'),
              subtitle: const Text('الحسابات المحظورة، الرسائل ذاتية الاختفاء'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.chat_outlined),
              title: const Text('الدردشات'),
              subtitle: const Text('السمة، خلفيات الشاشة، سجلات الدردشة'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.data_usage_outlined),
              title: const Text('التخزين والبيانات'),
              subtitle: const Text('استعمال الشبكة، التنزيل التلقائي'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const StorageScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.language_outlined),
              title: const Text('لغة التطبيق'),
              subtitle: const Text('العربية (لغة الجهاز)'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
