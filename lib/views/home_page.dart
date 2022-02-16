import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/views/drawer_page.dart';
import 'package:geek_findr/widgets/feed_list.dart';
import 'package:geek_findr/widgets/image_upload.dart';
import 'package:geek_findr/widgets/search_widget.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _advancedDrawerController = AdvancedDrawerController();

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
          child: Stack(
            children: [
              Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: Colors.white,
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
                body: FeedList(),
              ),
              GetBuilder<AppController>(
                id: "search",
                builder: (context) => const SearchWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
