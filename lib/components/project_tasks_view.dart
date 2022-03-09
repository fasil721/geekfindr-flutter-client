import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/functions.dart';
import 'package:geek_findr/models/box_instance.dart';
import 'package:geek_findr/services/postServices/post_models.dart';
import 'package:geek_findr/services/profileServices/profile_model.dart';
import 'package:geek_findr/services/projectServices/project_model_classes.dart';
import 'package:geek_findr/views/users_profile_page.dart';
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
  final descTextController = TextEditingController();
  final titleTextController = TextEditingController();
  final serchController = TextEditingController(); final _currentUser = Boxes.getCurrentUser();
  List<Task> tasks = [];
  List<Team> selectedMembers = [];
  double height = 0;
  double width = 0;
  double textFactor = 0;

  @override
  void initState() {
    tasks = widget.projuctDetials.task!;
    super.initState();
  }

  Future<void> addNewTask() async {
    if (descTextController.text.isNotEmpty &&
        titleTextController.text.isNotEmpty) {
      if (selectedMembers.isNotEmpty) {
        final _task = Task();
        final _owner = Owner(id: _currentUser.id);
        _task.title = titleTextController.text;
        _task.description = descTextController.text;
        _task.isComplete = false;
        _task.assignor = _owner;
        _task.users = selectedMembers.map((e) => e.user!.id!).toList();
        await projectServices.createProjectTask(
          projectId: widget.projuctDetials.id!,
          body: _task.toJson(),
        );
        controller.update(["projectView"]);
        Get.back();
      } else {
        Fluttertoast.showToast(
          msg: "Atleast 1 user required to add new task",
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "Title and description Fields can't be empty",
      );
    }
  }

  List<Team> findMyControlMembers(String value) {
    final List<Team> teams = [];
    if (widget.myRole == admin) {
      for (final element in widget.projuctDetials.team!) {
        if (element.role == collaborator) {
          teams.add(element);
        }
      }
    } else if (widget.myRole == owner) {
      for (final element in widget.projuctDetials.team!) {
        if (element.role == collaborator || element.role == admin) {
          teams.add(element);
        }
      }
    }
    if (value.isNotEmpty) {
      final results = teams
          .where(
            (element) => element.user!.username!
                .toLowerCase()
                .contains(value.toLowerCase()),
          )
          .toList();
      return results;
    } else {
      return teams;
    }
  }

  void searchUser(Team user) {
    final isEmpty = selectedMembers
        .where(
          (element) => element.user!.id == user.user!.id,
        )
        .isEmpty;
    if (isEmpty) {
      selectedMembers.add(user);
      serchController.clear();
      controller.update(["selected"]);
    } else {
      Fluttertoast.showToast(msg: "You already added");
    }
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
    textFactor = textfactorCustomize(MediaQuery.textScaleFactorOf(context));
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
                    SizedBox(height: height * 0.05),
                    Visibility(
                      visible: widget.myRole == owner || widget.myRole == admin,
                      child: IconButton(
                        splashRadius: 25,
                        onPressed: () {
                          Get.dialog(
                            _buildAddTaskDialoge(),
                          );
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

  Widget _buildAddTaskDialoge() {
    // const  _dropValue = "Add type";
    selectedMembers = [];
    return Column(
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
                          hintText: 'Search Users',
                          hintStyle:
                              GoogleFonts.roboto(fontSize: textFactor * 15),
                        ),
                      ),
                      suggestionsCallback: (value) =>
                          findMyControlMembers(value),
                      itemBuilder: (context, Team? suggestion) {
                        final user = suggestion!.user!;
                        final userRole = suggestion.role!;
                        return ListTile(
                          textColor: secondaryColor,
                          // dense: true,
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
                          subtitle: Text(
                            userRole,
                            style: GoogleFonts.roboto(color: Colors.grey),
                          ),
                        );
                      },
                      noItemsFoundBuilder: (context) => const SizedBox(
                        height: 50,
                        child: Center(child: Text("0 Result found")),
                      ),
                      onSuggestionSelected: (Team? user) {
                        searchUser(user!);
                      },
                    ),
                  ),
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
                  GetBuilder<AppController>(
                    id: "selected",
                    builder: (_) {
                      return buildInputChips(selectedMembers);
                    },
                  ),
                  // DropdownButtonHideUnderline(
                  //   child: DropdownButton<String>(
                  //     value: _dropValue,
                  //     items: dropCatagories
                  //         .map(
                  //           (e) => DropdownMenuItem(
                  //             value: e,
                  //             child: Text(
                  //               e,
                  //               style: TextStyle(
                  //                 fontSize: textFactor * 15,
                  //                 fontWeight: FontWeight.w500,
                  //               ),
                  //             ),
                  //             onTap: () {
                  //               _dropValue = e;
                  //               setState(() {});
                  //             },
                  //           ),
                  //         )
                  //         .toList(),
                  //     onChanged: (value) {},
                  //   ),
                  // ),
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        onPressed: () {
                          addNewTask();
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
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildTaskTiles(BuildContext context, int index) {
    final assignies = tasks[index].users!.map((e) => e).toList();
    final isAssignie =
        assignies.where((element) => element == _currentUser.id!).isNotEmpty;
    return Container(
      decoration: BoxDecoration(
        color: tasks[index].isComplete!
            ? Colors.greenAccent.withOpacity(0.5)
            : white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        textColor: black,
        iconColor: black,
        childrenPadding: const EdgeInsets.all(10),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tasks[index].title!,
              style: GoogleFonts.roboto(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                Visibility(
                  visible: widget.myRole == owner ||
                      tasks[index].assignor!.id == _currentUser.id,
                  child: PopupMenuButton(
                    itemBuilder: (BuildContext bc) => [
                      PopupMenuItem(
                        value: "1",
                        child: Text(
                          "Delete Task",
                          style: GoogleFonts.poppins(
                            fontSize: textFactor * 14,
                            color: Colors.black.withOpacity(0.9),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                    onSelected: (value) async {
                      if (value == "1") {
                        projectServices.deleteTask(
                          projectId: widget.projuctDetials.id!,
                          taskTitle: tasks[index].title!,
                        );
                        tasks.remove(tasks[index]);
                        controller.update(["taskList"]);
                      }
                    },
                    icon: Icon(
                      Icons.more_horiz,
                      size: 22,
                      color: black,
                    ),
                  ),
                ),
                Visibility(
                  visible: isAssignie && !tasks[index].isComplete!,
                  child: PopupMenuButton(
                    itemBuilder: (BuildContext bc) => [
                      PopupMenuItem(
                        value: "2",
                        child: Text(
                          "Mark as Completed",
                          style: GoogleFonts.poppins(
                            fontSize: textFactor * 14,
                            color: Colors.black.withOpacity(0.9),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                    ],
                    onSelected: (value) async {
                      if (value == "2") {
                        projectServices.martTaskAsComplete(
                          projectId: widget.projuctDetials.id!,
                          taskTitle: tasks[index].title!,
                        );
                        tasks[index].isComplete = true;
                        controller.update(["taskList"]);
                      }
                    },
                    icon: Icon(
                      Icons.more_horiz,
                      size: 22,
                      color: black,
                    ),
                  ),
                ),
                Visibility(
                  visible: tasks[index].isComplete!,
                  child: Text(
                    "Completed",
                    style: GoogleFonts.recursive(
                      fontSize: textFactor * 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        children: [
          buildTileChild(index),
          SizedBox(height: height * 0.01),
        ],
      ),
    );
  }

  Widget buildTileChild(int index) => Align(
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
              FutureBuilder<List<UserProfileModel>>(
                future: getUsersdetials(index),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final datas = snapshot.data!;
                    return Wrap(
                      spacing: 5,
                      children: [
                        ...datas.map(
                          (e) => InputChip(
                            deleteIcon: const SizedBox(),
                            avatar: CircleAvatar(
                              backgroundImage: NetworkImage(e.avatar!),
                            ),
                            label: Text(e.username!),
                            labelStyle: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Get.to(
                                () => OtherUserProfile(userId: e.id!),
                              );
                            },
                          ),
                        )
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      );

  Widget buildInputChips(List<Team> members) => Wrap(
        spacing: 10,
        children: members
            .map(
              (e) => InputChip(
                avatar: CircleAvatar(
                  backgroundImage: NetworkImage(e.user!.avatar!),
                ),
                label: Text(e.user!.username!),
                labelStyle: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                onDeleted: () {
                  selectedMembers.remove(e);
                  controller.update(["selected"]);
                },
              ),
            )
            .toList(),
      );
}
