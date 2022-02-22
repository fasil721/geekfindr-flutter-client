import 'package:flutter/material.dart';
import 'package:geek_findr/models/box_instance.dart';
import 'package:geek_findr/views/login_page.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      textColor: Colors.white,
      iconColor: Colors.white,
      child: Column(
        children: [
          const Spacer(),
          ListTile(
            onTap: () async {
              Get.offAll(() => const LoginPage());
              final pref = await SharedPreferences.getInstance();
              pref.setBool("user", false);
              final box = Boxes.getInstance();
              box.delete("user");
            },
            leading: const Icon(Icons.settings),
            title: const Text('Logout '),
          ),
          const Spacer(),
          DefaultTextStyle(
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white54,
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(
                vertical: 16.0,
              ),
              child: const Text('Terms of Service | Privacy Policy'),
            ),
          ),
        ],
      ),
    );
  }
}
