import 'package:geek_findr/models/user_model.dart';
import 'package:hive/hive.dart';

// ignore: avoid_classes_with_only_static_members
class Boxes {
  static Box<UserModel>? box;
  static Box<UserModel> getInstance() =>
      box ??= Hive.box<UserModel>('usermodel');
}
