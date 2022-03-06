import 'package:flutter/material.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/models/box_instance.dart';
import 'package:geek_findr/services/authServices/auth.dart';
import 'package:geek_findr/services/postServices/posts.dart';
import 'package:geek_findr/services/profileServices/profile.dart';
import 'package:geek_findr/services/projectServices/projects.dart';
import 'package:get/get.dart';

const prodUrl = "http://www.geekfindr-dev-app.xyz";
const primaryColor = Color(0xffB954FE);
const secondaryColor = Color(0xffF3F4F7);
const primaryBlue = Color(0xffEFFFFD);
const white = Colors.white;
final black = Colors.black.withOpacity(0.8);
const admin = "admin";
const owner = "owner";
const collaborator = "collaborator";
const joinRequest = "joinRequest";
final box = Boxes.getInstance();
final controller = Get.find<AppController>();
final postServices = PostServices();
final profileServices = ProfileServices();
final authServices = AuthServices();
final myProjects = ProjectServices();

final categories = [
  {"name": "Info", 'iconPath': 'assets/icons/info.png'},
  {'name': 'Teams', 'iconPath': 'assets/icons/team.png'},
  {'name': 'Status', 'iconPath': 'assets/icons/todo-list.png'},
  {'name': 'Tasks', 'iconPath': 'assets/icons/to-do-list.png'},
];

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
