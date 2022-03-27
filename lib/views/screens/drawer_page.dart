import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geek_findr/constants.dart';
import 'package:geek_findr/database/box_instance.dart';
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
              final _box = BoxChat.getInstance();
              await _box.clear();
              await box.delete("user");
              chatController.myChatList = [];
              chatController.socket.disconnect();
              await Future.delayed(const Duration(milliseconds: 500));
              // Get.offAll(() => const LoginPage());
              SystemNavigator.pop(animated: true);
              // SystemChannels.platform
              //     .invokeMethod<void>('SystemNavigator.pop', true);
              // try {
              //   SystemNavigator.pop(); // sometimes it cant exit app
              // } catch (e) {
              //   exit(0); // so i am giving crash to app ... sad :(
              // }
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
