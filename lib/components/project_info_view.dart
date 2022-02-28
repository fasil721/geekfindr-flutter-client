import 'package:flutter/material.dart';
import 'package:geek_findr/components/edit_description_dialoge.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/services/projectServices/project_model_classes.dart';
import 'package:geek_findr/views/other_users_profile.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectInfoView extends StatelessWidget {
   const ProjectInfoView({
    Key? key,
    required this.projuctDetials,
    required this.myRole,
  }) : super(key: key);
  final ProjectDataModel projuctDetials;
  final String myRole;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textFactor = textfactorfind(MediaQuery.textScaleFactorOf(context));
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
                    projuctDetials.name!,
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
                          projuctDetials.description!.isEmpty
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
                            description: projuctDetials.description!,
                            projectId: projuctDetials.id!,
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
                        userId: projuctDetials.owner!.id!,
                      ),
                    );
                  },
                  child: Text(
                    projuctDetials.owner!.username!,
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
                projuctDetials.description!,
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
}
