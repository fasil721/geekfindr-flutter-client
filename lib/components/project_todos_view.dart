import 'package:flutter/material.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/services/projectServices/project_model_classes.dart';
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
    "haRi",
    "heDDllo",
    "hello",
    "hai",
  ];
  List<String> nextUpList = [
    "hhnai",
    "hauyi",
    "hettllo",
    "harri",
  ];
  List<String> inProgressList = [];
  List<String> completedList = [];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textFactor = textfactorfind(MediaQuery.textScaleFactorOf(context));
    final myRole = findMyRole(widget.projuctDetials.team!);
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

          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Row(
          //     children: [
          //       ...noStatusList
          //           .map(
          //             (e) => Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: Text(e),
          //             ),
          //           )
          //           .toList()
          //     ],
          //   ),
          // ),
          // SizedBox(
          //   height: height * 0.1,
          //   child: ListView.builder(
          //     scrollDirection: Axis.horizontal,
          //     shrinkWrap: true,
          //     physics: const BouncingScrollPhysics(),
          //     itemCount: 20,
          //     itemBuilder: (context, index) {
          //       return Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Container(
          //           height: 20,
          //           width: 20,
          //           color: primaryColor,
          //         ),
          //       );
          //     },
          //   ),
          // ),
          Text(
            noStatus,
            style: GoogleFonts.poppins(
              fontSize: textFactor * 15,
              fontWeight: FontWeight.w600,
              color: black,
            ),
          ),
          SizedBox(height: height * 0.01),
          SizedBox(
            height: height * 0.06,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) =>
                  buildDraggableListItems(context, index, noStatusList),
              separatorBuilder: (context, index) =>
                  buildDragTargets(context, index, noStatusList),
              itemCount: noStatusList.length,
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
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) =>
                  buildDraggableListItems(context, index, nextUpList),
              itemCount: nextUpList.length,
              separatorBuilder: (context, index) =>
                  buildDragTargets(context, index, nextUpList),
            ),
          ),
          SizedBox(height: height * 0.01),
        ],
      ),
    );
  }

  Widget buildDraggableListItems(
    BuildContext context,
    int index,
    List<String> items,
  ) {
    return Draggable<String>(
      data: items[index],
      // the widget to show under the users finger being dragged
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
      },
    );
  }

//  builds DragTargets used as separators between list items/widgets for list A
  Widget buildDragTargets(
    BuildContext context,
    int index,
    List<String> items,
  ) {
    return DragTarget<String>(
      builder: (context, candidates, rejects) {
        // print(candidates);
        return candidates.isNotEmpty
            ? _buildDropPreview(context, candidates.first!)
            : const SizedBox(
                width: 5,
                height: 5,
              );
      },
      onWillAccept: (value) => !noStatusList.contains(value),
      onAccept: (value) {
        setState(() {
          items.insert(0, value);
        });
      },
    );
  }

  //  will return a widget used as an indicator for the drop position
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
