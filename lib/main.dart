import 'package:flutter/material.dart';

void main() {
  runApp(const AlWazirApp());
}

class AlWazirApp extends StatelessWidget {
  const AlWazirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Al-Wazir',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF050814),
        useMaterial3: true,
        fontFamily: 'Arial',
      ),
      home: const AlWazirHome(),
    );
  }
}

class AlWazirHome extends StatelessWidget {
  const AlWazirHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF071326),
              Color(0xFF050814),
              Color(0xFF02040A),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // الشريط العلوي
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.menu,
                        color: Color(0xFFFFC44D),
                        size: 30,
                      ),
                    ),
                    Column(
                      children: [
                        const Text(
                          'الوزير',
                          style: TextStyle(
                            color: Color(0xFFFFC44D),
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Al-Wazir',
                          style: TextStyle(
                            color: Colors.white.withOpacity(.65),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.nightlight_round,
                        color: Color(0xFFFFC44D),
                        size: 25,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // التاج
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFFFC44D),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFB300).withOpacity(.30),
                      blurRadius: 35,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '👑',
                    style: TextStyle(fontSize: 78),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              const Text(
                'أهلًا بك في الوزير',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'مساعدك الذكي... حيث تبدأ الأفكار بلا حدود',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withOpacity(.65),
                ),
              ),

              const SizedBox(height: 30),

              // بطاقة الترحيب
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 22),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: const Color(0xFFFFC44D).withOpacity(.55),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF111A2E).withOpacity(.95),
                      const Color(0xFF080D1C).withOpacity(.95),
                    ],
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '👑',
                      style: TextStyle(fontSize: 35),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'السلام عليكم 👑\n'
                        'أنا الوزير، مساعدك الذكي.\n'
                        'كيف يمكنني مساعدتك اليوم؟',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.7,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // الأزرار الرئيسية
              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.55,
                  children: [
                    _ActionButton(
                      icon: Icons.chat_bubble_outline,
                      title: 'اسأل الوزير',
                      onTap: () {},
                    ),
                    _ActionButton(
                      icon: Icons.lightbulb_outline,
                      title: 'أفكار وملاحظات',
                      onTap: () {},
                    ),
                    _ActionButton(
                      icon: Icons.mic_none,
                      title: 'المحادثة الصوتية',
                      onTap: () {},
                    ),
                    _ActionButton(
                      icon: Icons.folder_outlined,
                      title: 'الملفات',
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              // مربع الكتابة
              Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: const Color(0xFFFFC44D).withOpacity(.65),
                  ),
                  color: const Color(0xFF0B1222),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.add,
                        color: Color(0xFFFFC44D),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'اكتب رسالتك هنا...',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.white.withOpacity(.45),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      width: 46,
                      height: 46,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFFB52E),
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Color(0xFF111111),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // شريط التنقل
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF070B16),
          border: Border(
            top: BorderSide(
              color: Color(0xFF252B3B),
            ),
          ),
        ),
        child: const SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_outlined,
                  title: 'الرئيسية',
                  selected: true,
                ),
                _NavItem(
                  icon: Icons.chat_outlined,
                  title: 'المحادثات',
                ),
                _NavItem(
                  icon: Icons.bookmark_border,
                  title: 'المحفوظات',
                ),
                _NavItem(
                  icon: Icons.settings_outlined,
                  title: 'الإعدادات',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: const Color(0xFF0C1324),
          border: Border.all(
            color: const Color(0xFF29334A),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 29,
              color: const Color(0xFFFFC44D),
            ),
            const SizedBox(height: 9),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;

  const _NavItem({
    required this.icon,
    required this.title,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: selected
              ? const Color(0xFFFFC44D)
              : Colors.white70,
          size: 25,
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: selected
                ? const Color(0xFFFFC44D)
                : Colors.white60,
          ),
        ),
      ],
    );
  }
}
