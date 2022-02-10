import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/services/profile.dart';
import 'package:get/get.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget>
    with TickerProviderStateMixin {
  Animation<double>? animation;
  AnimationController? animationController;
  bool isForward = false;
  final controller = Get.find<AppController>();
  final serchController = TextEditingController();
  String searchText = "";
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    final curvedAnimation = CurvedAnimation(
      parent: animationController!,
      curve: Curves.easeOutExpo,
    );
    animation = Tween<double>(begin: 0, end: 200).animate(curvedAnimation)
      ..addListener(() {
        setState(() {});
        controller.update(["search"]);
      });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SizedBox(
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 45,
              width: animation!.value * 1.634,
              decoration: const BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: TextField(
                  controller: serchController,
                  cursorColor: Colors.black,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(border: InputBorder.none),
                  onChanged: (value) async {
                    searchText = value;
                    final userList = await searchUsers(text: value);
                    print(userList.map((e) => e.username));
                  },
                ),
              ),
            ),
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: animation!.value > 1
                    ? const BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      )
                    : BorderRadius.circular(50),
              ),
              child: IconButton(
                icon: Icon(
                  !isForward ? Icons.search : Icons.close,
                  size: 20,
                  color: primaryColor,
                ),
                onPressed: () {
                  if (isForward) {
                    animationController!.reverse();
                    isForward = false;
                    SystemChannels.textInput.invokeMethod("TextInput.hide");
                    serchController.clear();
                  } else {
                    animationController!.forward();
                    isForward = true;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
