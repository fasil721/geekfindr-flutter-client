import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/functions.dart';
import 'package:geek_findr/services/projectServices/project_model_classes.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectTodosView extends StatefulWidget {
  const ProjectTodosView({
    Key? key,
    required this.projuctDetials,
    required this.myRole,
  }) : super(key: key);
  final ProjectDataModel projuctDetials;
  final String myRole;

  @override
  State<ProjectTodosView> createState() => _ProjectTodosViewState();
}

class _ProjectTodosViewState extends State<ProjectTodosView> {
  final scrollController = ScrollController();
  List<Todo> todos = [];
  bool isDragging = false;
  bool isEditing = false;
  double width = 0.0;

  @override
  void initState() {
    todos = widget.projuctDetials.todo!;
    super.initState();
  }

  void autoScroll(DragUpdateDetails val) {
    final movement = val.localPosition.dx;
    final position = scrollController.position.pixels;
    // final positionMax = scrollController!.position.maxScrollExtent;
    if ((width - 75) < movement && position < movement) {
      final forward = position + 150;
      scrollController.animateTo(
        forward,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 250),
      );
    }
    if (75 > movement && position > movement) {
      final backward = position - 150;
      scrollController.animateTo(
        backward,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 250),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textFactor =
        textfactorCustomize(MediaQuery.textScaleFactorOf(context));
    return GetBuilder<AppController>(
      id: "todosList",
      builder: (_controller) {
        return Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Status",
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
                          visible: isEditing,
                          child: IconButton(
                            splashRadius: 25,
                            onPressed: () {
                              Get.dialog(
                                _buildTextFieldDialoge(
                                  hintText: "Add title",
                                  isTitle: true,
                                ),
                              );
                              // _controller.update(["todosList"]);
                            },
                            icon: Icon(
                              Icons.add,
                              size: 25,
                              color: black,
                            ),
                          ),
                        ),
                        if (isEditing)
                          IconButton(
                            splashRadius: 25,
                            onPressed: () {
                              isEditing = false;
                              _controller.update(["todosList"]);
                              projectServices.updateProjectTodos(
                                projectId: widget.projuctDetials.id!,
                                todos: todos,
                              );
                            },
                            icon: const Icon(
                              Icons.check,
                              size: 22,
                              color: primaryColor,
                            ),
                          )
                        else
                          IconButton(
                            splashRadius: 25,
                            onPressed: () {
                              isEditing = true;
                              _controller.update(["todosList"]);
                            },
                            icon: Icon(
                              Icons.edit,
                              size: 22,
                              color: black.withOpacity(0.6),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: todos.length < 3,
                child: const Divider(thickness: 1.5),
              ),
              SizedBox(
                height: 500,
                child: Scrollbar(
                  scrollbarOrientation: ScrollbarOrientation.top,
                  showTrackOnHover: true,
                  controller: scrollController,
                  isAlwaysShown: true,
                  child: ScrollConfiguration(
                    behavior:
                        const ScrollBehavior().copyWith(overscroll: false),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 10),
                      controller: scrollController,
                      itemCount: todos.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index1) {
                        final tasks = todos[index1].tasks!;
                        return Container(
                          alignment: Alignment.topCenter,
                          width: width * 0.4,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (isEditing) {
                                    Get.dialog(
                                      _buildEditDeleteDialoge(
                                        title: "Edit title",
                                        isTitle: true,
                                        index1: index1,
                                        text: todos[index1].title!,
                                      ),
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    todos[index1].title!,
                                    style: GoogleFonts.roboto(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: black,
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  DragTarget<String>(
                                    builder: (context, candidates, rejects) {
                                      return candidates.isNotEmpty
                                          ? _buildChild(
                                              value: candidates.first!,
                                              color: Colors.lightBlue[200]!,
                                            )
                                          : SizedBox(
                                              width: width * 0.4,
                                              height: 5,
                                            );
                                    },
                                    // onWillAccept: (value) =>
                                    //     !tasks[index1].contains(value!),
                                    onAccept: (value) {
                                      todos[index1].tasks!.insert(0, value);
                                      _controller.update(["todosList"]);
                                    },
                                  ),
                                  SizedBox(
                                    height: height * 0.005,
                                  ),
                                  ListView.separated(
                                    itemCount: tasks.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index2) =>
                                        buildDraggableItems(
                                      context: context,
                                      index2: index2,
                                      index1: index1,
                                      items: tasks,
                                      width: width,
                                    ),
                                    separatorBuilder: (context, index2) =>
                                        buildDragTargets(
                                      context: context,
                                      index2: index2,
                                      items: tasks,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.005,
                                  ),
                                  DragTarget<String>(
                                    builder: (context, candidates, rejects) {
                                      return candidates.isNotEmpty
                                          ? _buildChild(
                                              value: candidates.first!,
                                              color: Colors.lightBlue[200]!,
                                            )
                                          : SizedBox(
                                              width: width * 0.4,
                                              height: 5,
                                            );
                                    },
                                    onAccept: (value) {
                                      todos[index1].tasks!.insert(
                                            todos[index1].tasks!.length,
                                            value,
                                          );
                                      _controller.update(["todosList"]);
                                    },
                                  ),
                                  Visibility(
                                    visible: isEditing,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "New",
                                            style: GoogleFonts.roboto(),
                                          ),
                                          SizedBox(width: width * 0.01),
                                          IconButton(
                                            splashRadius: 25,
                                            onPressed: () {
                                              Get.dialog(
                                                _buildTextFieldDialoge(
                                                  hintText: "Add task",
                                                  index1: index1,
                                                  items: todos[index1].tasks!,
                                                  isTask: true,
                                                ),
                                              );
                                            },
                                            icon: Icon(
                                              Icons.add,
                                              color: black,
                                              size: 20,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildDraggableItems({
    required BuildContext context,
    required int index2,
    required int index1,
    required List<String> items,
    required double width,
  }) {
    return isEditing
        ? GestureDetector(
            onTap: () {
              Get.dialog(
                _buildEditDeleteDialoge(
                  title: "Edit task",
                  isTitle: false,
                  index1: index1,
                  text: items[index2],
                  index2: index2,
                  items: items,
                ),
              );
            },
            child: Draggable<String>(
              // affinity: Axis.horizontal,
              data: items[index2],
              onDragUpdate: (val) {
                autoScroll(val);
              },
              feedback: Card(
                child: SizedBox(
                  width: width * 0.38,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        items[index2],
                        style: GoogleFonts.roboto(fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ),
              childWhenDragging: Card(
                color: Colors.transparent,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      items[index2],
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ),
              child: _buildChild(
                value: items[index2],
              ),
              onDragCompleted: () {
                items.remove(items[index2]);
                controller.update(["todosList"]);
              },
            ),
          )
        : _buildChild(value: items[index2]);
  }

  Widget buildDragTargets({
    required BuildContext context,
    required int index2,
    required List<String> items,
  }) {
    return DragTarget<String>(
      builder: (context, candidates, rejects) {
        return candidates.isNotEmpty
            ? _buildChild(
                value: candidates.first!,
                color: Colors.lightBlue[200]!,
              )
            : const SizedBox(
                width: 5,
                height: 5,
              );
      },
      // onWillAccept: (value) => !items.contains(value),
      onAccept: (value) {
        items.insert(index2 + 1, value);
        controller.update(["todosList"]);
      },
    );
  }

  Widget _buildChild({required String value, Color color = Colors.white}) {
    return Card(
      color: color,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Text(
            value,
            style: GoogleFonts.roboto(fontSize: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldDialoge({
    required String hintText,
    bool isTitle = false,
    bool isTask = false,
    int index1 = 0,
    List<String> items = const [],
    bool isTitleEdit = false,
    String text = "",
    bool isTaskEdit = false,
    int index2 = 0,
  }) {
    final textController = TextEditingController(text: text);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: width * 0.8,
          child: Material(
            borderRadius: BorderRadius.circular(
              20,
            ),
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(
                    10.0,
                  ),
                  child: TextField(
                    controller: textController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    minLines: 1,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hintText,
                      filled: true,
                      fillColor: white,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(3),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(primaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    await SystemChannels.textInput
                        .invokeMethod("TextInput.hide");
                    if (isTitle) {
                      if (textController.text.isNotEmpty) {
                        final _todo = Todo();
                        _todo.title = textController.text;
                        _todo.tasks = [];
                        todos.add(_todo);
                        await projectServices.updateProjectTodos(
                          projectId: widget.projuctDetials.id!,
                          todos: todos,
                        );
                        controller.update(["todosList"]);
                        Get.back();
                      } else {
                        Fluttertoast.showToast(msg: "Field can't be empty");
                      }
                    } else if (isTask) {
                      if (textController.text.isNotEmpty) {
                        items.add(textController.text);
                        todos[index1].tasks = items;
                        await projectServices.updateProjectTodos(
                          projectId: widget.projuctDetials.id!,
                          todos: todos,
                        );
                        controller.update(["todosList"]);
                        Get.back();
                      } else {
                        Fluttertoast.showToast(msg: "Field can't be empty");
                      }
                      // isEditing = true;
                    } else if (isTitleEdit) {
                      if (textController.text.isNotEmpty) {
                        todos[index1].title = textController.text;
                        await projectServices.updateProjectTodos(
                          projectId: widget.projuctDetials.id!,
                          todos: todos,
                        );
                        controller.update(["todosList"]);
                        Get.back();
                      } else {
                        Fluttertoast.showToast(msg: "Field can't be empty");
                      }
                    } else if (isTaskEdit) {
                      if (textController.text.isNotEmpty) {
                        // print(todos[index1].tasks![index2]);
                        todos[index1].tasks![index2] = textController.text;
                        await projectServices.updateProjectTodos(
                          projectId: widget.projuctDetials.id!,
                          todos: todos,
                        );
                        controller.update(["todosList"]);
                        Get.back();
                      } else {
                        Fluttertoast.showToast(msg: "Field can't be empty");
                      }
                    }
                  },
                  child: const Text("Save"),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditDeleteDialoge({
    required bool isTitle,
    required int index1,
    required String text,
    required String title,
    int index2 = 0,
    List<String> items = const [],
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            child: Column(
              children: [
                ListTile(
                  dense: true,
                  onTap: () {
                    Get.back();
                    if (isTitle) {
                      Get.dialog(
                        _buildTextFieldDialoge(
                          hintText: "Edit title",
                          text: text,
                          isTitleEdit: true,
                          index1: index1,
                        ),
                      );
                    } else {
                      Get.dialog(
                        _buildTextFieldDialoge(
                          hintText: "Edit task",
                          text: text,
                          isTaskEdit: true,
                          index1: index1,
                          index2: index2,
                          items: items,
                        ),
                      );
                    }
                  },
                  leading: const Icon(Icons.edit),
                  title: Text(title),
                ),
                ListTile(
                  dense: true,
                  onTap: () {
                    if (isTitle) {
                      todos.removeAt(index1);
                    } else {
                      todos[index1].tasks!.removeAt(index2);
                    }
                    controller.update(["todosList"]);
                    Get.back();
                  },
                  leading: const Icon(Icons.delete),
                  title: const Text("Delete Tast"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
