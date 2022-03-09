import 'package:flutter/material.dart';
import 'package:geek_findr/controller/auth_controller.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/database/box_instance.dart';
import 'package:geek_findr/services/auth_services.dart';
import 'package:geek_findr/services/chat_services.dart';
import 'package:geek_findr/services/post_services.dart';
import 'package:geek_findr/services/profile_services.dart';
import 'package:geek_findr/services/project_services.dart';
import 'package:get/get.dart';

const prodUrl = "http://www.geekfindr-dev-app.xyz";
const primaryColor = Color(0xffB954FE);
const secondaryColor = Color(0xffF3F4F7);
const primaryBlue = Color(0xffEFFFFD);
const white = Colors.white;
const grey = Colors.grey;
final black = Colors.black.withOpacity(0.8);
const admin = "admin";
const owner = "owner";
const collaborator = "collaborator";
const joinRequest = "joinRequest";
final controller = Get.find<AppController>();
final postController = Get.find<PostsController>();
final chatController = Get.find<ChatController>();
final authController = Get.find<AuthController>();
final box = Boxes.getInstance();
final postServices = PostServices();
final profileServices = ProfileServices();
final chatServices = ChatServices();
final authServices = AuthServices();
final projectServices = ProjectServices();
const categories = [
  {"name": "Info", 'iconPath': 'assets/icons/info.png'},
  {'name': 'Teams', 'iconPath': 'assets/icons/team.png'},
  {'name': 'Status', 'iconPath': 'assets/icons/todo-list.png'},
  {'name': 'Tasks', 'iconPath': 'assets/icons/to-do-list.png'},
];
const dropCatagories = [
  'development',
  'design',
  'testing',
  'deployment',
  'feature',
  'hotfix',
  'issue',
  'bug'
];
