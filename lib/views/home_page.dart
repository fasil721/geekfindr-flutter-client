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
    return AdvancedDrawer(
      backdropColor: Colors.blueGrey,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        // NOTICE: Uncomment if you want to add shadow behind the page.
        // Keep in mind that it may cause animation jerks.
        // boxShadow: <BoxShadow>[
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 0.0,
        //   ),
        // ],
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      drawer: DrawerPage(),
      child: Scaffold(
        backgroundColor: const Color(0xffE7EAF0),
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 70,
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
    );
  }
}
