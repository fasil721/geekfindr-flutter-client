import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:geek_findr/services/posts.dart';
import 'package:geek_findr/views/drawer_page.dart';
import 'package:geek_findr/views/widgets/post_upload.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _advancedDrawerController = AdvancedDrawerController();
  final imagePicker = ImagePicker();
  String? imagePath;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.dialog(
               PostUploadDialoge(),
            );
          },
        ),
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
              // title: Text(user.username!),
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
