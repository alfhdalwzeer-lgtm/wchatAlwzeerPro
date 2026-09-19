import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationMessages = true;
  bool notificationSounds = true;
  bool notificationVibrate = true;
  bool notificationPreview = true;
  bool readReceipts = true;
  bool onlineStatus = true;
  bool saveMedia = true;
  bool autoDownloadImages = true;
  bool autoDownloadAudio = true;
  bool darkMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _buildSectionHeader('الحساب', Icons.person),
          _buildListTile('الملف الشخصي', 'الاسم والصورة والنبذة', Icons.account_circle_outlined, () {}),
          const Divider(),

          _buildSectionHeader('الإشعارات', Icons.notifications_active),
          _buildSwitchTile('إشعارات الرسائل', 'إظهار إشعار عند وصول رسالة جديدة', notificationMessages, (v) => setState(() => notificationMessages = v)),
          _buildSwitchTile('أصوات الإشعارات', '', notificationSounds, (v) => setState(() => notificationSounds = v)),
          _buildSwitchTile('الاهتزاز', '', notificationVibrate, (v) => setState(() => notificationVibrate = v)),
          _buildSwitchTile('معاينة الرسائل', 'إظهار محتوى الرسالة في الإشعار', notificationPreview, (v) => setState(() => notificationPreview = v)),
          const Divider(),

          _buildSectionHeader('الخصوصية والأمان', Icons.lock),
          _buildSwitchTile('إيصالات القراءة', 'إظهار علامة قراءة الرسائل', readReceipts, (v) => setState(() => readReceipts = v)),
          _buildSwitchTile('حالة الاتصال', 'السماح للآخرين برؤية حالة اتصالم', onlineStatus, (v) => setState(() => onlineStatus = v)),
          _buildListTile('الأمان', 'إعدادات حماية الحساب', Icons.security, () {}),
          const Divider(),

          _buildSectionHeader('الدردشات', Icons.chat),
          _buildListTile('حجم الخط', 'متوسط', Icons.text_fields, () {}),
          _buildSwitchTile('حفظ الوسائط', 'حفظ الصور والوسائط على الجهاز', saveMedia, (v) => setState(() => saveMedia = v)),
          const Divider(),

          _buildSectionHeader('البيانات والتخزين', Icons.bar_chart),
          _buildSwitchTile('التنزيل التلقائي للصور', '', autoDownloadImages, (v) => setState(() => autoDownloadImages = v)),
          _buildSwitchTile('التنزيل التلقائي للصوت', '', autoDownloadAudio, (v) => setState(() => autoDownloadAudio = v)),
          _buildListTile('استخدام البيانات والتخزين', 'إدارة الوسائط والبيانات', Icons.donut_large, () {}),
          const Divider(),

          _buildSectionHeader('المظهر', Icons.palette),
          _buildSwitchTile('الوضع الداكن', 'المظهر الداكن لـ الفهد', darkMode, (v) => setState(() => darkMode = v)),
          _buildListTile('لون الفهد', 'ذهبي', Icons.color_lens, () {}),
          const Divider(),

          _buildSectionHeader('اللغة', Icons.language),
          _buildListTile('لغة التطبيق', 'العربية', Icons.translate, () {}),
          const Divider(),

          _buildSectionHeader('حول التطبيق', Icons.info_outline),
          _buildListTile('حول الفهد', 'الإصدار 1.0.0', Icons.info, () {}),
          _buildListTile('المساعدة', 'الأسئلة والمساعدة', Icons.help_outline, () {}),
          _buildListTile('الخصوصية', 'سياسة الخصوصية', Icons.privacy_tip_outlined, () {}),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('تسجيل الخروج', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () {},
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text('الفهد', style: TextStyle(color: Color(0xFFFFC107), fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFFC107)),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(color: Color(0xFFFFC107), fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildListTile(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: subtitle.isNotEmpty ? Text(subtitle, style: const TextStyle(color: Colors.grey)) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      activeColor: const Color(0xFFFFC107),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: subtitle.isNotEmpty ? Text(subtitle, style: const TextStyle(color: Colors.grey)) : null,
      value: value,
      onChanged: onChanged,
    );
  }
}
