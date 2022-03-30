import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/database/box_instance.dart';
import 'package:geek_findr/models/post_models.dart';
import 'package:geek_findr/resources/colors.dart';
import 'package:geek_findr/resources/constants.dart';
import 'package:geek_findr/resources/functions.dart';
import 'package:geek_findr/views/components/comments_bottomsheet.dart';
import 'package:geek_findr/views/components/heart_animation_widget.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';

class PostViewDialoge extends StatefulWidget {
  const PostViewDialoge({
    Key? key,
    required this.imageModel,
    required this.index,
  }) : super(key: key);
  final ImageModel imageModel;
  final int index;

  @override
  State<PostViewDialoge> createState() => _PostEditDialogeState();
}

class _PostEditDialogeState extends State<PostViewDialoge> {
  TextEditingController? descTextController;
  final commmentEditController = TextEditingController();
  bool isRequested = false;
  bool isLiked = false;
  bool isHeartAnimating = false;
  bool isCommenting = false;

  @override
  void initState() {
    descTextController =
        TextEditingController(text: widget.imageModel.description);
    super.initState();
  }

  Future<void> itemsSetUp() async {
    final currentUser = Boxes.getCurrentUser();
    if (widget.imageModel.isProject!) {
      isRequested = checkRequest(widget.imageModel.teamJoinRequests!);
    }
    final likedUsers = await postServices.getLikedUsers(
      imageId: widget.imageModel.id!,
    );
    isLiked = likedUsers!
        .where(
          (element) => element.owner!.id == currentUser.id,
        )
        .isNotEmpty;
    controller.update(["postView"]);
  }

  bool findIsCurrentUser() {
    final currentUser = Boxes.getCurrentUser();
    return currentUser.id == widget.imageModel.owner!.id;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final postedTime =
        findDatesDifferenceFromToday(widget.imageModel.createdAt!);
    final isCurrentUser = findIsCurrentUser();
    itemsSetUp();
    return GetBuilder<AppController>(
      id: "postView",
      builder: (controller) {
        return Column(
          mainAxisAlignment:
              isCommenting ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Material(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(30),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(width: 1.5, color: white),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                imageUrl:
                                    "${widget.imageModel.owner!.avatar}&s=${height * 0.04}",
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                  baseColor: Colors.grey.withOpacity(0.3),
                                  highlightColor: white,
                                  period: const Duration(
                                    milliseconds: 1000,
                                  ),
                                  child: Container(
                                    height: height * 0.04,
                                    width: height * 0.04,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.04),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.imageModel.owner!.username!,
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
                    ),
                    Visibility(
                      visible: widget.imageModel.isProject!,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 10, bottom: 5),
                        child: Text(
                          widget.imageModel.projectName!,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 10, bottom: 10),
                      child: ReadMoreText(
                        widget.imageModel.description!,
                        colorClickableText: primaryColor,
                        trimMode: TrimMode.Line,
                        style: GoogleFonts.poppins(color: black),
                      ),
                    ),
                    GestureDetector(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: widget.imageModel.mediaUrl!,
                              fit: BoxFit.fitWidth,
                              width: width,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey.withOpacity(0.3),
                                highlightColor: white,
                                period: const Duration(
                                  milliseconds: 1000,
                                ),
                                child: Container(
                                  height: width * 0.65,
                                  width: width,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Opacity(
                            opacity: isHeartAnimating ? 1 : 0,
                            child: HeartAnimationWidget(
                              duration: const Duration(milliseconds: 700),
                              isAnimating: isHeartAnimating,
                              child: const Icon(
                                Icons.favorite,
                                color: Colors.white,
                                size: 60,
                              ),
                              onEnd: () {
                                isHeartAnimating = false;
                                controller.update(["postView"]);
                              },
                            ),
                          )
                        ],
                      ),
                      onDoubleTap: () {
                        if (!isLiked) {
                          postController.userPostLikesCountList[widget.index] +=
                              1;
                          postServices.postLike(
                            imageId: widget.imageModel.id!,
                          );
                        }
                        isLiked = true;
                        isHeartAnimating = true;
                        controller.update(["postView"]);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (0 <
                                      postController.userPostLikesCountList[
                                          widget.index]) {
                                    buildLikedUsersBottomSheet(
                                      widget.imageModel.id!,
                                    );
                                  }
                                },
                                child: Ink(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    "${postController.userPostLikesCountList[widget.index]} Likes",
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  if (0 <
                                      postController.userPostCommentCountList[
                                          widget.index]) {
                                    Get.dialog(loadingIndicator());
                                    final data =
                                        await postServices.getCommentedUsers(
                                      imageId: widget.imageModel.id!,
                                    );
                                    Get.back();
                                    Get.bottomSheet(
                                      CommentBottomSheet(
                                        index: widget.index,
                                        imageId: widget.imageModel.id!,
                                        userList: data!,
                                      ),
                                    );
                                  }
                                },
                                child: Ink(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    "${postController.userPostCommentCountList[widget.index]} Comments",
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              buildLikesAndCommentRow(
                                isCurrentUser: isCurrentUser,
                              ),
                              Visibility(
                                visible: isCurrentUser &&
                                    !widget.imageModel.isProject!,
                                child: PopupMenuButton(
                                  itemBuilder: (BuildContext bc) => [
                                    const PopupMenuItem(
                                      value: "2",
                                      child: Text("edit post"),
                                    ),
                                    const PopupMenuItem(
                                      value: "1",
                                      child: Text("delete post"),
                                    ),
                                  ],
                                  onSelected: (value) {
                                    if (value == "1") {
                                      postServices.deleteImage(
                                        imageId: widget.imageModel.id!,
                                      );
                                      Get.back();
                                    }
                                    if (value == "2") {}
                                  },
                                  icon: const Icon(
                                    Icons.more_horiz,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: isCurrentUser &&
                                    widget.imageModel.isProject!,
                                child: PopupMenuButton(
                                  itemBuilder: (BuildContext bc) => [
                                    const PopupMenuItem(
                                      value: "2",
                                      child: Text("edit post"),
                                    ),
                                  ],
                                  onSelected: (value) {
                                    if (value == "2") {}
                                  },
                                  icon: const Icon(
                                    Icons.more_horiz,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    _buildCommentField(widget.index)
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCommentField(int index) => GetBuilder<AppController>(
        id: "comments",
        builder: (_) => Visibility(
          visible: isCommenting,
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
                    if (commmentEditController.text.isNotEmpty) {
                      await postServices.postComment(
                        imageId: widget.imageModel.id!,
                        comment: commmentEditController.text,
                      );
                      postController.userPostCommentCountList[index] += 1;
                      isCommenting = false;
                      controller.update(["comments", "postView"]);
                    }
                  },
                ),
                border: InputBorder.none,
                hintText: 'Add comment',
              ),
              controller: commmentEditController,
            ),
          ),
        ),
      );

  Widget buildLikesAndCommentRow({required bool isCurrentUser}) {
    final icon = isLiked ? Icons.favorite : Icons.favorite_border_outlined;
    final color = isLiked ? primaryColor : black;
    return Row(
      children: [
        HeartAnimationWidget(
          isAnimating: isLiked,
          child: IconButton(
            splashRadius: 28,
            onPressed: () {
              if (!isLiked) {
                postController.userPostLikesCountList[widget.index] += 1;
                postServices.postLike(imageId: widget.imageModel.id!);
              }
              isLiked = true;
              controller.update(["postView"]);
            },
            icon: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.mode_comment_outlined, color: black, size: 28),
          splashRadius: 25,
          tooltip: 'comment',
          onPressed: () {
            if (isCommenting) {
              isCommenting = false;
            } else {
              isCommenting = true;
            }
            controller.update(["comments"]);
            commmentEditController.clear();
          },
        ),
        Visibility(
          visible:
              !isCurrentUser && widget.imageModel.isProject! && !isRequested,
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
            onPressed: () {
              postServices.sendJoinRequest(
                projectName: widget.imageModel.projectName!,
                projectId: widget.imageModel.id!,
              );
              isRequested = false;
              controller.update(["dataList"]);
            },
          ),
        ),
      ],
    );
  }
}
