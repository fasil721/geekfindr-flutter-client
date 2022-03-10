import 'package:geek_findr/models/post_models.dart';
import 'package:get/get.dart';

class PostsController extends GetxController {
  List<int> feedLikesCountList = [];
  List<int> feedCommentCountList = [];
  List<int> userPostLikesCountList = [];
  List<int> userPostCommentCountList = [];

  void likesAndCommentsCountSetUp(List<ImageModel> data) {
    userPostCommentCountList = [];
    for (final e in data) {
      userPostCommentCountList.add(e.commentCount!);
    }
    userPostLikesCountList = [];
    for (final e in data) {
      userPostLikesCountList.add(e.likeCount!);
    }
  }
}
