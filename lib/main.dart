import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// 1. تهيئة مشغل الإشعارات المحلية
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// 2. المحرك الذي يعمل في الخلفية تلقائياً
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    // إعدادات الإشعار الذي سيظهر للمستخدم تلقائياً عند تنفيذ المهمة
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'auto_channel_id',
      'الإشعارات التلقائية',
      channelDescription: 'قناة الإشعارات الدورية للتطبيق',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    // عرض الإشعار عند عمل المهمة التلقائية
    await flutterLocalNotificationsPlugin.show(
      0,
      'تحديث تلقائي',
      'تم تنفيذ المهمة البرمجية بالخلفية بنجاح!',
      notificationDetails,
    );

    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة الإشعارات لنظام Android
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
      
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // تهيئة محرك المهام التلقائية
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('تطبيق المهام الإشعارات التلقائية'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Center(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.alarm_on),
            label: const Text('تفعيل الإشعارات والعمليات التلقائية'),
            onPressed: () {
              // جدولة مهمة دورية تعمل كل 15 دقيقة تلقائياً بالخلفية
              Workmanager().registerPeriodicTask(
                "auto_task_id",
                "periodicBackgroundTask",
                frequency: const Duration(minutes: 15),
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تفعيل المهمة التلقائية بنجاح!'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
