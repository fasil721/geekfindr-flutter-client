import 'package:flutter/material.dart';
import 'package:geek_findr/models/box_instance.dart';
import 'package:geek_findr/services/postServices/post_models.dart';

const prodUrl = "http://www.geekfindr-dev-app.xyz";
const primaryColor = Color(0xffB954FE);
const secondaryColor = Color(0xffF3F4F7);
const primaryBlue = Color(0xffEFFFFD );
const white = Colors.white;
final black = Colors.black.withOpacity(0.8);
const admin = "admin";
const owner = "owner";
const collaborator = "collaborator";
const joinRequest = "joinRequest";
const noStatus = "No Status";
const nextUp = "Next Up";
const inProgress = "In Progress";
const completed = "Completed";
final box = Boxes.getInstance();

double textfactorfind(double val) {
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

List<Map> categories = [
  {"name": "Info", 'iconPath': 'assets/icons/info.png'},
  {'name': 'Teams', 'iconPath': 'assets/icons/team.png'},
  {'name': 'Status', 'iconPath': 'assets/icons/todo-list.png'},
  {'name': 'Tasks', 'iconPath': 'assets/icons/to-do-list.png'},
];

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
    return "${dateTime.day}-${dateTime.month}-${dateTime.year}";
  } else {
    return "${diff.inDays * -1} days ago";
  }
}

final dropCatagories = [
  'development',
  'design',
  'testing',
  'deployment',
  'feature',
  'hotfix',
  'issue',
  'bug'
];
bool checkRequest(List<Join> requests) {
  final currentUser = box.get("user");
  return requests
      .where((element) => element.owner == currentUser!.id)
      .isNotEmpty;
}
