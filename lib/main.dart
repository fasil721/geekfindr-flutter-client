import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/models/user_model.dart';
import 'package:geek_findr/theme.dart';
import 'package:geek_findr/views/home_page.dart';
import 'package:geek_findr/views/login_page.dart';
import 'package:geek_findr/views/profile_page.dart';
import 'package:geek_findr/views/project_page.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance?.resamplingEnabled = true;
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
          const ProjectPage(),
          Container(
            color: Colors.red,
          ),
          const ProfilePage(),
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
            },
            items: [
              SalomonBottomBarItem(
                selectedColor: primaryColor,
                icon: const ImageIcon(
                  AssetImage("assets/icons/home.png"),
                ),
                title: const Text('Home'),
              ),
              SalomonBottomBarItem(
                selectedColor: primaryColor,
                icon: const ImageIcon(
                  AssetImage("assets/icons/idea.png"),
                ),
                title: const Text('Projects'),
              ),
              SalomonBottomBarItem(
                selectedColor: primaryColor.withOpacity(0.8),
                icon: const ImageIcon(AssetImage("assets/icons/chat.png")),
                title: const Text('Chats'),
              ),
              SalomonBottomBarItem(
                selectedColor: primaryColor,
                icon: const ImageIcon(AssetImage("assets/icons/account.png")),
                title: const Text('Profile'),
              ),
            ],
          ),
        );
      },
    );
  }
}
