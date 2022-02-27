import 'package:flutter/material.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/services/projectServices/project_model_classes.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class ProjectTodosView extends StatefulWidget {
  const ProjectTodosView({Key? key, required this.projuctDetials})
      : super(key: key);
  final ProjuctDetialsModel projuctDetials;

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
  final controller = Get.find<AppController>();
  List<String> inProgressList = [];
  List<String> completedList = [];
  bool isDragging = false;

  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textFactor = textfactorfind(MediaQuery.textScaleFactorOf(context));
    // final myRole = findMyRole(widget.projuctDetials.team!);
    final todos = widget.projuctDetials.todo!;
    print(todos);
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Status",
            style: GoogleFonts.poppins(
              fontSize: textFactor * 18,
              fontWeight: FontWeight.w600,
              color: black,
            ),
          ),
          const Divider(thickness: 1.5),
          Text(
            noStatus,
            style: GoogleFonts.poppins(
              fontSize: textFactor * 15,
              fontWeight: FontWeight.w600,
              color: black,
            ),
          ),
          SizedBox(height: height * 0.01),
          GetBuilder<AppController>(
            id: "todosList",
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height * 0.06,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Visibility(
                            visible: isDragging,
                            child: buildListDragTarget(noStatusList),
                          ),
                          ListView.separated(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) =>
                                buildDraggableItems(
                              context,
                              index,
                              noStatusList,
                            ),
                            separatorBuilder: (context, index) =>
                                buildDragTargets(
                              context,
                              index,
                              noStatusList,
                            ), // const SizedBox(width: 5),
                            itemCount: noStatusList.length,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Text(
                    nextUp,
                    style: GoogleFonts.poppins(
                      fontSize: textFactor * 15,
                      fontWeight: FontWeight.w600,
                      color: black,
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  SizedBox(
                    height: height * 0.06,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Visibility(
                            visible: isDragging,
                            child: buildListDragTarget(nextUpList),
                          ),
                          ListView.separated(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) =>
                                buildDraggableItems(
                              context,
                              index,
                              nextUpList,
                            ),
                            separatorBuilder: (context, index) =>
                                buildDragTargets(
                              context,
                              index,
                              nextUpList,
                            ), //  const SizedBox(width: 5),
                            itemCount: nextUpList.length,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: height * 0.01),
        ],
      ),
    );
  }

  Widget buildListDragTarget(List<String> items) => DragTarget<String>(
        builder: (context, candidates, rejects) {
          return candidates.isNotEmpty
              ? _buildDropPreview(
                  context,
                  candidates.first!,
                )
              : const Card(
                  color: white,
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(Icons.add),
                  ),
                );
        },
        onWillAccept: (value) => !items.contains(value),
        onAccept: (value) {
          items.insert(0, value);
          controller.update(["todosList"]);
        },
      );

  Widget buildDraggableItems(
    BuildContext context,
    int index,
    List<String> items,
  ) {
    return items[index].isNotEmpty
        ? Draggable<String>(
            data: items[index],
            feedback: Card(
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
            child: Card(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    items[index],
                    style: GoogleFonts.roboto(fontSize: 15),
                  ),
                ),
              ),
            ),
            onDragCompleted: () {
              items.remove(items[index]);
              controller.update(["todosList"]);
            },
            // onDragStarted: () {
            //   isDragging = true;
            //   controller.update(["todosList"]);
            // },
            // onDragEnd: (value) {
            //   isDragging = false;
            //   controller.update(["todosList"]);
            // },
          )
        : const SizedBox();
  }

  Widget buildDragTargets(
    BuildContext context,
    int index,
    List<String> items,
  ) {
    return DragTarget<String>(
      builder: (context, candidates, rejects) {
        return candidates.isNotEmpty
            ? _buildDropPreview(context, candidates.first!)
            : const SizedBox(
                width: 5,
                height: 5,
              );
      },
      // onWillAccept: (value) => !items.contains(value),
      onAccept: (value) {
        items.insert(index + 1, value);
        controller.update(["todosList"]);
      },
    );
  }

  Widget _buildDropPreview(BuildContext context, String value) {
    return Card(
      color: Colors.lightBlue[200],
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
