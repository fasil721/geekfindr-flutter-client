import 'package:flutter/material.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      textColor: Colors.white,
      iconColor: Colors.white,
      child: Column(
        children: [
          Container(
            width: 180.0,
            margin: const EdgeInsets.only(
              top: 24.0,
              bottom: 64.0,
            ),
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              color: Colors.black26,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              'assets/images/pair.png',
            ),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(Icons.home),
            title: Text('Home'),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(Icons.account_circle_rounded),
            title: Text('Profile'),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(Icons.favorite),
            title: Text('Favourites'),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
          Spacer(),
          DefaultTextStyle(
            style: TextStyle(
              fontSize: 12,
              color: Colors.white54,
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(
                vertical: 16.0,
              ),
              child: Text('Terms of Service | Privacy Policy'),
            ),
          ),
        ],
      ),
    );
  }
}
