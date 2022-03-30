import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:geek_findr/controller/post_controller.dart';
import 'package:geek_findr/resources/colors.dart';
import 'package:geek_findr/resources/constants.dart';
import 'package:geek_findr/views/components/feed_list_view.dart';
import 'package:geek_findr/views/components/post_upload_dialoge.dart';
import 'package:geek_findr/views/components/search_widget.dart';
import 'package:geek_findr/views/screens/drawer_page.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _advancedDrawerController = AdvancedDrawerController();
  double height = 0;
  double width = 0.0;
  final scrollcontroller = ScrollController();
  bool isReversing = false;

  @override
  void initState() {
    super.initState();
    scrollcontroller.addListener(listenScrolling);
  }

  void listenScrolling() {
    final position = scrollcontroller.position;
     // print(position.pixels);
    if (position.userScrollDirection == ScrollDirection.forward &&
        position.pixels > 100) {
      isReversing = true;
      postController.update(["backToTop"]);
    } else {
      isReversing = false;
      postController.update(["backToTop"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
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
            resizeToAvoidBottomInset: true,
            backgroundColor: white,
            body: NestedScrollView(
              controller: scrollcontroller,
              physics: const BouncingScrollPhysics(),
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  expandedHeight: 70,
                  elevation: 0,
                  backgroundColor: white,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: secondaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const ImageIcon(
                                AssetImage(
                                  "assets/icons/hamburger.png",
                                ),
                                size: 18,
                                color: primaryColor,
                              ),
                              onPressed: () {
                                _advancedDrawerController.showDrawer();
                              },
                            ),
                          ),
                          const SearchWidget()
                        ],
                      ),
                    ),
                  ),
                ),
                SliverAppBar(
                  toolbarHeight: 60,
                  backgroundColor: white,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: false,
                    background: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 5),
                      child: ListTile(
                        title: Text(
                          "Add your new post",
                          style: GoogleFonts.rubik(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: IconButton(
                          splashRadius: 25,
                          onPressed: () {
                            Get.bottomSheet(_buildPhotoOptionSheet());
                          },
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              body: Stack(
                children: [
                  const FeedList(),
                  GetBuilder<PostsController>(
                    id: "backToTop",
                    builder: (controller) => Visibility(
                      visible: isReversing,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: InkWell(
                            onTap: () {
                              scrollcontroller.animateTo(
                                0,
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.easeOut,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: white,
                              ),
                              child: const Icon(
                                Icons.arrow_upward_rounded,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoOptionSheet() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () async {
            final image = await pickImage(
              source: ImageSource.camera,
            );
            Get.back();
            if (image != null) {
              Get.dialog(
                PostUploadDialoge(image: image),
              );
            }
          },
          child: Ink(
            height: height * 0.07,
            color: white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.camera_alt,
                  size: 25,
                  color: primaryColor,
                ),
                SizedBox(width: width * 0.05),
                Text(
                  "Open Camara",
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            final image = await pickImage(
              source: ImageSource.gallery,
            );
            Get.back();
            if (image != null) {
              Get.dialog(
                PostUploadDialoge(image: image),
              );
            }
          },
          child: Ink(
            height: height * 0.07,
            color: white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.image,
                  size: 25,
                  color: primaryColor,
                ),
                SizedBox(width: width * 0.05),
                Text(
                  "Open Gallary",
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
