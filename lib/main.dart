import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

import 'profile_screen.dart';

class SettingsScreen
    extends StatefulWidget {

  const SettingsScreen({
    super.key,
  });

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {

  bool notifications = true;
  bool sounds = true;
  bool vibration = true;

  bool readReceipts = true;
  bool online = true;

  bool saveMedia = true;

  bool autoImages = true;
  bool autoAudio = true;

  bool darkMode = true;

  Widget sectionTitle(
    String title,
    IconData icon,
  ) {

    return Padding(

      padding:
          const EdgeInsets.fromLTRB(
        24,
        20,
        24,
        8,
      ),

      child: Row(

        children: [

          Icon(
            icon,
            color:
                AppColors.gold,
            size: 30,
          ),

          const SizedBox(
            width: 10,
          ),

          Text(
            title,

            style:
                const TextStyle(

              color:
                  AppColors.gold,

              fontSize: 25,

              fontWeight:
                  FontWeight.bold,
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

      activeThumbColor:
          AppColors.gold,

      activeTrackColor:
          AppColors.goldDark,

      title: Text(
        title,

        style:
            const TextStyle(
          fontSize: 21,
        ),
      ),

      subtitle:
          subtitle.isEmpty
              ? null
              : Text(
                  subtitle,

                  style:
                      const TextStyle(
                    fontSize: 15,
                  ),
                ),

      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 28,
      ),
    );
  }

  Widget arrow(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {

    return ListTile(

      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 3,
      ),

      leading: Icon(
        icon,
        color:
            AppColors.gold,
        size: 30,
      ),

      title: Text(
        title,

        style:
            const TextStyle(
          fontSize: 21,
        ),
      ),

      subtitle: Text(
        subtitle,

        style:
            const TextStyle(
          fontSize: 15,
        ),
      ),

      trailing:
          const Icon(
        Icons.chevron_right,
        size: 30,
      ),

      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        leading:
            IconButton(

          icon:
              const Icon(
            Icons.arrow_back,
          ),

          onPressed: () =>
              Navigator.pop(context),
        ),

        title:
            const Text(
          'الإعدادات',

          style:
              TextStyle(

            color:
                AppColors.gold,

            fontSize: 30,

            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      body:
          ListView(

        children: [

          sectionTitle(
            'الحساب',
            Icons.account_circle,
          ),

          arrow(
            'الملف الشخصي',
            'الاسم والصورة والنبذة',
            Icons.person,
            () {

              Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (_) =>
                      const ProfileScreen(),
                ),
              );
            },
          ),

          const Divider(),

          sectionTitle(
            'الإشعارات',
            Icons.notifications,
          ),

          toggle(
            'إشعارات الرسائل',
            'إظهار إشعار عند وصول رسالة جديدة',
            notifications,
            (v) =>
                setState(
              () => notifications = v,
            ),
          ),

          toggle(
            'أصوات الإشعارات',
            '',
            sounds,
            (v) =>
                setState(
              () => sounds = v,
            ),
          ),

          toggle(
            'الاهتزاز',
            '',
            vibration,
            (v) =>
                setState(
              () => vibration = v,
            ),
          ),

          toggle(
            'معاينة الرسائل',
            'إظهار محتوى الرسالة في الإشعار',
            true,
            (v) {},
          ),

          const Divider(),

          sectionTitle(
            'الخصوصية والأمان',
            Icons.lock,
          ),

          toggle(
            'إيصالات القراءة',
            'إظهار علامة قراءة الرسائل',
            readReceipts,
            (v) =>
                setState(
              () => readReceipts = v,
            ),
          ),

          toggle(
            'حالة الاتصال',
            'السماح للآخرين برؤية حالة اتصالك',
            online,
            (v) =>
                setState(
              () => online = v,
            ),
          ),

          arrow(
            'الأمان',
            'إعدادات حماية الحساب',
            Icons.security,
            () {},
          ),

          const Divider(),

          sectionTitle(
            'الدردشات',
            Icons.chat_bubble,
          ),

          arrow(
            'حجم الخط',
            'متوسط',
            Icons.text_fields,
            () {},
          ),

          toggle(
            'حفظ الوسائط',
            'حفظ الصور والوسائط على الجهاز',
            saveMedia,
            (v) =>
                setState(
              () => saveMedia = v,
            ),
          ),

          const Divider(),

          sectionTitle(
            'البيانات والتخزين',
            Icons.storage,
          ),

          toggle(
            'التنزيل التلقائي للصور',
            '',
            autoImages,
            (v) =>
                setState(
              () => autoImages = v,
            ),
          ),

          toggle(
            'التنزيل التلقائي للصوت',
            '',
            autoAudio,
            (v) =>
                setState(
              () => autoAudio = v,
            ),
          ),

          arrow(
            'استخدام البيانات والتخزين',
            'إدارة الوسائط والبيانات',
            Icons.data_usage,
            () {},
          ),

          const Divider(),

          sectionTitle(
            'المظهر',
            Icons.palette,
          ),

          toggle(
            'الوضع الداكن',
            'المظهر الداكن لـ الفهد',
            darkMode,
            (v) =>
                setState(
              () => darkMode = v,
            ),
          ),

          arrow(
            'لون الفهد',
            'ذهبي',
            Icons.palette_outlined,
            () {},
          ),

          const Divider(),

          sectionTitle(
            'اللغة',
            Icons.language,
          ),

          arrow(
            'لغة التطبيق',
            'العربية',
            Icons.translate,
            () {},
          ),

          const Divider(),

          sectionTitle(
            'حول التطبيق',
            Icons.info,
          ),

          arrow(
            'حول الفهد',
            'الإصدار 1.0.0',
            Icons.info_outline,
            () {},
          ),

          arrow(
            'المساعدة',
            'الأسئلة والمساعدة',
            Icons.help_outline,
            () {},
          ),

          arrow(
            'الخصوصية',
            'سياسة الخصوصية',
            Icons.privacy_tip_outlined,
            () {},
          ),

          const SizedBox(
            height: 18,
          ),

          ListTile(

            leading:
                const Icon(
              Icons.logout,
              color:
                  Colors.redAccent,
              size: 30,
            ),

            title:
                const Text(
              'تسجيل الخروج',

              style:
                  TextStyle(
                color:
                    Colors.redAccent,
                fontSize: 21,
              ),
            ),

            onTap: () {},
          ),

          const SizedBox(
            height: 20,
          ),

          const Center(

            child: Text(
              'الفهد',

              style:
                  TextStyle(

                color:
                    AppColors.gold,

                fontSize: 24,

                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(
            height: 28,
          ),
        ],
      ),
    );
  }
}
