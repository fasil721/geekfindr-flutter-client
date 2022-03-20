// ignore_for_file: avoid_classes_with_only_static_members

import 'package:geek_findr/database/chat_model.dart';
import 'package:geek_findr/database/user_model.dart';
import 'package:hive/hive.dart';

class Boxes {
  static final _box = Hive.box<UserModel>('usermodel');
  static Box<UserModel> getInstance() => _box;
  static UserModel getCurrentUser() => _box.get("user")!;
}

class BoxChat {
  static final _box = Hive.box<MyChatList>('chatmodel');
  static Box<MyChatList> getInstance() => _box;
  static List<MyChatList> getMyChats() => _box.values.toList();
}
