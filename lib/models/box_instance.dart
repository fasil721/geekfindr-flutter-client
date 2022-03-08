// ignore_for_file: avoid_classes_with_only_static_members

import 'package:geek_findr/models/user_model.dart';
import 'package:hive/hive.dart';

class Boxes {

  static Box<UserModel> getInstance() {
    final box = Hive.box<UserModel>('usermodel');
    return box;
  }

  static UserModel getCurrentUser() {
    final box = Hive.box<UserModel>('usermodel');
    final userModel = box.get("user")!;
    return userModel;
  }
}
