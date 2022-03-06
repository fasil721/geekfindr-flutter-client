import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geek_findr/components/comment_bottom_sheet.dart';
import 'package:geek_findr/components/heart_animation_widget.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/models/user_model.dart';
import 'package:geek_findr/services/postServices/post_models.dart';
import 'package:geek_findr/services/postServices/posts.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';

class PostViewDialoge extends StatefulWidget {
  const PostViewDialoge({
    Key? key,
    required this.imageModel,
  }) : super(key: key);
  final ImageModel imageModel;

  @override
  State<PostViewDialoge> createState() => _PostEditDialogeState();
}

class _PostEditDialogeState extends State<PostViewDialoge> {
  TextEditingController? descTextController;
  final commmentEditController = TextEditingController();
  final postServices = PostServices();

  final controller = Get.find<AppController>();
  bool isRequested = false;
  bool isLiked = false;
  bool isHeartAnimating = false;
  late int likesCount;
  late int commentsCount;
  UserModel? currentUser;

  @override
  void initState() {
    descTextController =
        TextEditingController(text: widget.imageModel.description);
    currentUser = box.get("user");
    super.initState();
  }

  Future<void> itemsSetUp() async {
    likesCount = widget.imageModel.likeCount!;
    commentsCount = widget.imageModel.commentCount!;
    if (widget.imageModel.isProject!) {
      isRequested = checkRequest(widget.imageModel.teamJoinRequests!);
    }
    final likedUsers = await postServices.getLikedUsers(
      imageId: widget.imageModel.id!,
    );
    isLiked = likedUsers!
        .where(
          (element) => element.owner!.id == currentUser!.id,
        )
        .isNotEmpty;
    controller.update(["postView"]);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final postedTime =
        findDatesDifferenceFromToday(widget.imageModel.createdAt!);
    final isCurrentUser = currentUser!.id == widget.imageModel.owner!.id;
    itemsSetUp();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GetBuilder<AppController>(
          id: "postView",
          builder: (controller) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Material(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(30),
                child: SingleChildScrollView(
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
                                        borderRadius:
                                            BorderRadius.circular(100),
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
                      // Visibility(
                      //   visible: widget.imageModel.isProject!,
                      //   child: Container(
                      //     alignment: Alignment.centerLeft,
                      //     padding: const EdgeInsets.only(left: 10, bottom: 5),
                      //     child: Text(
                      //       widget.imageModel.projectName!,
                      //       style: GoogleFonts.poppins(
                      //         fontSize: 13,
                      //         color: black,
                      //         fontWeight: FontWeight.w600,
                      //       ),
                      //     ),
                      //   ),
                      // ),
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
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
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
                                      borderRadius: BorderRadius.circular(
                                        20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Opacity(
                              opacity: isHeartAnimating ? 1 : 0,
                              child: HeartAnimationWidget(
                                duration: const Duration(
                                  milliseconds: 700,
                                ),
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
                            likesCount += 1;
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
                                  onTap: () async {
                                    buildLikedUsersBottomSheet;
                                  },
                                  child: Ink(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      "$likesCount Likes",
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.bottomSheet(
                                      CommentBottomSheet(
                                        imageId: widget.imageModel.id!,
                                      ),
                                    );
                                  },
                                  child: Ink(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      "$commentsCount Comments",
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
                                  visible: isCurrentUser,
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
                                        // SystemChannels.textInput
                                        //     .invokeMethod("TextInput.hide");
                                      }
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
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 10),
        //   child: Material(
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Row(
        //           children: [
        //             IconButton(
        //               onPressed: () async {
        //                 // image = await pickImage(source: ImageSource.gallery);
        //                 // controller.update(["img"]);
        //               },
        //               icon: const Icon(Icons.image),
        //             ),
        //             IconButton(
        //               onPressed: () async {
        //                 // image = await pickImage(source: ImageSource.camera);
        //                 // controller.update(["img"]);
        //               },
        //               icon: const Icon(Icons.camera),
        //             )
        //           ],
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.symmetric(horizontal: 10),
        //           child: ElevatedButton(
        //             onPressed: () {
        //               if (descTextController!.text.isNotEmpty &&
        //                   descTextController!.text !=
        //                       widget.imageModel.description) {
        //                 final body = {"description": descTextController!.text};
        //                 postServices.editImage(
        //                   imageId: widget.imageModel.id!,
        //                   body: body,
        //                 );
        //               }
        //             },
        //             child: const Text("Save"),
        //           ),
        //         )
        //       ],
        //     ),
        //   ),
        // )
      ],
    );
  }

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
                likesCount += 1;
                postServices.postLike(
                  imageId: widget.imageModel.id!,
                );
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
          icon: Icon(
            Icons.mode_comment_outlined,
            color: black,
            size: 28,
          ),
          splashRadius: 25,
          tooltip: 'comment',
          onPressed: () {
            Get.bottomSheet(
              CommentBottomSheet(
                imageId: widget.imageModel.id!,
              ),
            );
            controller.update(["postView"]);
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

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         GetBuilder<AppController>(
//           builder: (controller) {
//             return Container(
//               margin: const EdgeInsets.symmetric(horizontal: 10),
//               color: white,
//               height: height * 0.5,
//               child: Material(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       TextField(
//                         controller: descTextController,
//                         textInputAction: TextInputAction.done,
//                         keyboardType: TextInputType.multiline,
//                         maxLines: null,
//                         minLines: 1,
//                         decoration: const InputDecoration(
//                           border: InputBorder.none,
//                           hintText: "Description",
//                           filled: true,
//                           fillColor: white,
//                           focusedBorder: InputBorder.none,
//                           enabledBorder: InputBorder.none,
//                           errorBorder: InputBorder.none,
//                           disabledBorder: InputBorder.none,
//                         ),
//                       ),
//                       SizedBox(
//                         height: height * 0.43,
//                         child: Image.network(
//                           widget.imageModel.mediaUrl!,
//                           width: double.infinity,
//                           fit: BoxFit.fitHeight,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: Material(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     IconButton(
//                       onPressed: () async {
//                         // image = await pickImage(source: ImageSource.gallery);
//                         // controller.update(["img"]);
//                       },
//                       icon: const Icon(Icons.image),
//                     ),
//                     IconButton(
//                       onPressed: () async {
//                         // image = await pickImage(source: ImageSource.camera);
//                         // controller.update(["img"]);
//                       },
//                       icon: const Icon(Icons.camera),
//                     )
//                   ],
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   child: ElevatedButton(
//                     onPressed: () {
//                       if (descTextController!.text.isNotEmpty &&
//                           descTextController!.text !=
//                               widget.imageModel.description) {
//                         final body = {"description": descTextController!.text};
//                         postServices.editImage(
//                           imageId: widget.imageModel.id!,
//                           body: body,
//                         );
//                       }
//                     },
//                     child: const Text("Save"),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }
