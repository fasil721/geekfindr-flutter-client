import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/views/drawer_page.dart';
import 'package:geek_findr/widgets/feed_list.dart';
import 'package:geek_findr/widgets/image_upload.dart';
import 'package:geek_findr/widgets/search_widget.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        // ),
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
            backgroundColor: Colors.white,
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  floating: true,
                  expandedHeight: 70,
                  elevation: 0,
                  backgroundColor: Colors.white,
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
                  snap: true,
                  floating: true,
                  toolbarHeight: 60,
                  backgroundColor: Colors.white,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: false,
                    background: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 5),
                      child: ListTile(
                        title: Text(
                          "Add your new post",
                          style: GoogleFonts.roboto(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: IconButton(
                          splashRadius: 25,
                          onPressed: () {
                            Get.dialog(
                              PostUploadDialoge(),
                            );
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
              body: FeedList(),
            ),
          ),
        ),
      ),
    );
  }
}
