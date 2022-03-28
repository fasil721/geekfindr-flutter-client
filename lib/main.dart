import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:geek_findr/constants.dart';
import 'package:geek_findr/controller/chat_controller.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/controller/post_controller.dart';
import 'package:geek_findr/controller/profile_controller.dart';
import 'package:geek_findr/database/chat_model.dart';
import 'package:geek_findr/database/lastmessge_model.dart';
import 'package:geek_findr/database/participant_model.dart';
import 'package:geek_findr/database/user_model.dart';
import 'package:geek_findr/functions.dart';
import 'package:geek_findr/services/connectivity_service.dart';
import 'package:geek_findr/services/notification_service.dart';
import 'package:geek_findr/theme.dart';
import 'package:geek_findr/views/components/no_interner_page.dart';
import 'package:geek_findr/views/screens/chat_page.dart';
import 'package:geek_findr/views/screens/home_page.dart';
import 'package:geek_findr/views/screens/login_page.dart';
import 'package:geek_findr/views/screens/profile_page.dart';
import 'package:geek_findr/views/screens/project_page.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  NotificationService().initNotification();
  GestureBinding.instance?.resamplingEnabled = true;
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>('usermodel');
  Hive.registerAdapter(MyChatListAdapter());
  Hive.registerAdapter(ParticipantAdapter());
  Hive.registerAdapter(LastMessageAdapter());
  await Hive.openBox<MyChatList>('chatmodel');

  Get.put(AppController());
  Get.put(PostsController());
  Get.put(ChatController());
  Get.put(ProfileController());

  final pref = await SharedPreferences.getInstance();
  final isLoggedIn = pref.getBool("user");
  runApp(
    GetMaterialApp(
      home:
          isLoggedIn == null || !isLoggedIn ? const LoginPage() : const MyApp(),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // initialization();
  }

  @override
  void dispose() {
    chatController.socket.disconnect();
    super.dispose();
  }

  Future<void> initialization() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    // ignore_for_file: avoid_print
    // print('ready in 3...');
    // await Future.delayed(const Duration(seconds: 1));
    // print('ready in 2...');
    // await Future.delayed(const Duration(seconds: 1));
    // print('ready in 1...');
    // await Future.delayed(const Duration(seconds: 5));
    print('go!');
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    const screens = [
      HomePage(),
      MyProjectList(),
      ChatPage(),
      ProfilePage(),
    ];
    final textFactor =
        textfactorCustomize(MediaQuery.textScaleFactorOf(context));
    ConnectivityService().checkConnection();
    return GetBuilder<AppController>(
      id: "home",
      builder: (controller) {
        if (controller.isOffline) {
          return const NoConnectionScreen();
        }
        chatController.connectSocket();
        chatController.updateChatDB();
        return Scaffold(
          body: IndexedStack(
            index: controller.currentIndex,
            children: screens,
          ),
          bottomNavigationBar: SalomonBottomBar(
            curve: Curves.easeOut,
            unselectedItemColor: const Color(0xffB954FE),
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            itemPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            currentIndex: controller.currentIndex,
            onTap: (index) {
              controller.currentIndex = index;
              controller.update(["home"]);
            },
            items: [
              SalomonBottomBarItem(
                selectedColor: primaryColor,
                icon: const ImageIcon(AssetImage("assets/icons/home.png")),
                title: Text(
                  'Home',
                  style: GoogleFonts.roboto(fontSize: textFactor * 12),
                ),
              ),
              SalomonBottomBarItem(
                selectedColor: primaryColor,
                icon: const ImageIcon(AssetImage("assets/icons/idea.png")),
                title: Text(
                  'Projects',
                  style: GoogleFonts.roboto(fontSize: textFactor * 12),
                ),
              ),
              SalomonBottomBarItem(
                selectedColor: primaryColor.withOpacity(0.8),
                icon: Stack(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(3.0),
                      child: ImageIcon(AssetImage("assets/icons/chat.png")),
                    ),
                    GetBuilder<ChatController>(
                      id: 'navCount',
                      builder: (controller) {
                        final count =
                            controller.findUnreadNotificationCount();
                        return Visibility(
                          visible: count > 0,
                          child: Positioned(
                            right: 0,
                            child: CircleAvatar(
                              backgroundColor: primaryColor,
                              radius: 6,
                              child: Text(
                                count.toString(),
                                style: GoogleFonts.roboto(
                                  fontSize: 9,
                                  color: white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                title: Text(
                  'Chats',
                  style: GoogleFonts.roboto(fontSize: textFactor * 12),
                ),
              ),
              SalomonBottomBarItem(
                selectedColor: primaryColor,
                icon: const ImageIcon(AssetImage("assets/icons/account.png")),
                title: Text(
                  'Profile',
                  style: GoogleFonts.roboto(fontSize: textFactor * 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
