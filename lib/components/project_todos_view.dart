import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/services/projectServices/project_model_classes.dart';
import 'package:geek_findr/services/projectServices/projects.dart';
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
  final _controller = Get.find<AppController>();
  final scrollController = ScrollController();
  final textController = TextEditingController();
  final projectServices = ProjectServices();
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
    final textFactor = textfactorfind(MediaQuery.textScaleFactorOf(context));
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
                height: height,
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
                              Padding(
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
                                              height: 1,
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
                                      context,
                                      index2,
                                      tasks,
                                      width,
                                    ),
                                    separatorBuilder: (context, index2) =>
                                        buildDragTargets(
                                      context,
                                      index2,
                                      tasks,
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
                                              height: 1,
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
                                              print(
                                                  todos[index1].tasks!.length);
                                              Get.dialog(
                                                _buildTextFieldDialoge(
                                                  hintText: "Add task",
                                                  index: index1,
                                                  items: todos[index1].tasks!,
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

  Widget buildDraggableItems(
    BuildContext context,
    int index,
    List<String> items,
    double width,
  ) {
    return isEditing
        ? Draggable<String>(
            data: items[index],
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
                      items[index],
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
                    items[index],
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),
            child: _buildChild(
              value: items[index],
            ),
            onDragCompleted: () {
              items.remove(items[index]);
              _controller.update(["todosList"]);
            },
          )
        : _buildChild(value: items[index]);
  }

  Widget buildDragTargets(
    BuildContext context,
    int index,
    List<String> items,
  ) {
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
        items.insert(index + 1, value);
        _controller.update(["todosList"]);
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
    int index = 0,
    List<String> items = const [],
    required String hintText,
    bool isTitle = false,
  }) {
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
                        projectServices.updateProjectTodos(
                          projectId: widget.projuctDetials.id!,
                          todos: todos,
                        );
                        _controller.update(["todosList"]);
                        Get.back();
                      }
                    } else {
                      items.add(textController.text);
                      todos[index].tasks = items;
                      projectServices.updateProjectTodos(
                        projectId: widget.projuctDetials.id!,
                        todos: todos,
                      );
                      _controller.update(["todosList"]);
                      Get.back();
                      // isEditing = true;
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
}
