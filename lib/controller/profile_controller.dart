import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  int currentIndextab1 = 0;
  int currentIndextab2 = 0;
  TabController? tabController1;
  TabController? tabController2;
  void updateTabIndex(int index) {
    tabController1!.animateTo(index);
    currentIndextab1 = index;
    update(["tabs"]);
  }

  void updateTab2Index(int index) {
    tabController2!.animateTo(index);
    currentIndextab2 = index;
    update(["tabs2"]);
  }
}
