import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/services/profileServices/profile.dart';
import 'package:geek_findr/services/profileServices/user_profile_model.dart';
import 'package:geek_findr/services/projectServices/project_model_classes.dart';
import 'package:geek_findr/views/other_users_profile.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectTaskView extends StatefulWidget {
  const ProjectTaskView({
    Key? key,
    required this.projuctDetials,
    required this.myRole,
  }) : super(key: key);
  final ProjectDataModel projuctDetials;
  final String myRole;

  @override
  State<ProjectTaskView> createState() => _ProjectTaskViewState();
}

class _ProjectTaskViewState extends State<ProjectTaskView> {
  final profileServices = ProfileServices();
  final descTextController = TextEditingController();
  final titleTextController = TextEditingController();
  final serchController = TextEditingController();
  List<Task> tasks = [];
  double height = 0;
  double width = 0;
  double textFactor = 0;

  @override
  void initState() {
    tasks = widget.projuctDetials.task!;
    super.initState();
  }

  Future<List<UserProfileModel>> getUsersdetials(int index) async {
    final List<UserProfileModel> users = [];
    for (final element in tasks[index].users!) {
      final user = await profileServices.getUserProfilebyId(id: element);
      users.add(user!);
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    textFactor = textfactorfind(MediaQuery.textScaleFactorOf(context));

    return GetBuilder<AppController>(
      id: "taskList",
      builder: (_controller) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tasks",
                      style: GoogleFonts.poppins(
                        fontSize: textFactor * 18,
                        fontWeight: FontWeight.w600,
                        color: black,
                      ),
                    ),
                    Visibility(
                      visible: widget.myRole == owner,
                      child: Row(
                        children: [
                          Visibility(
                            visible: widget.myRole == owner ||
                                widget.myRole == admin,
                            child: IconButton(
                              splashRadius: 25,
                              onPressed: () {
                                Get.dialog(
                                  _buildAddTaskDialoge(),
                                );
                                // _controller.update(["taskList"]);
                              },
                              icon: Icon(
                                Icons.add,
                                size: 25,
                                color: black,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.62,
                child: ListView.separated(
                  itemCount: tasks.length,
                  shrinkWrap: true,
                  itemBuilder: _buildTaskTiles,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 10),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddTaskDialoge() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Material(
              color: white,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      "Assign a New Task",
                      style: GoogleFonts.roboto(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: titleTextController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        maxLines: null,
                        minLines: 1,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Title",
                          hintStyle:
                              GoogleFonts.roboto(fontSize: textFactor * 15),
                          filled: true,
                          fillColor: Colors.transparent,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: descTextController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        minLines: 1,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Description",
                          hintStyle:
                              GoogleFonts.roboto(fontSize: textFactor * 15),
                          filled: true,
                          fillColor: Colors.transparent,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TypeAheadField<Team?>(
                        direction: AxisDirection.up,
                        getImmediateSuggestions: true,
                        hideSuggestionsOnKeyboardHide: false,
                        debounceDuration: const Duration(milliseconds: 500),
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: serchController,
                          cursorColor: primaryColor,
                          decoration: InputDecoration(
                            focusColor: primaryColor,
                            iconColor: primaryColor,
                            border: InputBorder.none,
                            hintText: 'Search Username',
                            hintStyle:
                                GoogleFonts.roboto(fontSize: textFactor * 15),
                          ),
                        ),
                        suggestionsCallback: (value) {
                          final teams = widget.projuctDetials.team!;
                          
                          if (value.isNotEmpty) {
                            final results = teams
                                .where(
                                  (element) => element.user!.username!
                                      .toLowerCase()
                                      .contains(value.toLowerCase()),
                                )
                                .toList();
                            return results;
                          }
                          return teams;
                        },
                        itemBuilder: (context, Team? suggestion) {
                          final user = suggestion!.user!;
                          return ListTile(
                            textColor: secondaryColor,
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                user.avatar!,
                                width: 30,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
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
                        onSuggestionSelected: (Team? user) {
                          // ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          // Get.to(() => OtherUserProfile(userId: user!.id!));
                          print(user!.user!.username);
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.roboto(
                              color: black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        ElevatedButton(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all<double>(3),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(primaryColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (descTextController.text.isNotEmpty &&
                                titleTextController.text.isNotEmpty) {
                            } else {
                              // Get.defaultDialog(
                              //   title: "Validation",
                              //   content: const Text("Field can't be empty"),
                              //   confirmTextColor: white,
                              //   buttonColor: primaryColor,
                              //   onConfirm: () {
                              //     Get.back();
                              //   },
                              // );
                              Fluttertoast.showToast(
                                msg: "Field can't be empty",
                              );
                            }
                          },
                          child: Text(
                            "Create",
                            style: GoogleFonts.roboto(
                              color: white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5)
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      );

  Widget _buildTaskTiles(BuildContext context, int index) => Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ExpansionTile(
          textColor: black,
          iconColor: black,
          childrenPadding: const EdgeInsets.all(10),
          title: Text(
            tasks[index].title!,
            style: GoogleFonts.roboto(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tasks[index].description!,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Users : ",
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        FutureBuilder<List<UserProfileModel>>(
                          future: getUsersdetials(index),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              final datas = snapshot.data!;
                              return Column(
                                children: [
                                  ...datas.map(
                                    (e) => GestureDetector(
                                      onTap: () {
                                        Get.to(
                                          () => OtherUserProfile(userId: e.id!),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: CachedNetworkImage(
                                              imageUrl: e.avatar!,
                                              fit: BoxFit.fitWidth,
                                              width: width * 0.05,
                                            ),
                                          ),
                                          SizedBox(width: width * 0.02),
                                          Text(e.username!),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              );
                            }
                            return const SizedBox();
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: height * 0.01),
          ],
        ),
      );
}
