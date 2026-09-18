import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {

  const ProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          'الملف الشخصي',

          style: TextStyle(
            color: AppColors.gold,
            fontSize: 27,
          ),
        ),
      ),

      body: ListView(

        padding:
            const EdgeInsets.all(24),

        children: const [

          Center(

            child: CircleAvatar(

              radius: 65,

              backgroundColor:
                  AppColors.header,

              child: Icon(
                Icons.person,
                size: 70,
                color:
                    AppColors.gold,
              ),
            ),
          ),

          SizedBox(
            height: 25,
          ),

          ListTile(

            leading: Icon(
              Icons.person,
              color:
                  AppColors.gold,
            ),

            title: Text(
              'الاسم',
            ),

            subtitle: Text(
              'الفهد',
            ),
          ),

          Divider(),

          ListTile(

            leading: Icon(
              Icons.info_outline,
              color:
                  AppColors.gold,
            ),

            title: Text(
              'النبذة',
            ),

            subtitle: Text(
              'مرحباً بك في الفهد',
            ),
          ),
        ],
      ),
    );
  }
}
