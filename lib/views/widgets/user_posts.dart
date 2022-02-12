import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/services/posts.dart';
import 'package:geek_findr/views/widgets/image_edit.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class UserPosts extends StatelessWidget {
  const UserPosts({
    Key? key,
    required this.userId,
  }) : super(key: key);
  final String userId;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GetBuilder<AppController>(
      id: "mypost",
      builder: (controller) {
        return FutureBuilder<List<ImageModel>>(
          future: getMyImages(userId),
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
                  child: ListView.separated(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: data[index].mediaUrl!,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey.withOpacity(0.3),
                                highlightColor: Colors.white,
                                period: const Duration(milliseconds: 1000),
                                child: Container(
                                  height: 300,
                                  width: width,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(data[index].description!),
                                PopupMenuButton(
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
                                      deleteImage(imageId: data[index].id!);
                                    }
                                    if (value == "2") {
                                      Get.dialog(
                                        PostEditDialoge(
                                          imageModel: data[index],
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.more_horiz,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(
                      height: height * 0.05,
                    ),
                  ),
                );
              }
            }
            return const SizedBox();
          },
        );
      },
    );
  }

  Widget box(double width) {
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
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: width,
                height: 40,
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
