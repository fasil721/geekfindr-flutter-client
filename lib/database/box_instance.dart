// ignore_for_file: avoid_classes_with_only_static_members

import 'package:geek_findr/database/chat_model.dart';
import 'package:geek_findr/database/user_model.dart';
import 'package:hive/hive.dart';

class Boxes {
  static final box = Hive.box<UserModel>('usermodel');
  static Box<UserModel> getInstance() => box;
  static UserModel getCurrentUser() => box.get("user")!;
}

class BoxChat {
  static final box = Hive.box('chatmodel');
  static Box getInstance() => box;
  static List<MyChatList> getMyChatDBdatas() {
    final List<MyChatList> chats = [];
    final values = box.get('chats');
    for (final item in values!) {
      chats.add(item as MyChatList);
    }
    return chats;
  }
}
