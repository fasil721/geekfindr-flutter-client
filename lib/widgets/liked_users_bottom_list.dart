import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/services/postServices/post_models.dart';
import 'package:geek_findr/services/postServices/posts.dart';
import 'package:geek_findr/views/other_users_profile.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class LikedUsersBottomSheet extends StatelessWidget {
   LikedUsersBottomSheet({
    Key? key,
    required this.imageId,
  }) : super(key: key);
  final String imageId;

final postServices = PostServices();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;
    return Container(
      color: secondaryColor,
      child: FutureBuilder<List<LikedUsers>?>(
        future: postServices.getLikedUsers(imageId: imageId),
        builder: (context, snapshot) {
          if (ConnectionState.done == snapshot.connectionState) {
            if (snapshot.data != null) {
              final a = snapshot.data!;
              final List<Owner> userList =
                  a.map((e) => e.owner).toList().cast();
              return ListView.builder(
                shrinkWrap: true,
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    // dense: true,
                    onTap: () {
                      Get.to(
                        () => OtherUserProfile(userId: userList[index].id!),
                      );
                    },
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        imageUrl: userList[index].avatar!,
                        fit: BoxFit.fitWidth,
                        width: 30,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey.withOpacity(0.3),
                          highlightColor: white,
                          period: const Duration(
                            milliseconds: 1000,
                          ),
                          child: Container(
                            height: 300,
                            width: width,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(
                                100,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    title: Text(userList[index].username!),
                  );
                },
              );
            }
          }
          return const SizedBox();
        },
      ),
    );
  }
}
