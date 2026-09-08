import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'auto_channel_id',
      'الإشعارات التلقائية',
      channelDescription: 'قناة الإشعارات الدورية للتطبيق',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

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

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
      
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

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
          title: const Text('الصادق - العمليات التلقائية'),
          backgroundColor: Colors.indigo,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.autorenew, size: 80, color: Colors.indigo),
              const SizedBox(height: 20),
              const Text(
                'مرحباً بك في التطبيق!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.alarm_on),
                label: const Text('تفعيل الإشعارات والعمليات التلقائية', style: TextStyle(fontSize: 16)),
                onPressed: () {
                  Workmanager().registerPeriodicTask(
                    "auto_task_id",
                    "periodicBackgroundTask",
                    frequency: const Duration(minutes: 15),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم تفعيل المهمة التلقائية بنجاح! ستصلك إشعارات بالخلفية.'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
