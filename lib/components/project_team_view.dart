import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/services/postServices/post_models.dart';
import 'package:geek_findr/services/projectServices/project_model_classes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class ProjectTeamView extends StatefulWidget {
  const ProjectTeamView({Key? key, required this.teamList, required this.owner})
      : super(key: key);
  final List<Team> teamList;
  final Owner owner;

  @override
  State<ProjectTeamView> createState() => _ProjectTeamViewState();
}

class _ProjectTeamViewState extends State<ProjectTeamView> {
  List<Team> membersList = [];
  List<Team> joinRequests = [];
  @override
  void initState() {
    findMembers();
    super.initState();
  }

  void findMembers() {
    membersList = [];
    joinRequests = [];
    for (final element in widget.teamList) {
      if (element.role == "joinRequest") {
        joinRequests.add(element);
      } else {
        membersList.add(element);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textFactor = textfactorfind(MediaQuery.textScaleFactorOf(context));
    return Container(
      margin: const EdgeInsets.all(20),
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Members - ${membersList.length + 1}",
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: black,
            ),
          ),
          SizedBox(height: height * 0.01),
          Container(
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  border: Border.all(color: primaryColor),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  "Owner",
                  style: GoogleFonts.poppins(
                    fontSize: textFactor * 12,
                    color: black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              title: Text(
                widget.owner.username!,
              ),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  imageUrl: widget.owner.avatar!,
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
            ),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(vertical: membersList.isNotEmpty ? 10 : 5),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: membersList.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    trailing: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            border: Border.all(color: primaryColor),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            widget.teamList[index].role!,
                            style: GoogleFonts.poppins(
                              fontSize: textFactor * 12,
                              color: black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        PopupMenuButton(
                          itemBuilder: (BuildContext bc) => [
                            PopupMenuItem(
                              value: "1",
                              child: Text(
                                "Change Member role",
                                style: GoogleFonts.poppins(
                                  fontSize: textFactor * 12,
                                  color: Colors.black.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == "1") {}
                          },
                          icon: Icon(
                            Icons.more_horiz,
                            color: black,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    title: Text(
                      widget.teamList[index].user!.username!,
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        imageUrl: widget.teamList[index].user!.avatar!,
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
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 10),
            ),
          ),
          Text(
            "Join requests - ${joinRequests.length}",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: joinRequests.isNotEmpty
                ? ListView.separated(
                    shrinkWrap: true,
                    itemCount: joinRequests.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          trailing: Container(
                            padding: const EdgeInsets.all(13),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all<double>(3),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  primaryColor,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                "Accept",
                                style: GoogleFonts.poppins(
                                  fontSize: textFactor * 12,
                                  color: white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            widget.teamList[index].user!.username!,
                          ),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              imageUrl: widget.teamList[index].user!.avatar!,
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
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 10),
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "No Join Requests here!!",
                        style: GoogleFonts.poppins(
                          fontSize: textFactor * 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
