import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

import 'chat_screen.dart';
import 'status_screen.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {

  int index = 0;

  final pages = const [
    _ChatsPage(),
    _GroupsPage(),
    _CallsPage(),
    StatusScreen(),
  ];

  void openSettings() {

    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (_) =>
            const SettingsScreen(),
      ),
    );
  }

  void openProfile() {

    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (_) =>
            const ProfileScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          'الفهد',

          style: TextStyle(
            color: AppColors.gold,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [

          IconButton(
            icon: const Icon(
              Icons.search,
              color: AppColors.gold,
              size: 31,
            ),
            onPressed: () {},
          ),

          IconButton(
            icon: const Icon(
              Icons.camera_alt_outlined,
              color: AppColors.gold,
              size: 30,
            ),
            onPressed: () {},
          ),

          PopupMenuButton<String>(

            icon: const Icon(
              Icons.more_vert,
              color: AppColors.gold,
              size: 31,
            ),

            onSelected: (value) {

              if (value == 'settings') {
                openSettings();
              }

              if (value == 'profile') {
                openProfile();
              }
            },

            itemBuilder: (_) => const [

              PopupMenuItem(
                value: 'profile',
                child: Text(
                  'الملف الشخصي',
                ),
              ),

              PopupMenuItem(
                child: Text(
                  'جهات الاتصال',
                ),
              ),

              PopupMenuItem(
                child: Text(
                  'المكالمات',
                ),
              ),

              PopupMenuItem(
                value: 'settings',
                child: Text(
                  'الإعدادات',
                ),
              ),
            ],
          ),
        ],
      ),

      body: pages[index],

      floatingActionButton:
          FloatingActionButton(

        backgroundColor:
            AppColors.gold,

        foregroundColor:
            Colors.black,

        onPressed: () {},

        child: Icon(
          index == 3
              ? Icons.chat_bubble_outline
              : Icons.chat,
        ),
      ),

      bottomNavigationBar:
          NavigationBar(

        selectedIndex: index,

        onDestinationSelected:
            (i) {

          setState(() {
            index = i;
          });
        },

        backgroundColor:
            AppColors.header,

        indicatorColor:
            const Color(0xFF4E513B),

        destinations: const [

          NavigationDestination(
            icon:
                Icon(Icons.chat_bubble_outline),

            selectedIcon:
                Icon(Icons.chat_bubble),

            label: 'الدردشات',
          ),

          NavigationDestination(
            icon:
                Icon(Icons.groups_outlined),

            selectedIcon:
                Icon(Icons.groups),

            label: 'المجموعات',
          ),

          NavigationDestination(
            icon:
                Icon(Icons.phone_outlined),

            selectedIcon:
                Icon(Icons.phone),

            label: 'المكالمات',
          ),

          NavigationDestination(
            icon:
                Icon(Icons.circle_outlined),

            selectedIcon:
                Icon(Icons.circle),

            label: 'الحالة',
          ),
        ],
      ),
    );
  }
}

class _ChatsPage extends StatelessWidget {

  const _ChatsPage();

  @override
  Widget build(BuildContext context) {

    return ListView(

      children: [

        ListTile(

          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 7,
          ),

          leading:
              const CircleAvatar(
            radius: 30,
            backgroundColor:
                AppColors.header,
            child: Icon(
              Icons.person,
              color: AppColors.gold,
              size: 32,
            ),
          ),

          title: const Text(
            'مستخدم الفهد',

            style: TextStyle(
              fontSize: 20,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          subtitle: const Text(
            'وعليكم السلام! تطبيق ممتاز جداً.',

            style: TextStyle(
              fontSize: 16,
            ),
          ),

          trailing: const Text(
            '10:01 ص',

            style: TextStyle(
              color: Colors.white60,
            ),
          ),

          onTap: () {

            Navigator.push(
              context,

              MaterialPageRoute(
                builder: (_) =>
                    const ChatScreen(),
              ),
            );
          },
        ),

        ListTile(

          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 7,
          ),

          leading:
              const CircleAvatar(
            radius: 30,
            backgroundColor:
                AppColors.header,

            child: Icon(
              Icons.workspace_premium,
              color: AppColors.gold,
              size: 32,
            ),
          ),

          title: const Text(
            'الفهد',

            style: TextStyle(
              fontSize: 20,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          subtitle: const Text(
            'مرحباً بك في التطبيق',

            style: TextStyle(
              fontSize: 16,
            ),
          ),

          trailing: const Text(
            '09:45 ص',

            style: TextStyle(
              color: Colors.white60,
            ),
          ),
        ),
      ],
    );
  }
}

class _GroupsPage extends StatelessWidget {

  const _GroupsPage();

  @override
  Widget build(BuildContext context) {

    return const Center(
      child: Text(
        'المجموعات',

        style: TextStyle(
          fontSize: 28,
        ),
      ),
    );
  }
}

class _CallsPage extends StatelessWidget {

  const _CallsPage();

  @override
  Widget build(BuildContext context) {

    return const Center(
      child: Text(
        'المكالمات',

        style: TextStyle(
          fontSize: 28,
        ),
      ),
    );
  }
}
