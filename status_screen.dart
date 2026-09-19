import 'package:flutter/material.dart';
import 'status_privacy_screen.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final List<String> myStatuses = [];

  void _addNewStatus() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF17212B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.camera_alt, color: Color(0xFFFFC107), size: 36),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() => myStatuses.add('حالة صورة'));
                  },
                ),
                const Text('صورة', style: TextStyle(color: Colors.white)),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Color(0xFFFFC107), size: 36),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() => myStatuses.add('حالة نصية'));
                  },
                ),
                const Text('نص', style: TextStyle(color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الحالة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.security, color: Color(0xFFFFC107)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StatusPrivacyScreen()),
              );
            },
          ),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Stack(
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundColor: Color(0xFFFFC107),
                  child: Icon(Icons.person, color: Colors.black, size: 30),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFC107),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, size: 18, color: Colors.black),
                  ),
                ),
              ],
            ),
            title: const Text('حالتي', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text(
              myStatuses.isEmpty ? 'اضغط لإضافة حالة جديدة' : 'عدد الحالات: ${myStatuses.length}',
              style: const TextStyle(color: Colors.grey),
            ),
            onTap: _addNewStatus,
          ),
          const Divider(color: Colors.white12),
          if (myStatuses.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 80),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.auto_awesome, color: Color(0xFFFFC107), size: 50),
                    SizedBox(height: 12),
                    Text('لا توجد حالات بعد', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                ),
              ),
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFC107),
        onPressed: _addNewStatus,
        child: const Icon(Icons.camera_alt, color: Colors.black),
      ),
    );
  }
}
