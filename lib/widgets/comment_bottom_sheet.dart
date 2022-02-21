import 'package:flutter/material.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/services/postServices/posts.dart';
import 'package:get/get.dart';

class CommentBottomSheet extends StatelessWidget {
  CommentBottomSheet({
    Key? key,
    required this.imageId,
  }) : super(key: key);
  final String imageId;
  final commmentEditController = TextEditingController();
  final postServices = PostServices();  final controller = Get.find<AppController>();
  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;
    return Container(
      color: secondaryColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 10),
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
                        imageId: imageId,
                        comment: commmentEditController.text,
                      );
                      controller.update(["commentCount"]);
                      commmentEditController.clear();
                    }
                  },
                ),
                border: InputBorder.none,
                hintText: 'Add comment',
              ),
              controller: commmentEditController,
            ),
          ),
          // ListView.builder(
          //   shrinkWrap: true,
          //   itemCount: commentedUsersList.length,
          //   itemBuilder: (context, index) {
          //     return Column(
          //       children: [
          //         Text(commentedUsersList[index].owner!.username!),
          //         Text(commentedUsersList[index].comment!)
          //       ],
          //     );
          //   },
          // )
        ],
      ),
    );
  }
}
