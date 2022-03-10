import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  int currentIndex = 0;
  TabController? tabController;
  
  void updateTabIndex(int index) {
    tabController!.animateTo(index);
    currentIndex = index;
    update(["tabs"]);
  }
}
