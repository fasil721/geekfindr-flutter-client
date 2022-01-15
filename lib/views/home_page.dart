import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:geek_findr/views/drawer_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _advancedDrawerController = AdvancedDrawerController();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textFactor = MediaQuery.textScaleFactorOf(context);
    return SafeArea(
      child: Scaffold(
        body: AdvancedDrawer(
          backdropColor: Colors.black.withOpacity(.9),
          controller: _advancedDrawerController,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          childDecoration: const BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black12,
                blurRadius: 100.0,
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          drawer: const DrawerPage(),
          child: Scaffold(
            backgroundColor: const Color(0xffE7EAF0),
            appBar: AppBar(
              elevation: 0,
              toolbarHeight: 60,
              leading: IconButton(
                icon: Image.asset(
                  "assets/icons/hamburger.png",
                  height: height * .035,
                ),
                onPressed: () {
                  _advancedDrawerController.showDrawer();
                },
              ),
              backgroundColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
