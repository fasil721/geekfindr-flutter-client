import 'package:flutter/material.dart';
import 'package:geek_findr/services/posts.dart';

class UserPosts extends StatelessWidget {
  const UserPosts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PostImage>>(
      future: getMyImages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          final data = snapshot.data;
          if (data != null) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) => Column(
                children: [
                  Image.network(
                    data[index].mediaUrl!,
                    fit: BoxFit.cover,
                  ),
                  Text(data[index].description!),
                ],
              ),
            );
          }
        }
        return const SizedBox();
      },
    );
  }
}
