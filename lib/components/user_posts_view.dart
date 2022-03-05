import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/services/postServices/post_models.dart';
import 'package:geek_findr/services/postServices/posts.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class UserPosts extends StatelessWidget {
  UserPosts({
    Key? key,
    required this.userId,
  }) : super(key: key);
  final String userId;
  final postServices = PostServices();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;
    return GetBuilder<AppController>(
      id: "mypost",
      builder: (controller) {
        return FutureBuilder<List<ImageModel>>(
          future: postServices.getMyImages(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return box(width);
            }
            if (snapshot.connectionState == ConnectionState.done) {
              final data = snapshot.data;
              if (data != null) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: MasonryGridView.count(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.length,
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          fit: BoxFit.fitWidth,
                          // width: width,
                          imageUrl: data[index].mediaUrl!,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey.withOpacity(0.3),
                            highlightColor: white,
                            period: const Duration(milliseconds: 1000),
                            child: Container(
                              // height: 300,
                              // width: width,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
                // return Padding(
                //   padding: const EdgeInsets.symmetric(
                //     horizontal: 20,
                //     vertical: 20,
                //   ),
                //   child: ListView.separated(
                //     physics: const ScrollPhysics(),
                //     shrinkWrap: true,
                //     itemCount: data.length,
                //     itemBuilder: (context, index) {
                // return Column(
                //   children: [
                //     ClipRRect(
                //       borderRadius: BorderRadius.circular(10),
                //       child: CachedNetworkImage(
                //         fit: BoxFit.fitWidth,
                //         width: width,
                //         imageUrl: data[index].mediaUrl!,
                //         placeholder: (context, url) => Shimmer.fromColors(
                //           baseColor: Colors.grey.withOpacity(0.3),
                //           highlightColor: white,
                //           period: const Duration(milliseconds: 1000),
                //           child: Container(
                //             height: 300,
                //             width: width,
                //             decoration: BoxDecoration(
                //               color: Colors.grey,
                //               borderRadius: BorderRadius.circular(10),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Expanded(child: Text(data[index].description!)),
                //           PopupMenuButton(
                //             itemBuilder: (BuildContext bc) => [
                //               const PopupMenuItem(
                //                 value: "2",
                //                 child: Text("edit post"),
                //               ),
                //               const PopupMenuItem(
                //                 value: "1",
                //                 child: Text("delete post"),
                //               ),
                //             ],
                //             onSelected: (value) {
                //               if (value == "1") {
                //                 deleteImage(imageId: data[index].id!);
                //                 // SystemChannels.textInput
                //                 //     .invokeMethod("TextInput.hide");
                //               }
                //               if (value == "2") {
                //                 Get.dialog(
                //                   PostEditDialoge(
                //                     imageModel: data[index],
                //                   ),
                //                 );
                //               }
                //             },
                //             icon: const Icon(
                //               Icons.more_horiz,
                //               color: Colors.black,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ],
                // );
                //     },
                //     separatorBuilder: (BuildContext context, int index) =>
                //         SizedBox(
                //       height: height * 0.05,
                //     ),
                //   ),
                // );
              }
            }
            return const SizedBox();
          },
        );
      },
    );
  }

  Widget box(double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Shimmer.fromColors(
              baseColor: Colors.grey.withOpacity(0.3),
              highlightColor: white,
              period: const Duration(milliseconds: 1000),
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 2,
                  itemBuilder: (context, index) => Column(
                    children: [
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Shimmer.fromColors(
              baseColor: Colors.grey.withOpacity(0.3),
              highlightColor: white,
              period: const Duration(milliseconds: 1000),
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 2,
                  itemBuilder: (context, index) => Column(
                    children: [
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
