import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/models/user_model.dart';
import 'package:geek_findr/theme.dart';
import 'package:geek_findr/views/home_page.dart';
import 'package:geek_findr/views/login_page.dart';
import 'package:geek_findr/views/profile_page.dart';
import 'package:geek_findr/views/widgets/search_widget.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>('usermodel');
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

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      id: "home",
      builder: (controller) {
        final screens = [
          HomePage(),
          SearchWidget(),
          Container(
            color: Colors.red,
          ),
          if (currentIndex == 3) const ProfilePage() else Container(),
        ];
        return Scaffold(
          body: IndexedStack(
            index: currentIndex,
            children: screens,
          ),
          bottomNavigationBar: SalomonBottomBar(
            curve: Curves.ease,
            unselectedItemColor: const Color(0xffB954FE),
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            itemPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            currentIndex: currentIndex,
            onTap: (index) {
              currentIndex = index;
              controller.update(["home"]);
              // if (index == 3) {
              //   controller.update(["prof"]);
              // }
            },
            items: [
              SalomonBottomBarItem(
                icon: const Icon(Icons.home),
                title: const Text('Home'),
                selectedColor: const Color(0xffB954FE),
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.search_outlined),
                title: const Text('Search'),
                selectedColor: const Color(0xffB954FE),
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.message_outlined),
                title: const Text('Chats'),
                selectedColor: const Color(0xffB954FE),
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.person),
                title: const Text('Profile'),
                selectedColor: const Color(0xffB954FE),
              ),
            ],
          ),
        );
      },
    );
  }
}
