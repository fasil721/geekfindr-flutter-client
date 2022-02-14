import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/models/box_instance.dart';
import 'package:geek_findr/services/posts.dart';
import 'package:geek_findr/services/profile.dart';
import 'package:geek_findr/views/drawer_page.dart';
import 'package:geek_findr/views/widgets/comment_bottom_sheet.dart';
import 'package:geek_findr/views/widgets/image_upload.dart';
import 'package:geek_findr/views/other_users_profile.dart';
import 'package:geek_findr/views/widgets/search_widget.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final box = Boxes.getInstance();
  final _advancedDrawerController = AdvancedDrawerController();
  final imagePicker = ImagePicker();
  String? imagePath;
  List<bool> isComments = [];
  final commmentEditController = TextEditingController();
  final controller = Get.find<AppController>();
  @override
  Widget build(BuildContext context) {
    final currentUser = box.get("user");
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
                body: FutureBuilder<List<ImageModel>>(
                  future: getMyFeeds(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return skeleton(width);
                    }
                    if (snapshot.hasData) {
                      if (snapshot.data != null) {
                        final data = snapshot.data!;
                        for (int i = 0; i < data.length; i++) {
                          isComments.add(false);
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  100,
                                                ),
                                                border: Border.all(
                                                  width: 2,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  100,
                                                ),
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      Get.to(
                                                        () => OtherUserProfile(
                                                          userId: data[index]
                                                              .owner!
                                                              .id!,
                                                        ),
                                                      );
                                                    },
                                                    autofocus: true,
                                                    highlightColor:
                                                        Colors.orange,
                                                    splashColor: Colors.red,
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          "${data[index].owner!.avatar}&s=${height * 0.04}",
                                                      placeholder: (
                                                        context,
                                                        url,
                                                      ) =>
                                                          Shimmer.fromColors(
                                                        baseColor: Colors.grey
                                                            .withOpacity(0.3),
                                                        highlightColor:
                                                            Colors.white,
                                                        period: const Duration(
                                                          milliseconds: 1000,
                                                        ),
                                                        child: Container(
                                                          height: height * 0.04,
                                                          width: height * 0.04,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.grey,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              100,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: width * 0.04),
                                            Text(
                                              data[index].owner!.username!,
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
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
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl: data[index].mediaUrl!,
                                      fit: BoxFit.fitWidth,
                                      width: width,
                                      placeholder: (context, url) =>
                                          Shimmer.fromColors(
                                        baseColor: Colors.grey.withOpacity(0.3),
                                        highlightColor: Colors.white,
                                        period:
                                            const Duration(milliseconds: 1000),
                                        child: Container(
                                          height: 300,
                                          width: width,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 10, left: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(data[index].description!),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          GetBuilder<AppController>(
                                            id: "likes",
                                            builder: (_) {
                                              return FutureBuilder<
                                                  List<LikedUsers>?>(
                                                future: getLikedUsers(
                                                  imageId: data[index].id!,
                                                ),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.done) {
                                                    final likedUsers =
                                                        snapshot.data!;
                                                    final isLiked = likedUsers
                                                        .where(
                                                          (element) =>
                                                              element
                                                                  .owner!.id ==
                                                              currentUser!.id,
                                                        )
                                                        .isEmpty;
                                                    return !isLiked
                                                        ? IconButton(
                                                            splashRadius: 25,
                                                            splashColor:
                                                                Colors.grey,
                                                            tooltip: 'liked',
                                                            onPressed: () {},
                                                            icon: const Icon(
                                                              Icons
                                                                  .favorite_rounded,
                                                            ),
                                                          )
                                                        : IconButton(
                                                            splashRadius: 25,
                                                            splashColor:
                                                                Colors.grey,
                                                            tooltip: 'like',
                                                            onPressed: () {
                                                              postLike(
                                                                imageId:
                                                                    data[index]
                                                                        .id!,
                                                              );
                                                            },
                                                            icon: const Icon(
                                                              Icons
                                                                  .favorite_outline,
                                                            ),
                                                          );
                                                  }
                                                  return IconButton(
                                                    splashRadius: 25,
                                                    splashColor: Colors.grey,
                                                    onPressed: () {},
                                                    icon: const Icon(
                                                      Icons.favorite_outline,
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                          GetBuilder<AppController>(
                                            id: "likes",
                                            builder: (_) {
                                              return FutureBuilder<
                                                  List<LikedUsers>?>(
                                                future: getLikedUsers(
                                                  imageId: data[index].id!,
                                                ),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.done) {
                                                    if (snapshot.data != null) {
                                                      final likedUsersList =
                                                          snapshot.data!;
                                                      return InkWell(
                                                        onTap: () {
                                                          // getLikedUsers(
                                                          //   imageId:
                                                          //       data[index].id!,
                                                          // );
                                                        },
                                                        child: Ink(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(
                                                            10,
                                                          ),
                                                          child: Text(
                                                            likedUsersList
                                                                .length
                                                                .toString(),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  }
                                                  return const Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child: Text(" "),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                          IconButton(
                                            splashRadius: 25,
                                            tooltip: 'comment',
                                            onPressed: () {
                                              if (isComments[index]) {
                                                isComments[index] = false;
                                              } else {
                                                for (int i = 0;
                                                    i < isComments.length;
                                                    i++) {
                                                  isComments[i] = false;
                                                }
                                                isComments[index] = true;
                                              }
                                              controller.update(["comments"]);
                                              commmentEditController.clear();
                                            },
                                            icon: const Icon(
                                              Icons.mode_comment_outlined,
                                            ),
                                          ),
                                          GetBuilder<AppController>(
                                            id: "commentCount",
                                            builder: (_) {
                                              return FutureBuilder<
                                                  List<CommentedUsers>?>(
                                                future: getCommentedUsers(
                                                  imageId: data[index].id!,
                                                ),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.done) {
                                                    if (snapshot.data != null) {
                                                      final commentedUsers =
                                                          snapshot.data!;
                                                      return InkWell(
                                                        onTap: () {
                                                          Get.bottomSheet(
                                                            CommentBottomSheet(
                                                              commentedUsersList:
                                                                  commentedUsers,
                                                              imageId:
                                                                  data[index]
                                                                      .id!,
                                                            ),
                                                          );
                                                          isComments[index] =
                                                              false;
                                                          controller.update(
                                                            ["comments"],
                                                          );
                                                        },
                                                        child: Ink(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(
                                                            10,
                                                          ),
                                                          child: Text(
                                                            commentedUsers
                                                                .length
                                                                .toString(),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  }
                                                  return const SizedBox();
                                                },
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                      IconButton(
                                        splashRadius: 25,
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.group_add_outlined,
                                        ),
                                      ),
                                    ],
                                  ),
                                  GetBuilder<AppController>(
                                    id: "comments",
                                    builder: (context) {
                                      return Visibility(
                                        visible: isComments[index],
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: TextField(
                                            decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                splashRadius: 25,
                                                icon: const Icon(
                                                  Icons.send_rounded,
                                                ),
                                                onPressed: () {
                                                  if (commmentEditController
                                                      .text.isNotEmpty) {
                                                    postComment(
                                                      imageId: data[index].id!,
                                                      comment:
                                                          commmentEditController
                                                              .text,
                                                    );
                                                    isComments[index] = false;
                                                    controller
                                                        .update(["comments"]);
                                                  }
                                                },
                                              ),
                                              border: InputBorder.none,
                                              hintText: 'Add comment',
                                            ),
                                            controller: commmentEditController,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) => SizedBox(
                              height: height * 0.01,
                            ),
                          ),
                        );
                      }
                    }
                    return const SizedBox();
                  },
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

  Widget skeleton(double width) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.3),
      highlightColor: Colors.white,
      period: const Duration(milliseconds: 1000),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 2,
          itemBuilder: (context, index) => Column(
            children: [
              Container(
                width: width,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: width,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: width,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
