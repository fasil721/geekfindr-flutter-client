import 'package:flutter/material.dart';
import 'package:geek_findr/constants.dart';
import 'package:geek_findr/views/screens/login_page.dart';
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
              final pref = await SharedPreferences.getInstance();
              pref.setBool("user", false);
              await Future.delayed(const Duration(milliseconds: 500));
              await Get.offAll(() => const LoginPage());
              await Future.delayed(const Duration(milliseconds: 2000));
              chatController.socket.disconnect();
              await box.delete("user");
              chatController.dispose();
              profileController.dispose();
              postController.dispose();
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
