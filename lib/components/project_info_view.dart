import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/functions.dart';
import 'package:geek_findr/services/projectServices/project_model_classes.dart';
import 'package:geek_findr/services/projectServices/projects.dart';
import 'package:geek_findr/views/users_profile_page.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectInfoView extends StatefulWidget {
  const ProjectInfoView({
    Key? key,
    required this.projuctDetials,
    required this.myRole,
  }) : super(key: key);
  final ProjectDataModel projuctDetials;
  final String myRole;

  @override
  State<ProjectInfoView> createState() => _ProjectInfoViewState();
}

class _ProjectInfoViewState extends State<ProjectInfoView> {
  final myProjects = ProjectServices();
  TextEditingController? descTextController;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textFactor =
        textfactorCustomize(MediaQuery.textScaleFactorOf(context));
    return Container(
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
                    widget.projuctDetials.name!,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: black,
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.myRole == admin || widget.myRole == owner,
                  child: PopupMenuButton(
                    itemBuilder: (BuildContext bc) => [
                      PopupMenuItem(
                        value: "1",
                        child: Text(
                          widget.projuctDetials.description!.isEmpty
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
                          buildEditDescriptionDialoge(
                            description: widget.projuctDetials.description!,
                            projectId: widget.projuctDetials.id!,
                            width: width,
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
                        userId: widget.projuctDetials.owner!.id!,
                      ),
                    );
                  },
                  child: Text(
                    widget.projuctDetials.owner!.username!,
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
                widget.projuctDetials.description!,
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

  Widget buildEditDescriptionDialoge({
    required String description,
    required String projectId,
    required double width,
  }) {
    descTextController = TextEditingController(text: description);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: width * 0.8,
          child: Material(
            borderRadius: BorderRadius.circular(
              20,
            ),
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(
                    10.0,
                  ),
                  child: TextField(
                    controller: descTextController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 1,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Description",
                      filled: true,
                      fillColor: white,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(3),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(primaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (descTextController!.text.isNotEmpty) {
                      final body = {"description": descTextController!.text};
                      myProjects.editProjectDescription(
                        projectId: projectId,
                        body: body,
                      );
                    } else {
                      Fluttertoast.showToast(msg: "Field can't be empty");
                    }
                  },
                  child: const Text("Save"),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
