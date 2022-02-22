import 'package:flutter/material.dart';
import 'package:geek_findr/contants.dart';
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

String findDatesDifferenceFromToday(DateTime dateTime) {
  final today = DateTime.now();
  final diff = dateTime.difference(today);
  if (diff.inDays > -1) {
    return "${diff.inHours * -1} hours ago";
  } else if (diff.inDays < -7) {
    return "${dateTime.day}-${dateTime.month}-${dateTime.year}";
  } else {
    return "${diff.inDays * -1} days ago";
  }
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
          return Scaffold();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          // if(){}
          // final projectDetials=snapshot.data!;
          //  final b = findDatesDifferenceFromToday(a.createdAt!);
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final a = await myProjects.getProjectDetialsById(
                  id: widget.projectId,
                );
                if (a != null) {
                  final b = findDatesDifferenceFromToday(a.createdAt!);
                  print(b);
                }

                //final today = DateTime.now();
                // print(
                //   "Created at ${a!.createdAt!.difference(today).inDays * -1} days ago",
                // );
              },
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
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [Text()
                  DefaultTabController(
                    // initialIndex: 0,
                    length: categories.length,
                    child: TabBar(
                      // isScrollable: true,
                      indicatorColor: Colors.blue,
                      physics: const BouncingScrollPhysics(),
                      indicatorWeight: .0001,
                      onTap: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
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
                              color: categories[_currentIndex] == element
                                  ? primaryColor
                                  : white,
                              // boxShadow: shadowList,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Tab(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    element["iconPath"] as String,
                                    height: 30,
                                    width: 30,
                                    color: categories[_currentIndex] == element
                                        ? white
                                        : Colors.grey[700],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 3),
                                    child: Text(
                                      element['name'] as String,
                                      style: GoogleFonts.poppins(
                                        color:
                                            categories[_currentIndex] == element
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
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
