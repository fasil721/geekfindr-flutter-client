import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geek_findr/database/box_instance.dart';
import 'package:geek_findr/database/chat_model.dart';
import 'package:geek_findr/database/participant_model.dart';
import 'package:geek_findr/models/post_models.dart';
import 'package:geek_findr/resources/colors.dart';
import 'package:geek_findr/resources/constants.dart';
import 'package:geek_findr/views/components/users_list_bottomsheet.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shimmer/shimmer.dart';

bool checkRequest(List<Join> requests) {
  final currentUser = Boxes.getCurrentUser();
  return requests
      .where((element) => element.owner == currentUser.id)
      .isNotEmpty;
}

double textfactorCustomize(double val) {
  if (val == 0.85) {
    return val + 0.1;
  } else if (val == 1.00) {
    return val;
  } else if (val == 1.15) {
    return val - 0.2;
  } else if (val == 1.3) {
    return val - 0.4;
  } else if (val == 1.45) {
    return val - 0.6;
  } else if (val == 1.6) {
    return val - 0.8;
  } else {
    return val;
  }
}

String findDatesDifferenceFromToday(DateTime dateTime) {
  final today = DateTime.now();
  final diff = dateTime.difference(today);
  if (diff.inMinutes > -1) {
    return "${diff.inSeconds * -1} seconds ago";
  } else if (diff.inHours > -1) {
    return "${diff.inMinutes * -1} minutes ago";
  } else if (diff.inDays > -1) {
    return "${diff.inHours * -1} hours ago";
  } else if (diff.inDays < -7) {
    return DateFormat.MMMd().format(dateTime);
  } else {
    return "${diff.inDays * -1} days ago";
  }
}

Participant findMy1to1chatUser(MyChatList data) {
  final currentUser = Boxes.getCurrentUser();
  final user =
      data.participants!.firstWhere((element) => element.id != currentUser.id);
  return user;
}

Widget buildCircleGravatar(String avatar, double width) => ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: CachedNetworkImage(
        imageUrl: avatar,
        fit: BoxFit.fitWidth,
        width: width,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey.withOpacity(0.3),
          highlightColor: white,
          period: const Duration(
            milliseconds: 1000,
          ),
          child: Container(
            height: width,
            width: width,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
      ),
    );

Widget loadingIndicator() => const Center(
      child: SizedBox(
        height: 50,
        child: LoadingIndicator(
          indicatorType: Indicator.ballPulse,
          colors: [
            Colors.red,
            Colors.redAccent,
            Colors.orange,
          ],
          strokeWidth: 2,
          backgroundColor: Colors.transparent,
          pathBackgroundColor: Colors.transparent,
        ),
      ),
    );

Future<void> buildLikedUsersBottomSheet(String imageId) async {
  Get.dialog(loadingIndicator());
  final data = await postServices.getLikedUsers(
    imageId: imageId,
  );
  final userList = data!.map((e) => e.owner!).toList();
  Get.back();
  Get.bottomSheet(UsersListView(userList: userList));
}

Owner getUserDatAsOwnerModel() {
  final currentUser = Boxes.getCurrentUser();
  final _owner = Owner();
  _owner.avatar = currentUser.avatar;
  _owner.id = currentUser.id;
  _owner.username = currentUser.username;
  return _owner;
}

Future<void> logoutUser() async {
  final box = Boxes.getInstance();
  final _chatBox = BoxChat.getInstance();
  await _chatBox.clear();
  await box.delete("user");
  chatController.myChatList = [];
  chatController.socket.disconnect();
  await Future.delayed(const Duration(milliseconds: 500));
  SystemNavigator.pop(animated: true);
}
