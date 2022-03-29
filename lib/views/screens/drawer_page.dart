import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geek_findr/constants.dart';
import 'package:geek_findr/database/box_instance.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:share_plus/share_plus.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      textColor: Colors.white,
      iconColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 50),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                      // onTap: () => Share.share(
                      //   'check out my application :- https://play.google.com/store/apps/details?id=com.fasil.Mussy',
                      // ),
                      leading: const Icon(Icons.share),
                      title: Text(
                        'Share',
                        style: GoogleFonts.rubik(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.lock),
                      title: Text(
                        'Privacy and policy',
                        style: GoogleFonts.rubik(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.receipt,
                      ),
                      title: Text(
                        "Terms and Condition",
                        style: GoogleFonts.rubik(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () async {
                        final _box = BoxChat.getInstance();
                        await _box.clear();
                        await box.delete("user");
                        chatController.myChatList = [];
                        chatController.socket.disconnect();
                        await Future.delayed(const Duration(milliseconds: 500));
                        SystemNavigator.pop(animated: true);
                      },
                      leading: const Icon(Icons.logout_outlined),
                      title: Text(
                        'Logout ',
                        style: GoogleFonts.rubik(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.info,
                        color: Colors.white,
                      ),
                      title: Text(
                        "About",
                        style: GoogleFonts.rubik(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'Geek Findr',
                          applicationIcon: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: const Image(
                              height: 30,
                              image: AssetImage("assets/images/logo.png"),
                            ),
                          ),
                          applicationVersion: '1.0.0',
                          children: [
                            const Text('Developer Community'),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Version 1.0.0',
              style: GoogleFonts.rubik(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
