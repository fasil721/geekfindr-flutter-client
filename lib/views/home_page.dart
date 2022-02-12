import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/services/posts.dart';
import 'package:geek_findr/views/drawer_page.dart';
import 'package:geek_findr/views/widgets/image_upload.dart';
import 'package:geek_findr/views/widgets/search_widget.dart';
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
    final width = MediaQuery.of(context).size.width;
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
                body: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: width,
                      minHeight: height,
                    ),
                    child: FutureBuilder<List<ImageModel>>(
                      future: getMyFeeds(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasData) {
                          final data = snapshot.data;
                          if (data != null) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              child: ListView.separated(
                                physics: const ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: data.length,
                                itemBuilder: (context, index) => Column(
                                  children: [
                                    Image.network(
                                      data[index].mediaUrl!,
                                      fit: BoxFit.fill,
                                      width: width,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(data[index].description!),
                                          PopupMenuButton(
                                            itemBuilder: (BuildContext bc) => [
                                              const PopupMenuItem(
                                                value: "2",
                                                child: Text(""),
                                              ),
                                              const PopupMenuItem(
                                                value: "1",
                                                child: Text(""),
                                              ),
                                            ],
                                            onSelected: (value) {
                                              if (value == "1") {}
                                              if (value == "2") {}
                                            },
                                            icon: const Icon(
                                              Icons.more_horiz,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        SizedBox(
                                  height: height * 0.05,
                                ),
                              ),
                            );
                          }
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
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
