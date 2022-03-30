import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geek_findr/database/box_instance.dart';
import 'package:geek_findr/models/profile_model.dart';
import 'package:geek_findr/resources/colors.dart';
import 'package:geek_findr/resources/constants.dart';
import 'package:geek_findr/resources/functions.dart';
import 'package:geek_findr/views/screens/users_profile_page.dart';
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
    final textFactor =
        textfactorCustomize(MediaQuery.textScaleFactorOf(context));
    final currentUser = Boxes.getCurrentUser();
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 45,
          alignment: Alignment.topCenter,
          width: animation!.value,
          decoration: const BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              bottomLeft: Radius.circular(50),
            ),
          ),
          child: TypeAheadField<UserDetials?>(
            getImmediateSuggestions: true,
            hideSuggestionsOnKeyboardHide: false,
            debounceDuration: const Duration(milliseconds: 500),
            textFieldConfiguration: TextFieldConfiguration(
              controller: serchController,
              cursorColor: primaryColor,
              decoration: InputDecoration(
                focusColor: primaryColor,
                iconColor: primaryColor,
                prefixIcon: const Icon(
                  Icons.search,
                  color: primaryColor,
                ),
                border: InputBorder.none,
                hintText: 'Search Username',
                hintStyle: GoogleFonts.roboto(fontSize: textFactor * 15),
              ),
            ),
            suggestionsCallback: (value) {
              if (value.isNotEmpty) {
                return profileServices.searchUsers(text: value);
              }
              return [];
            },
            itemBuilder: (context, UserDetials? suggestion) {
              final user = suggestion!;
              if (user.id != currentUser.id) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      buildCircleGravatar(
                        user.avatar!,
                        width * 0.085,
                      ),
                      SizedBox(width: width * 0.04),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.username!,
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w400,
                              fontSize: textFactor * 16,
                            ),
                          ),
                          Visibility(
                            visible: user.role!.isNotEmpty,
                            child: Text(
                              user.role!,
                              style: GoogleFonts.roboto(
                                color: grey,
                                fontWeight: FontWeight.w500,
                                fontSize: textFactor * 13,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
            noItemsFoundBuilder: (context) => const SizedBox(
              height: 50,
              child: Center(child: Text("0 Result found")),
            ),
            onSuggestionSelected: (UserDetials? user) {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              FocusScope.of(context).unfocus();
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
                FocusScope.of(context).unfocus();
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
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
    );
  }
}
