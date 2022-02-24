import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/services/projectServices/project_model_classes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class ProjectTeamView extends StatelessWidget {
  ProjectTeamView({Key? key, required this.teamList}) : super(key: key);
  final List<Team> teamList;
  int membersCount = 0;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;
    // final textFactor = textfactorfind(MediaQuery.textScaleFactorOf(context));
    return Container(
      margin: const EdgeInsets.all(20),
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Members - $membersCount",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: teamList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  tileColor: white,
                  title: Text(
                    teamList[index].user!.username!,
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      imageUrl: teamList[index].user!.avatar!,
                      fit: BoxFit.fitWidth,
                      width: 30,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey.withOpacity(0.3),
                        highlightColor: white,
                        period: const Duration(
                          milliseconds: 1000,
                        ),
                        child: Container(
                          height: 300,
                          width: width,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(
                              100,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 10),
            ),
          )
        ],
      ),
    );
  }
}
