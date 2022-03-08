import 'package:geek_findr/contants.dart';
import 'package:geek_findr/services/postServices/post_models.dart';
import 'package:get/get.dart';

class AppController extends GetxController {}

class PostsController extends GetxController {
  List<int> feedLikesCountList = [];
  List<int> feedCommentCountList = [];
  List<int> userPostLikesCountList = [];
  List<int> userPostCommentCountList = [];

  void likesAndCommentsCountSetUp(List<ImageModel> data) {
    postController.userPostCommentCountList = [];
    for (final e in data) {
      postController.userPostCommentCountList.add(e.commentCount!);
    }
    postController.userPostLikesCountList = [];
    for (final e in data) {
      postController.userPostLikesCountList.add(e.likeCount!);
    }
  }
}

class ChatController extends GetxController {}
