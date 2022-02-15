import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/services/posts.dart';
import 'package:geek_findr/views/other_users_profile.dart';
import 'package:geek_findr/widgets/comment_bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:visibility_detector/visibility_detector.dart';

// ignore: must_be_immutable
class FeedList extends StatelessWidget {
  FeedList({Key? key}) : super(key: key);
  final commmentEditController = TextEditingController();
  List<bool> isComments = [];
  List<int> likesCountList = [];
  List<int> commentCountList = [];
  List<ImageModel> datas = [];
  bool isLoading = false;
  bool allLoaded = false;

  Future mockData(String lastId) async {
    if (!allLoaded) {
      isLoading = true;
      // controller.update(["dataList"]);
    }
    final newData = await getMyFeeds(lastId: lastId);
    // print("length = ${newData.length}");
    if (newData.isNotEmpty) {
      datas.addAll(newData);
      controller.update(["dataList"]);
    }
    isLoading = false;
    allLoaded = newData.isEmpty;
    // controller.update(["dataList"]);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = box.get("user");
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
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: GetBuilder<AppController>(
                id: "dataList",
                builder: (contoller) {
                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: datas.length,
                    itemBuilder: (context, index) {
                      // final last = datas.length - 1;
                      isComments = [];
                      for (int i = 0; i < datas.length; i++) {
                        isComments.add(false);
                      }
                      likesCountList = [];
                      for (final e in datas) {
                        likesCountList.add(e.likeCount!);
                      }
                      commentCountList = [];
                      for (final e in datas) {
                        commentCountList.add(e.commentCount!);
                      }
                      return VisibilityDetector(
                        onVisibilityChanged: (info) {
                          if (info.visibleFraction == 1) {
                            print(index);
                            if (datas.length - 3 <= index && !isLoading) {
                              // print(
                              //     "length2 = ${datas[last].id}");
                              mockData(datas.last.id!);
                            }
                          }
                        },
                        key: UniqueKey(),
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
                                            width: 2,
                                            color: Colors.grey,
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
                                                  highlightColor: Colors.white,
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
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: datas[index].mediaUrl!,
                                fit: BoxFit.fitWidth,
                                width: width,
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                  baseColor: Colors.grey.withOpacity(0.3),
                                  highlightColor: Colors.white,
                                  period: const Duration(
                                    milliseconds: 1000,
                                  ),
                                  child: Container(
                                    height: 300,
                                    width: width,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                left: 5,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(datas[index].description!),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    GetBuilder<AppController>(
                                      id: "likes",
                                      builder: (_) {
                                        return FutureBuilder<List<LikedUsers>?>(
                                          future: getLikedUsers(
                                            imageId: datas[index].id!,
                                          ),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              final likedUsers = snapshot.data!;
                                              final isLiked = likedUsers
                                                  .where(
                                                    (element) =>
                                                        element.owner!.id ==
                                                        currentUser!.id,
                                                  )
                                                  .isEmpty;
                                              return !isLiked
                                                  ? IconButton(
                                                      splashRadius: 25,
                                                      splashColor: Colors.grey,
                                                      tooltip: 'liked',
                                                      onPressed: () {},
                                                      icon: const Icon(
                                                        Icons.favorite_rounded,
                                                      ),
                                                    )
                                                  : IconButton(
                                                      splashRadius: 25,
                                                      splashColor: Colors.grey,
                                                      tooltip: 'like',
                                                      onPressed: () {
                                                        likesCountList[index] +=
                                                            1;
                                                        postLike(
                                                          imageId:
                                                              datas[index].id!,
                                                        );
                                                      },
                                                      icon: const Icon(
                                                        Icons.favorite_outline,
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
                                        return InkWell(
                                          onTap: () {
                                            // getLikedUsers(
                                            //   imageId:
                                            //       datas[index].id!,
                                            // );
                                          },
                                          child: Ink(
                                            padding: const EdgeInsets.all(
                                              10,
                                            ),
                                            child: Text(
                                              likesCountList[index].toString(),
                                            ),
                                          ),
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
                                        return InkWell(
                                          onTap: () {
                                            Get.bottomSheet(
                                              CommentBottomSheet(
                                                imageId: datas[index].id!,
                                              ),
                                            );
                                            isComments[index] = false;
                                            controller.update(
                                              ["comments"],
                                            );
                                          },
                                          child: Ink(
                                            padding: const EdgeInsets.all(
                                              10,
                                            ),
                                            child: Text(
                                              commentCountList[index]
                                                  .toString(),
                                            ),
                                          ),
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
                              builder: (_) {
                                return Visibility(
                                  visible: isComments[index],
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
                                              isComments[index] = false;
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
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(
                      height: height * 0.01,
                    ),
                  );
                },
              ),
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
