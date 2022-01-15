import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/theme.dart';
import 'package:geek_findr/views/home_page.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PageController? _pageController;
  int currentIndex = 0;

  final screens = [
    HomePage(),
    Container(
      color: Colors.red,
    ),
    Container(
      color: Colors.green,
    ),
    Container(
      color: Colors.blue,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(AppController());
    final mobileTheme = SchedulerBinding.instance!.window.platformBrightness;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: mobileTheme == Brightness.light ? AppTheme.light : AppTheme.light,
      home: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: screens,
        ),
        // body: SizedBox.expand(
        //   child: PageView(
        //     controller: _pageController,
        //     onPageChanged: (index) {
        //       setState(() => currentIndex = index);
        //     },
        //     children: screens,
        //   ),
        // ),
        bottomNavigationBar: BottomNavyBar(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          selectedIndex: currentIndex,
          onItemSelected: (index) => setState(() {
            currentIndex = index;
            // _pageController!.animateToPage(
            //   index,
            //   duration: const Duration(milliseconds: 300),
            //   curve: Curves.bounceIn,
            // );
          }),
          items: [
            BottomNavyBarItem(
              textAlign: TextAlign.center,
              icon: const Icon(Icons.apps),
              title: const Text('Home'),
              activeColor: Colors.red,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.people),
              title: const Text('Users'),
              activeColor: Colors.purpleAccent,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.message),
              title: const Text('Messages'),
              activeColor: Colors.pink,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.settings),
              title: const Text('Settings'),
              activeColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
