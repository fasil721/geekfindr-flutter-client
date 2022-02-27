import 'package:flutter/material.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/services/projectServices/project_model_classes.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class ProjectTodosView extends StatelessWidget {
  ProjectTodosView({Key? key, required this.projuctDetials}) : super(key: key);
  final ProjuctDetialsModel projuctDetials;

  List<String> noStatusList = [];
  List<String> nextUpList = [];
  List<String> inProgressList = [];
  List<String> completedList = [];
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textFactor = textfactorfind(MediaQuery.textScaleFactorOf(context));
    final myRole = findMyRole(projuctDetials.team!);
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Status",
            style: GoogleFonts.poppins(
              fontSize: textFactor * 17,
              fontWeight: FontWeight.w600,
              color: black,
            ),
          ),
          SizedBox(height: height * 0.01),
        ],
      ),
    );
  }
}
