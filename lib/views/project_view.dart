import 'package:flutter/material.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/services/projectServices/project_model_classes.dart';
import 'package:geek_findr/services/projectServices/projects.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectView extends StatefulWidget {
  const ProjectView({Key? key, required this.projectId}) : super(key: key);
  final String projectId;
  @override
  State<ProjectView> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectView> {
  int _currentIndex = 0;

  final myProjects = ProjectServices();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textFactor = textfactorfind(MediaQuery.textScaleFactorOf(context));

    return FutureBuilder<ProjuctDetialsModel?>(
      future: myProjects.getProjectDetialsById(id: widget.projectId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            final projectDetials = snapshot.data!;
            final date =
                findDatesDifferenceFromToday(projectDetials.createdAt!);
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () async {},
              ),
              backgroundColor: secondaryColor,
              appBar: AppBar(
                leading: IconButton(
                  splashRadius: 25,
                  icon: ImageIcon(
                    const AssetImage("assets/icons/left.png"),
                    color: black,
                    size: 25,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
                elevation: 0,
                backgroundColor: white,
              ),
              body: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: height * 0.02),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      projectDetials.name!,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: black,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.005),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Started $date",
                      style: GoogleFonts.roboto(
                        fontSize: textFactor * 12,
                        fontWeight: FontWeight.w500,
                        color: black.withOpacity(0.6),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.025),
                  GetBuilder<AppController>(
                    id: "projtabs",
                    builder: (controller) {
                      return Column(
                        children: [
                          DefaultTabController(
                            // initialIndex: 0,
                            length: categories.length,
                            child: TabBar(
                              // isScrollable: true,
                              indicatorColor: Colors.blue,
                              physics: const BouncingScrollPhysics(),
                              indicatorWeight: .0001,
                              onTap: (index) {
                                _currentIndex = index;
                                controller.update(["projtabs"]);
                              },
                              tabs: [
                                ...categories.map(
                                  (element) => Container(
                                    width: width * 0.2,
                                    height: height * 0.085,
                                    // margin: const EdgeInsets.symmetric(vertical: 5),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          categories[_currentIndex] == element
                                              ? primaryColor
                                              : white,
                                      // boxShadow: shadowList,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Tab(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            element["iconPath"] as String,
                                            height: 30,
                                            width: 30,
                                            color: categories[_currentIndex] ==
                                                    element
                                                ? white
                                                : Colors.grey[700],
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 3),
                                            child: Text(
                                              element['name'] as String,
                                              style: GoogleFonts.poppins(
                                                color:
                                                    categories[_currentIndex] ==
                                                            element
                                                        ? white
                                                        : Colors.grey[700],
                                                fontWeight: FontWeight.w500,
                                                fontSize: textFactor * 11,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IndexedStack(
                            index: _currentIndex,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(20),
                                width: width,
                                child: Column(
                                  children: [
                                    SizedBox(height: height * 0.005),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        projectDetials.name!,
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: black,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: height * 0.01),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        projectDetials.description!,
                                        style: GoogleFonts.roboto(
                                          fontSize: textFactor * 15,
                                          fontWeight: FontWeight.w500,
                                          color: black.withOpacity(0.6),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: height * 0.025),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(20),
                                color: black,
                                width: width,
                                height: 200,
                              ),
                              Container(
                                margin: const EdgeInsets.all(20),
                                color: primaryColor,
                                width: width,
                                height: 200,
                              ),
                              Container(
                                margin: const EdgeInsets.all(20),
                                color: black,
                                width: width,
                                height: 200,
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
          }
        }
        return const SizedBox();
      },
    );
  }
}
