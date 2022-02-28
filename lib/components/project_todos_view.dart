import 'package:flutter/material.dart';
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
  List<String> noStatusList = [
    "",
    "haRi",
    "heDDllo",
    "hello",
    "hai",
    "",
  ];
  List<String> nextUpList = [
    "",
    "hhnai",
    "hauyi",
    "hettllo",
    "harri",
    "",
  ];
  final _controller = Get.find<AppController>();
  List<Todo> todos = [];
  bool isDragging = false;
  bool isEditing = false;
  ScrollController? scrollController = ScrollController();
  final projectServices = ProjectServices();
  @override
  void initState() {
    todos = widget.projuctDetials.todo!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
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
                    child: isEditing
                        ? IconButton(
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
                        : IconButton(
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
                  ),
                ],
              ),
              const Divider(thickness: 1.5),
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
                                  Padding(
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
                                        Icon(Icons.add, color: black)
                                      ],
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
              final movement = val.localPosition.dx;
              final position = scrollController!.position.pixels;
              final positionMax = scrollController!.position.maxScrollExtent;

              if ((width - 75) < movement &&
                  movement != (positionMax - 50) &&
                  position < movement) {
                final forward = position + 100;
                scrollController!.animateTo(
                  forward,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 250),
                );
              }
              // if (100 > movement && movement != 0.0) {
              //   // print(val.localPosition.dx);
              //   final move = 100 - movement;
              //   if (a > move) {
              //     a = move;
              //     scrollController!.animateTo(
              //       a * 10,
              //       curve: Curves.easeOut,
              //       duration: const Duration(milliseconds: 500),
              //     );
              //   }
              // }
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
}
