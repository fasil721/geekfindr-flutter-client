import 'package:flutter/material.dart';
import 'package:geek_findr/components/feed_list.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/services/projectServices/project_model_classes.dart';
import 'package:geek_findr/services/projectServices/projects.dart';
import 'package:geek_findr/views/project_view.dart';
import 'package:get/get.dart';

class MyProjectList extends StatefulWidget {
  const MyProjectList({Key? key}) : super(key: key);

  @override
  _MyProjectListState createState() => _MyProjectListState();
}

final myProjects = ProjectServices();

class _MyProjectListState extends State<MyProjectList> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: white,
      ),
      body: GetBuilder<AppController>(
        id: "projectList",
        builder: (controller) {
          return FutureBuilder(
            future: myProjects.getMyProjects(),
            builder:
                (context, AsyncSnapshot<List<ProjectListModel>?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return skeleton(width);
              }
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data != null) {
                  final datas = snapshot.data!;
                  return ListView.builder(
                    itemCount: datas.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(
                            () => ProjectView(
                              projectId: datas[index].project!.id!,
                            ),
                          );
                        },
                        child: Container(
                          height: 75,
                          margin: const EdgeInsets.all(10),
                          color: white,
                          child: Row(
                            children: [
                              Expanded(child: Container()),
                              Expanded(
                                child: Center(
                                  child: Text(datas[index].project!.name!),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              }
              return const SizedBox();
            },
          );
        },
      ),
    );
  }
}
