import 'package:flutter/material.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: Stack(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFFE5C158),
                radius: 26,
                child: Icon(Icons.person, color: Colors.black, size: 30),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFE5C158),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.black, size: 18),
                ),
              ),
            ],
          ),
          title: const Text(
            'حالتي',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: const Text(
            'اضغط لإضافة حالة جديدة',
            style: TextStyle(color: Colors.grey),
          ),
          onTap: () {},
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'التحديثات الحديثة',
            style: TextStyle(color: Color(0xFFE5C158), fontWeight: FontWeight.bold),
          ),
        ),
        const Center(
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: Text(
              'لا توجد حالات بعد',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
