import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/theme.dart';
import 'package:geek_findr/views/home_page.dart';
import 'package:geek_findr/views/login_page.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = await SharedPreferences.getInstance();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final isLoggedIn = pref.getBool("user");
  Get.put(AppController());
  final mobileTheme = SchedulerBinding.instance!.window.platformBrightness;

  runApp(
    GetMaterialApp(
      home:
          isLoggedIn == null || !isLoggedIn ? const LoginPage() : const MyApp(),
      debugShowCheckedModeBanner: false,
      theme: mobileTheme == Brightness.light ? AppTheme.light : AppTheme.light,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentIndex = 0;

  final screens = [
    HomePage(),
    Container(
      color: Colors.green,
    ),
    Container(
      color: Colors.green,
    ),
    Container(
      color: Colors.blue,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      id: "home",
      builder: (controller) {
        return Scaffold(
          body: IndexedStack(
            index: currentIndex,
            children: screens,
          ),
          bottomNavigationBar: SalomonBottomBar(
            curve: Curves.ease,
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
            currentIndex: currentIndex,
            onTap: (index) {
              currentIndex = index;
              controller.update(["home"]);
            },
            items: [
              SalomonBottomBarItem(
                icon: const Icon(Icons.apps),
                title: const Text('Home'),
                selectedColor: Colors.red,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.people),
                title: const Text('Users'),
                selectedColor: Colors.purpleAccent,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.message),
                title: const Text('Messages'),
                selectedColor: Colors.pink,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.settings),
                title: const Text('Settings'),
                selectedColor: Colors.green,
              ),
            ],
          ),
        );
      },
    );
  }
}
