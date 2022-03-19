import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:geek_findr/constants.dart';
import 'package:geek_findr/controller/chat_controller.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/controller/post_controller.dart';
import 'package:geek_findr/controller/profile_controller.dart';
import 'package:geek_findr/database/chat_model.dart';
import 'package:geek_findr/database/lastmessge_model.dart';
import 'package:geek_findr/database/participant_model.dart';
import 'package:geek_findr/database/user_model.dart';
import 'package:geek_findr/theme.dart';
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
  WidgetsFlutterBinding.ensureInitialized();
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
  await Hive.openBox<List<MyChatList>>('chatmodel');
  final pref = await SharedPreferences.getInstance();
  final isLoggedIn = pref.getBool("user");
  Get.put(AppController());
  Get.put(PostsController());
  Get.put(ChatController());
  Get.put(ProfileController());
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
  void initState() {
    chatController.connectSocket();
    super.initState();
  }

  @override
  void dispose() {
    chatController.socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const screens = [
      HomePage(),
      MyProjectList(),
      ChatPage(),
      ProfilePage(),
    ];
    return GetBuilder<AppController>(
      id: "home",
      builder: (controller) {
        return Scaffold(
          body: IndexedStack(
            index: currentIndex,
            children: screens,
          ),
          bottomNavigationBar: SalomonBottomBar(
            curve: Curves.easeOut,
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
                icon: const ImageIcon(AssetImage("assets/icons/home.png")),
                title: const Text('Home'),
              ),
              SalomonBottomBarItem(
                selectedColor: primaryColor,
                icon: const ImageIcon(AssetImage("assets/icons/idea.png")),
                title: const Text('Projects'),
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
                        final count = controller.findUnreadNotificationCount();
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
