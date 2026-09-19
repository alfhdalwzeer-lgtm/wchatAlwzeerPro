import 'package:flutter/material.dart';

class StatusPrivacyScreen extends StatefulWidget {
  const StatusPrivacyScreen({Key? key}) : super(key: key);

  @override
  State<StatusPrivacyScreen> createState() => _StatusPrivacyScreenState();
}

class _StatusPrivacyScreenState extends State<StatusPrivacyScreen> {
  String _selectedOption = 'contacts';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('خصوصية الحالة'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'من يمكنه رؤية حالاتك الجديدة؟',
              style: TextStyle(color: Color(0xFFFFC107), fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            RadioListTile<String>(
              activeColor: const Color(0xFFFFC107),
              title: const Text('جهات اتصالي', style: TextStyle(color: Colors.white)),
              value: 'contacts',
              groupValue: _selectedOption,
              onChanged: (val) => setState(() => _selectedOption = val!),
            ),
            RadioListTile<String>(
              activeColor: const Color(0xFFFFC107),
              title: const Text('جهات اتصالي باستثناء...', style: TextStyle(color: Colors.white)),
              value: 'except',
              groupValue: _selectedOption,
              onChanged: (val) => setState(() => _selectedOption = val!),
            ),
            RadioListTile<String>(
              activeColor: const Color(0xFFFFC107),
              title: const Text('المشاركة فقط مع...', style: TextStyle(color: Colors.white)),
              value: 'only',
              groupValue: _selectedOption,
              onChanged: (val) => setState(() => _selectedOption = val!),
            ),
          ],
        ),
      ),
    );
  }
}
