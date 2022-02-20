import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/services/posts.dart';
import 'package:geek_findr/views/other_users_profile.dart';
import 'package:geek_findr/widgets/comment_bottom_sheet.dart';
import 'package:geek_findr/widgets/heart_animation_widget.dart';
import 'package:geek_findr/widgets/liked_users_bottom_list.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:visibility_detector/visibility_detector.dart';

// ignore: must_be_immutable
class FeedList extends StatefulWidget {
  @override
  State<FeedList> createState() => _FeedListState();
}

class _FeedListState extends State<FeedList> {
  final commmentEditController = TextEditingController();
  List<bool> isCommenting = [];
  List<int> likesCountList = [];
  List<int> commentCountList = [];
  List<bool> isLikedList = [];
  List<bool> isHeartAnimatingList = [];
  List<ImageModel> datas = [];
  bool isLoading = false;
  bool allLoaded = false;
  int dataLength = -1;
  bool isRefresh = true;

  Future mockData(String lastId) async {
    if (!allLoaded) {
      isLoading = true;
    }
    final newData = await getMyFeeds(lastId: lastId);
    if (newData.isNotEmpty) {
      datas.addAll(newData);
      // print("datas.length ${datas.length}");
      isRefresh = true;
      controller.update(["dataList"]);
    }
    isLoading = false;
    allLoaded = newData.isEmpty;
  }

  Future<void> setUp(List<ImageModel> data) async {
    final currentUser = box.get("user");
    final List<bool> values = [];
    for (int i = 0; i < datas.length; i++) {
      final likedUsers = await getLikedUsers(
        imageId: datas[i].id!,
      );
      final isLiked = likedUsers!
          .where(
            (element) => element.owner!.id == currentUser!.id,
          )
          .isNotEmpty;
      values.add(isLiked);
    }
    if (values.isNotEmpty) {
      isLikedList = values;
      controller.update(["Like"]);
      print("ffff");
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return FutureBuilder<List<ImageModel>>(
      future: getMyFeeds(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return skeleton(width);
        }
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            datas = [];
            datas = snapshot.data!;
            return GetBuilder<AppController>(
              id: "dataList",
              builder: (contoller) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: datas.length,
                  itemBuilder: (context, index) {
                    if (isRefresh) {
                      isCommenting = [];
                      for (int i = 0; i < datas.length; i++) {
                        isCommenting.add(false);
                      }
                      isHeartAnimatingList = [];
                      for (int i = 0; i < datas.length; i++) {
                        isHeartAnimatingList.add(false);
                      }
                      isLikedList = [];
                      for (int i = 0; i < datas.length; i++) {
                        isLikedList.add(false);
                      }
                      likesCountList = [];
                      for (final e in datas) {
                        likesCountList.add(e.likeCount!);
                      }
                      commentCountList = [];
                      for (final e in datas) {
                        commentCountList.add(e.commentCount!);
                      }
                      print("haiiiii");
                      setUp(datas);
                    }
                    isRefresh = false;

                    return VisibilityDetector(
                      onVisibilityChanged: (info) {
                        if (info.visibleFraction == 1) {
                          print("index $index"); //
                          if (datas.length - 3 <= index &&
                              !isLoading &&
                              (dataLength + 2) < index) {
                            dataLength = index;
                            print(dataLength);
                            mockData(datas.last.id!);
                          }
                        }
                      },
                      key: UniqueKey(),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(
                            30,
                          ),
                        ),
                        child: Column(
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
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                          border: Border.all(
                                            width: 1.5,
                                            color: white,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () async {
                                                Get.to(
                                                  () => OtherUserProfile(
                                                    userId:
                                                        datas[index].owner!.id!,
                                                  ),
                                                );
                                              },
                                              autofocus: true,
                                              highlightColor: Colors.orange,
                                              splashColor: Colors.red,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    "${datas[index].owner!.avatar}&s=${height * 0.04}",
                                                placeholder: (
                                                  context,
                                                  url,
                                                ) =>
                                                    Shimmer.fromColors(
                                                  baseColor:
                                                      Colors.grey.withOpacity(
                                                    0.3,
                                                  ),
                                                  highlightColor: white,
                                                  period: const Duration(
                                                    milliseconds: 1000,
                                                  ),
                                                  child: Container(
                                                    height: height * 0.04,
                                                    width: height * 0.04,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
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
                                      SizedBox(
                                        width: width * 0.04,
                                      ),
                                      Text(
                                        datas[index].owner!.username!,
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
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(
                                left: 10,
                                bottom: 10,
                              ),
                              child: ReadMoreText(
                                datas[index].description!,
                                colorClickableText: primaryColor,
                                trimMode: TrimMode.Line,
                                style: GoogleFonts.poppins(color: Colors.black),
                              ),
                            ),

                            // ClipRRect(
                            //   borderRadius: BorderRadius.circular(20),
                            //   child: FadeInImage.memoryNetwork(
                            //     placeholder: kTransparentImage,
                            //     image: 'https://picsum.photos/250?image=9',
                            //   ),
                            // ),
                            GetBuilder<AppController>(
                              id: "Like",
                              builder: (controller) {
                                return GestureDetector(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: CachedNetworkImage(
                                          imageUrl: datas[index].mediaUrl!,
                                          fit: BoxFit.fitWidth,
                                          width: width,
                                          placeholder: (context, url) =>
                                              Shimmer.fromColors(
                                            baseColor:
                                                Colors.grey.withOpacity(0.3),
                                            highlightColor: white,
                                            period: const Duration(
                                              milliseconds: 1000,
                                            ),
                                            child: Container(
                                              height: width * 0.8,
                                              width: width,
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Opacity(
                                        opacity:
                                            isHeartAnimatingList[index] ? 1 : 0,
                                        child: HeartAnimationWidget(
                                          duration:
                                              const Duration(milliseconds: 700),
                                          isAnimating:
                                              isHeartAnimatingList[index],
                                          child: const Icon(
                                            Icons.favorite,
                                            color: Colors.white,
                                            size: 60,
                                          ),
                                          onEnd: () {
                                            isHeartAnimatingList[index] = false;
                                            controller.update(["Like"]);
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                  onDoubleTap: () {
                                    if (!isLikedList[index]) {
                                      postLike(
                                        imageId: datas[index].id!,
                                      );
                                    }
                                    isLikedList[index] = true;
                                    isHeartAnimatingList[index] = true;
                                    controller.update(["Like"]);
                                  },
                                );
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    GetBuilder<AppController>(
                                      id: "likes",
                                      builder: (_) {
                                        return InkWell(
                                          onTap: () async {
                                            Get.bottomSheet(
                                              LikedUsersBottomSheet(
                                                imageId: datas[index].id!,
                                              ),
                                            );
                                          },
                                          child: Ink(
                                            padding: const EdgeInsets.all(
                                              5,
                                            ),
                                            child: Text(
                                              "${likesCountList[index]} Likes",
                                              style: GoogleFonts.roboto(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    GetBuilder<AppController>(
                                      id: "commentCount",
                                      builder: (_) {
                                        return InkWell(
                                          onTap: () {
                                            Get.bottomSheet(
                                              CommentBottomSheet(
                                                imageId: datas[index].id!,
                                              ),
                                            );
                                            isCommenting[index] = false;
                                            controller.update(
                                              ["comments"],
                                            );
                                          },
                                          child: Ink(
                                            padding: const EdgeInsets.all(
                                              5,
                                            ),
                                            child: Text(
                                              "${commentCountList[index]} Comments",
                                              style: GoogleFonts.roboto(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    GetBuilder<AppController>(
                                      id: "Like",
                                      builder: (_) {
                                        final icon = isLikedList[index]
                                            ? Icons.favorite
                                            : Icons.favorite_border_outlined;
                                        final color = isLikedList[index]
                                            ? Colors.red
                                            : Colors.black;
                                        return HeartAnimationWidget(
                                          isAnimating: isLikedList[index],
                                          child: IconButton(
                                            splashRadius: 25,
                                            onPressed: () {
                                              isLikedList[index] = true;
                                              contoller.update(["Like"]);
                                            },
                                            icon: Icon(
                                              icon,
                                              color: color,
                                              size: 25,
                                            ),
                                          ),
                                        );
                                        // return FutureBuilder<List<LikedUsers>?>(
                                        //   future: getLikedUsers(
                                        //     imageId: datas[index].id!,
                                        //   ),
                                        //   builder: (context, snapshot) {
                                        //     if (snapshot.connectionState ==
                                        //         ConnectionState.done) {
                                        //       final likedUsers = snapshot.data!;
                                        // final isLiked = likedUsers
                                        //     .where(
                                        //       (element) =>
                                        //           element.owner!.id ==
                                        //           currentUser!.id,
                                        //     )
                                        //     .isEmpty;
                                        //       return !isLiked
                                        //           ? IconButton(
                                        //               splashRadius: 25,
                                        //               splashColor: Colors.grey,
                                        //               tooltip: 'liked',
                                        //               onPressed: () {},
                                        //               icon: const Icon(
                                        //                 Icons.favorite_rounded,
                                        //                 color: primaryColor,
                                        //                 size: 28,
                                        //               ),
                                        //             )
                                        //           : IconButton(
                                        //               splashRadius: 5,
                                        //               splashColor: Colors.grey,
                                        //               tooltip: 'like',
                                        //               onPressed: () {
                                        //                 likesCountList[index] +=
                                        //                     1;
                                        // postLike(
                                        //   imageId:
                                        //       datas[index].id!,
                                        // );
                                        //               },
                                        //               icon: Icon(
                                        //                 Icons.favorite_outline,
                                        //                 color: Colors.black
                                        //                     .withOpacity(0.8),
                                        //                 size: 28,
                                        //               ),
                                        //             );
                                        //     }
                                        //     return IconButton(
                                        //       splashRadius: 5,
                                        //       onPressed: () {},
                                        //       icon: const Icon(
                                        //         Icons.favorite_outline,
                                        //         color: Colors.black,
                                        //         size: 28,
                                        //       ),
                                        //     );
                                        //   },
                                        // );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.mode_comment_outlined,
                                        color: primaryColor,
                                        size: 28,
                                      ),
                                      splashRadius: 25,
                                      tooltip: 'comment',
                                      onPressed: () {
                                        if (isCommenting[index]) {
                                          isCommenting[index] = false;
                                        } else {
                                          for (int i = 0;
                                              i < isCommenting.length;
                                              i++) {
                                            isCommenting[i] = false;
                                          }
                                          isCommenting[index] = true;
                                        }
                                        controller.update(["comments"]);
                                        commmentEditController.clear();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            GetBuilder<AppController>(
                              id: "comments",
                              builder: (_) {
                                return Visibility(
                                  visible: isCommenting[index],
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          splashRadius: 25,
                                          icon: const Icon(
                                            Icons.send_rounded,
                                          ),
                                          onPressed: () async {
                                            if (commmentEditController
                                                .text.isNotEmpty) {
                                              await postComment(
                                                imageId: datas[index].id!,
                                                comment:
                                                    commmentEditController.text,
                                              );
                                              commentCountList[index] += 1;
                                              isCommenting[index] = false;
                                              controller.update(["comments"]);
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
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        }
        return const SizedBox();
      },
    );
  }
}

Widget skeleton(double width) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.withOpacity(0.3),
    highlightColor: white,
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
