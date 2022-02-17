import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/models/user_profile_model.dart';
import 'package:geek_findr/services/profile.dart';
import 'package:geek_findr/views/other_users_profile.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
  void dispose() {
    super.dispose();
    serchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // print(animation!.value * 1.629);
    // print(335 / (width * .83));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SizedBox(
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 45,
              width: animation!.value, // * 1.629,
              //animation!.value * 1.85
              decoration:  BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                ),
                //: BorderRadius.circular(50),
              ),
              child: TypeAheadField<UserDetials?>(
                getImmediateSuggestions: true,
                hideSuggestionsOnKeyboardHide: false,
                debounceDuration: const Duration(milliseconds: 500),
                textFieldConfiguration: TextFieldConfiguration(
                  controller: serchController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    hintText: 'Search Username',
                  ),
                ),
                suggestionsCallback: (value) {
                  if (value.isNotEmpty) {
                    return searchUsers(text: value);
                  }
                  return [];
                },
                itemBuilder: (context, UserDetials? suggestion) {
                  final user = suggestion!;
                  return ListTile(
                    textColor: secondaryColor,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        user.avatar!,
                        width: 30,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.blue,
                          height: 130,
                          width: 130,
                        ),
                      ),
                    ),
                    title: Text(
                      user.username!,
                      style: GoogleFonts.roboto(color: Colors.black),
                    ),
                  );
                },
                noItemsFoundBuilder: (context) => const SizedBox(),
                onSuggestionSelected: (UserDetials? user) {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  Get.to(() => OtherUserProfile(userId: user!.id!));
                  isForward = false;
                  serchController.clear();
                  animationController!.reverse();
                },
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
                onPressed: () async {
                  if (isForward) {
                    serchController.clear();
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    SystemChannels.textInput.invokeMethod("TextInput.hide");
                    isForward = false;
                    animationController!.reverse();
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
