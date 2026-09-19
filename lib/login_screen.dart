import 'package:flutter/material.dart';
import 'main.dart'; // للانتقال للشاشة الرئيسية بعد التسجيل

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  void _onContinue() {
    if (_phoneController.text.trim().isNotEmpty) {
      // الانتقال للدردشة الرئيسية بعد تسجيل الرقم
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ChatHomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل الدخول'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.phone_android, size: 60, color: Color(0xFFFFC107)),
            const SizedBox(height: 20),
            const Text(
              'أدخل رقم هاتفك للمتابعة',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'سنقوم بإرسال رمز التحقق لتأكيد حسابك في الفهد',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.phone, color: Color(0xFFFFC107)),
                hintText: '77XXXXXXX',
                hintStyle: TextStyle(color: Colors.grey),
                labelText: 'رقم الهاتف',
                labelStyle: TextStyle(color: Color(0xFFFFC107)),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFFC107)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFC107),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: _onContinue,
              child: const Text(
                'متابعة',
                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
