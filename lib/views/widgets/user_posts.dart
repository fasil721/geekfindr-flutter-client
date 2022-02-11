import 'package:flutter/material.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/services/posts.dart';
import 'package:geek_findr/views/widgets/image_edit.dart';
import 'package:get/get.dart';

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
              return const Center(
                child: CircularProgressIndicator(),
              );
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
                    itemBuilder: (context, index) => Column(
                      children: [
                        Image.network(
                          data[index].mediaUrl!,
                          fit: BoxFit.fill,
                          width: width,
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
                    ),
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
}
