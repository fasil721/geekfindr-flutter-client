import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/models/box_instance.dart';
import 'package:geek_findr/services/postServices/post_models.dart';
import 'package:geek_findr/services/postServices/posts.dart';
import 'package:geek_findr/views/other_users_profile.dart';
import 'package:geek_findr/views/project_list.dart';
import 'package:geek_findr/widgets/comment_bottom_sheet.dart';
import 'package:geek_findr/widgets/heart_animation_widget.dart';
import 'package:geek_findr/widgets/liked_users_bottom_list.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:visibility_detector/visibility_detector.dart';

class FeedList extends StatefulWidget {
  const FeedList({Key? key}) : super(key: key);
  @override
  State<FeedList> createState() => _FeedListState();
}

class _FeedListState extends State<FeedList> {
  final commmentEditController = TextEditingController();
  final postServices = PostServices();
  final controller = Get.find<AppController>();
  final box = Boxes.getInstance();
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

  Future<void> mockData(String lastId) async {
    if (!allLoaded) {
      isLoading = true;
    }
    final newData = await postServices.getMyFeeds(lastId: lastId);
    if (newData.isNotEmpty) {
      datas.addAll(newData);
      itemsSetup(newData);
      likesSetUp();
      controller.update(["dataList"]);
    }
    print("datas.length ${datas.length}");
    isLoading = false;
    allLoaded = newData.isEmpty;
  }

  Future<void> likesSetUp() async {
    final currentUser = box.get("user");
    final List<bool> values = [];
    for (int i = 0; i < datas.length; i++) {
      final likedUsers = await postServices.getLikedUsers(
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
    }
  }

  void itemsSetup(List<ImageModel> values) {
    for (int i = 0; i < values.length; i++) {
      isLikedList.add(false);
    }
    for (int i = 0; i < values.length; i++) {
      isCommenting.add(false);
    }
    for (int i = 0; i < values.length; i++) {
      isHeartAnimatingList.add(false);
    }
    for (final e in values) {
      likesCountList.add(e.likeCount!);
    }
    for (final e in values) {
      commentCountList.add(e.commentCount!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return FutureBuilder<List<ImageModel>>(
      future: postServices.getMyFeeds(),
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
                      itemsSetup(datas);
                      // print("haiiiii");
                      likesSetUp();
                    }
                    isRefresh = false;
                    final postedTime =
                        findDatesDifferenceFromToday(datas[index].createdAt!);
                    return VisibilityDetector(
                      onVisibilityChanged: (info) {
                        if (info.visibleFraction == 1) {
                          // print("index $index");
                          if (datas.length - 3 <= index &&
                              !isLoading &&
                              (dataLength + 2) < index) {
                            dataLength = index;
                            // print(dataLength);
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
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            datas[index].owner!.username!,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            postedTime,
                                            style: GoogleFonts.roboto(
                                              fontSize: 10,
                                              color: black.withOpacity(0.8),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
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
                                    icon: Icon(
                                      Icons.more_horiz,
                                      color: black,
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
                                style: GoogleFonts.poppins(color: black),
                              ),
                            ),
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
                                              height: width * 0.65,
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
                                      postServices.postLike(
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
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                              ? primaryColor
                                              : black;
                                          return HeartAnimationWidget(
                                            isAnimating: isLikedList[index],
                                            child: IconButton(
                                              splashRadius: 28,
                                              onPressed: () {
                                                if (!isLikedList[index]) {
                                                  postServices.postLike(
                                                    imageId: datas[index].id!,
                                                  );
                                                }
                                                isLikedList[index] = true;
                                                contoller.update(["Like"]);
                                              },
                                              icon: Icon(
                                                icon,
                                                color: color,
                                                size: 28,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.mode_comment_outlined,
                                          color: black,
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
                                      Visibility(
                                        visible: datas[index].isProject!,
                                        child: IconButton(
                                          icon: ImageIcon(
                                            const AssetImage(
                                              "assets/icons/people.png",
                                            ),
                                            color: black,
                                            size: 23,
                                          ),
                                          splashRadius: 25,
                                          tooltip: 'join request',
                                          onPressed: () async {
                                            final a = await myProjects
                                                .sendJoinRequest(
                                              projectId: datas[index].id!,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
                                              await postServices.postComment(
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
