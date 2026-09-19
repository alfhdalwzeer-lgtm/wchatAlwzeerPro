import 'package:flutter/material.dart';

class StorageScreen extends StatelessWidget {
  const StorageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('التخزين والبيانات')),
        body: ListView(
          children: const [
            ListTile(
              title: Text('استخدام الشبكة'),
              subtitle: Text('تم إرسال 727.5 م.ب - تم استلام 11.3 غ.ب'),
            ),
            Divider(),
            SwitchListTile(
              value: false,
              onChanged: null,
              title: Text('التوفير في حجم البيانات المستخدم في المكالمات'),
            ),
            Divider(),
            ListTile(
              title: Text('جودة تحميل الوسائط'),
              subtitle: Text('جودة قياسية'),
            ),
            ListTile(
              title: Text('التنزيل التلقائي للوسائط'),
              subtitle: Text('أثناء الاتصال بشبكة Wi-Fi: جميع الوسائط'),
            ),
          ],
        ),
      ),
    );
  }
}
