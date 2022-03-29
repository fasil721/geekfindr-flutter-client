import 'package:flutter/material.dart';
import 'package:geek_findr/constants.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/functions.dart';
import 'package:geek_findr/models/project_models.dart';
import 'package:geek_findr/views/screens/project_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class MyProjectList extends StatelessWidget {
  const MyProjectList({Key? key}) : super(key: key);
//  late List<ProjectShortModel> datas;

  Future<void> refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    controller.update(["projectList"]);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textFactor =
        textfactorCustomize(MediaQuery.textScaleFactorOf(context));
    return GetBuilder<AppController>(
      id: "projectList",
      builder: (controller) {
        return FutureBuilder(
          future: projectServices.getMyProjects(),
          builder: (context, AsyncSnapshot<List<ProjectShortModel>?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _skeleton(width, textFactor);
            }
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data != null) {
                final datas = snapshot.data!.reversed.toList();
                if (datas.isEmpty) {
                  return Center(
                    child: Text(
                      "0 Projects",
                      style: GoogleFonts.rubik(),
                    ),
                  );
                }
                return Scaffold(
                  backgroundColor: secondaryColor,
                  body: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: RefreshIndicator(
                        color: primaryColor,
                        onRefresh: refresh,
                        child: ScrollConfiguration(
                          behavior: const ScrollBehavior()
                              .copyWith(overscroll: false),
                          child: ListView.separated(
                            itemCount: datas.length,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () => Get.to(
                                () => ProjectView(
                                  projectId: datas[index].project!.id!,
                                ),
                              ),
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
                                                color: Colors.black
                                                    .withOpacity(0.9),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(height: height * 0.005),
                                            Expanded(
                                              child: Text(
                                                datas[index]
                                                    .project!
                                                    .description!,
                                                maxLines: 3,
                                                style: GoogleFonts.poppins(
                                                  fontSize: textFactor * 13,
                                                  color: Colors.black
                                                      .withOpacity(0.9),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const SizedBox(height: 10),
                          ),
                        ),
                      ),
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

  Widget _skeleton(double width, double textFactor) => Scaffold(
        body: Shimmer.fromColors(
          baseColor: Colors.grey.withOpacity(0.3),
          highlightColor: white,
          period: const Duration(milliseconds: 1000),
          child: Container(
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) => Column(
                children: [
                  Container(
                    width: width,
                    height: 115,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 15)
                ],
              ),
            ),
          ),
        ),
      );
}
