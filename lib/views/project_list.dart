import 'package:flutter/material.dart';
import 'package:geek_findr/components/feed_list_view.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/services/projectServices/project_model_classes.dart';
import 'package:geek_findr/services/projectServices/projects.dart';
import 'package:geek_findr/views/project_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MyProjectList extends StatefulWidget {
  const MyProjectList({Key? key}) : super(key: key);

  @override
  _MyProjectListState createState() => _MyProjectListState();
}

class _MyProjectListState extends State<MyProjectList> {
  final myProjects = ProjectServices();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textFactor = textfactorfind(MediaQuery.textScaleFactorOf(context));
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
                (context, AsyncSnapshot<List<ProjectShortModel>?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return skeleton(width);
              }
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data != null) {
                  final datas = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListView.separated(
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
                            height: height * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: white,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    child: Image.asset(
                                      "assets/images/Hand coding-bro.png",
                                      width: width,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          datas[index].project!.name!,
                                          style: GoogleFonts.poppins(
                                            fontSize: textFactor * 16,
                                            color:
                                                Colors.black.withOpacity(0.9),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: height * 0.005),
                                        Text(
                                          datas[index].project!.description!,
                                          maxLines: 3,
                                          style: GoogleFonts.poppins(
                                            fontSize: textFactor * 13,
                                            color:
                                                Colors.black.withOpacity(0.9),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: 10),
                    ),
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
