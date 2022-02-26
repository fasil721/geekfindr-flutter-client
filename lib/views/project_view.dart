import 'package:flutter/material.dart';
import 'package:geek_findr/components/edit_description_dialoge.dart';
import 'package:geek_findr/components/project_team_view.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/services/postServices/post_models.dart';
import 'package:geek_findr/services/projectServices/project_model_classes.dart';
import 'package:geek_findr/services/projectServices/projects.dart';
import 'package:geek_findr/views/other_users_profile.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class ProjectView extends StatelessWidget {
  ProjectView({
    Key? key,
    required this.projectId,
  }) : super(key: key);

  final String projectId;
  final myProjects = ProjectServices();
  int _currentIndex = 0;
  double width = 0;
  double height = 0;
  double textFactor = 0;
  int membersCount = 0;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    textFactor = textfactorfind(MediaQuery.textScaleFactorOf(context));
    return GetBuilder<AppController>(
      id: "projectView",
      builder: (controller) {
        return FutureBuilder<ProjuctDetialsModel?>(
          future: myProjects.getProjectDetialsById(id: projectId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold();
            }
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data != null) {
                final projectDetials = snapshot.data!;
                final date =
                    findDatesDifferenceFromToday(projectDetials.createdAt!);

                final myRole = findMyRole(projectDetials.team!);
                return Scaffold(
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      controller.update(["projectView"]);
                      // for (final e in projectDetials.team!) {
                      //   print(e.user!.username);
                      //   print(e.role);
                      // }
                    },
                  ),
                  backgroundColor: secondaryColor,
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: white,
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
                    actions: [
                      Visibility(
                        visible: myRole == owner,
                        child: PopupMenuButton(
                          itemBuilder: (BuildContext bc) => [
                            PopupMenuItem(
                              value: "1",
                              child: Text(
                                "Delete Project",
                                style: GoogleFonts.poppins(
                                  fontSize: textFactor * 15,
                                  color: Colors.black.withOpacity(0.9),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          ],
                          onSelected: (value) async {
                            if (value == "1") {
                              await myProjects.deleteProject(
                                projectId: projectId,
                                projectName: projectDetials.name!,
                              );
                              controller.update(["projectList"]);
                              Get.back();
                            }
                          },
                          icon: Icon(
                            Icons.more_vert,
                            color: black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  body: SingleChildScrollView(
                    child: Column(
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
                                          width: width * 0.3,
                                          height: height * 0.085,
                                          // margin: const EdgeInsets.symmetric(vertical: 5),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: categories[_currentIndex] ==
                                                    element
                                                ? primaryColor
                                                : white,
                                            // boxShadow: shadowList,
                                            borderRadius:
                                                BorderRadius.circular(20),
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
                                                  color: categories[
                                                              _currentIndex] ==
                                                          element
                                                      ? white
                                                      : Colors.grey[700],
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                    top: 3,
                                                  ),
                                                  child: Text(
                                                    element['name'] as String,
                                                    style: GoogleFonts.poppins(
                                                      color: categories[
                                                                  _currentIndex] ==
                                                              element
                                                          ? white
                                                          : Colors.grey[700],
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                    projectInfo(
                                      ownerData: projectDetials.owner!,
                                      myRole: myRole,
                                      description: projectDetials.description!,
                                      name: projectDetials.name!,
                                      projectId: projectDetials.id!,
                                    ),
                                    ProjectTeamView(
                                      projuctDetials: projectDetials,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(20),
                                      color: primaryColor,
                                      width: width,
                                      height: 20,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(20),
                                      color: black,
                                      width: width,
                                      height: 2,
                                    ),
                                  ],
                                )
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
            return const SizedBox();
          },
        );
      },
    );
  }

  Widget projectInfo({
    required String name,
    required String description,
    required String projectId,
    required String myRole,
    required Owner ownerData,
  }) =>
      Container(
        margin: const EdgeInsets.all(20),
        width: width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: height * 0.005),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: black,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: myRole == admin || myRole == owner,
                    child: PopupMenuButton(
                      itemBuilder: (BuildContext bc) => [
                        PopupMenuItem(
                          value: "1",
                          child: Text(
                            description.isEmpty
                                ? "Add Description"
                                : "Edit Description",
                            style: GoogleFonts.poppins(
                              fontSize: textFactor * 15,
                              color: Colors.black.withOpacity(0.9),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                      onSelected: (value) {
                        if (value == "1") {
                          Get.dialog(
                            EditDescriptionDialoge(
                              description: description,
                              projectId: projectId,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "owner name  :  ",
                    style: GoogleFonts.poppins(
                      fontSize: textFactor * 14,
                      fontWeight: FontWeight.w500,
                      color: black.withOpacity(0.6),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(
                        () => OtherUserProfile(
                          userId: ownerData.id!,
                        ),
                      );
                    },
                    child: Text(
                      ownerData.username!,
                      style: GoogleFonts.poppins(
                        fontSize: textFactor * 14,
                        fontWeight: FontWeight.w500,
                        color: black.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.01),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: textFactor * 14,
                    fontWeight: FontWeight.w500,
                    color: black.withOpacity(0.6),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
