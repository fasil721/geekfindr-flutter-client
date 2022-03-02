import 'package:flutter/cupertino.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/services/projectServices/project_model_classes.dart';
import 'package:get/get.dart';

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
  @override
  Widget build(BuildContext context) {
    //  final width = MediaQuery.of(context).size.width;
    //   final height = MediaQuery.of(context).size.height;
    //   final textFactor = textfactorfind(MediaQuery.textScaleFactorOf(context));
    return GetBuilder<AppController>(
      id: "taskList",
      builder: (_controller) {
        return Container();
      },
    );
  }
}
