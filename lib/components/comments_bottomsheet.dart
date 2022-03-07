import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/functions.dart';
import 'package:geek_findr/services/postServices/post_models.dart';
import 'package:geek_findr/views/other_users_profile.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class CommentBottomSheet extends StatelessWidget {
  CommentBottomSheet({
    Key? key,
    required this.imageId,
    required this.userList,
    required this.index,
  }) : super(key: key);
  final List<CommentedUsers> userList;
  final String imageId;
  final int index;
  final commmentEditController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: height * 0.01),
          Container(
            height: height * 0.006,
            width: width * 0.12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey.shade300,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10, right: 5),
            child: TextField(
              controller: commmentEditController,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 1,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  splashRadius: 25,
                  icon: const Icon(
                    Icons.send_rounded,
                  ),
                  onPressed: () async {
                    if (commmentEditController.text.isNotEmpty) {
                      await postServices.postComment(
                        imageId: imageId,
                        comment: commmentEditController.text,
                      );
                      feedController.commentCountList[index] += 1;
                      controller.update(["commentCount"]);
                      commmentEditController.clear();
                      final _commentedUser = CommentedUsers();
                      final _owner = getUserDatAsOwnerModel();
                      _commentedUser.comment = commmentEditController.text;
                      _commentedUser.owner = _owner;
                      userList.add(_commentedUser);
                      controller.update(["commentsList"]);
                    }
                  },
                ),
                border: InputBorder.none,
                hintText: 'Add comment',
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: GetBuilder<AppController>(
                id: "commentsList",
                builder: (_controller) => ListView.separated(
                  shrinkWrap: true,
                  itemCount: userList.length,
                  itemBuilder: (context, index) => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(
                            () => OtherUserProfile(
                              userId: userList[index].owner!.id!,
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            imageUrl: userList[index].owner!.avatar!,
                            fit: BoxFit.fitWidth,
                            width: width * 0.08,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey.withOpacity(0.3),
                              highlightColor: white,
                              period: const Duration(
                                milliseconds: 1000,
                              ),
                              child: Container(
                                height: width * 0.07,
                                width: width * 0.07,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: width * 0.03),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(
                                () => OtherUserProfile(
                                  userId: userList[index].owner!.id!,
                                ),
                              );
                            },
                            child: Text(
                              userList[index].owner!.username!,
                              style: GoogleFonts.roboto(
                                color: black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            userList[index].comment!,
                            style: GoogleFonts.roboto(
                              color: black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(height: height * 0.015),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
