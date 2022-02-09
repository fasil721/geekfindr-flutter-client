import 'package:flutter/material.dart';
import 'package:geek_findr/services/posts.dart';

class UserPosts extends StatelessWidget {
  const UserPosts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
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
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    Image.network(
                      data[index].mediaUrl!,
                      fit: BoxFit.fill,
                      width: width,
                    ),
                    Text(data[index].description!),
                  ],
                ),
                separatorBuilder: (BuildContext context, int index) => SizedBox(
                  height: height * 0.05,
                ),
              ),
            );
          }
        }
        return const SizedBox();
      },
    );
  }
}
