import 'package:flutter/material.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/models/box_instance.dart';
import 'package:geek_findr/models/user_profile_model.dart';
import 'package:geek_findr/services/profile.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileUpatePage extends StatefulWidget {
  const ProfileUpatePage({Key? key, required this.userData}) : super(key: key);
  final UserProfileModel userData;
  @override
  State<ProfileUpatePage> createState() => _ProfileUpatePageState();
}

class _ProfileUpatePageState extends State<ProfileUpatePage> {
  final box = Boxes.getInstance();
  final orgItems = <String>[];
  final orgController = TextEditingController();
  final sklController = TextEditingController();
  final skillsItems = <String>[];
  TextEditingController? bioController;
  TextEditingController? roleController;
  TextEditingController? gitController;
  TextEditingController? linkController;
  TextEditingController? stdyController;
  @override
  void initState() {
    super.initState();
    bioController = TextEditingController(
      text: widget.userData.bio == null || widget.userData.bio!.isEmpty
          ? ""
          : widget.userData.bio,
    );
    roleController = TextEditingController(
      text: widget.userData.role == null || widget.userData.role!.isEmpty
          ? ""
          : widget.userData.role,
    );
    if (widget.userData.socials != null &&
        widget.userData.socials!.isNotEmpty) {
      gitController = TextEditingController(
        text: widget.userData.socials!.first["github"] == null ||
                widget.userData.socials!.first["github"]!.isEmpty
            ? ""
            : widget.userData.socials!.first["github"],
      );
      linkController = TextEditingController(
        text: widget.userData.socials!.last["linkedin"] == null ||
                widget.userData.socials!.last["linkedin"]!.isEmpty
            ? ""
            : widget.userData.socials!.last["linkedin"],
      );
    } else {
      gitController = TextEditingController(text: "");
      linkController = TextEditingController(text: "");
    }
    if (widget.userData.education != null &&
        widget.userData.education!.isNotEmpty) {
      final key = widget.userData.education!.first.keys.first;
      final value = widget.userData.education!.first.values.first;
      studyType = key;
      stdyController = TextEditingController(text: value);
    } else {
      stdyController = TextEditingController(text: "");
    }

    if (widget.userData.organizations!.isNotEmpty) {
      for (final i in widget.userData.organizations!) {
        orgItems.add(i);
      }
    }
    if (widget.userData.skills!.isNotEmpty) {
      for (final i in widget.userData.skills!) {
        skillsItems.add(i);
      }
    }
    if (widget.userData.experience!.isNotEmpty) {
      final a = widget.userData.experience!.split(" ");
      num = a.first;
      long = a.last;
    }
  }

  void updateData() {
    final userprofilemodel = UserProfileModel();
    userprofilemodel.bio = bioController!.text;
    userprofilemodel.organizations = orgItems;
    userprofilemodel.role = roleController!.text;
    userprofilemodel.experience =
        num != null && long != null ? "${num!} ${long!}" : "";
    userprofilemodel.socials = [
      {"github": gitController!.text},
      {"linkedin": linkController!.text}
    ];
    if (studyType != null) {
      userprofilemodel.education = [
        {studyType!: stdyController!.text},
      ];
    } else {
      userprofilemodel.education = [];
    }

    updateUserProfileData(userprofilemodel.toJson());
  }

  final numList = <String>[
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11"
  ];
  final longList = <String>["Month", "Year"];
  final studyList = <String>["School", "Bachelors", "Masters"];
  String? studyType;

  String? num;
  String? long;
  @override
  Widget build(BuildContext context) {
    final user = box.get("user");
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textFactor = textfactorfind(MediaQuery.textScaleFactorOf(context));

    final bioField = TextField(
      controller: bioController,
      textInputAction: TextInputAction.newline,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      minLines: 1,
      decoration: const InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
    );

    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        toolbarHeight: 80,
        leadingWidth: 60,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            size: 26,
            color: Colors.black54,
          ),
        ),
        title: Center(
          child: Text(
            "Profile",
            style: GoogleFonts.poppins(
              fontSize: textFactor * 20,
              color: Colors.black.withOpacity(0.9),
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              updateData();
            },
            icon: const Icon(
              Icons.check,
              size: 26,
              color: primaryColor,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SizedBox(
        width: width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    "${user!.avatar!}&s=120",
                    // loadingBuilder: (context, child, loadingProgress) =>
                    //     const SizedBox(
                    //   height: 120,
                    //   width: 120,
                    //   child: Center(child: CircularProgressIndicator()),
                    // ),
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.blue,
                      height: 130,
                      width: 130,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Text(
                  user.username!,
                  style: GoogleFonts.roboto(
                    fontSize: textFactor * 22,
                    color: Colors.black.withOpacity(0.9),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      "Role / Position",
                      style: GoogleFonts.roboto(
                        fontSize: textFactor * 16,
                        color: Colors.black.withOpacity(0.99),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.005,
                ),
                Container(
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 0.9, color: Colors.grey),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextField(
                    controller: roleController,
                    decoration: InputDecoration(
                      hintText: "ex: frontend developer",
                      hintStyle: TextStyle(
                        fontSize: textFactor * 15,
                      ),
                      iconColor: primaryColor,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      "Bio",
                      style: GoogleFonts.roboto(
                        fontSize: textFactor * 16,
                        color: Colors.black.withOpacity(0.99),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.005,
                ),
                Container(
                  height: height * .15,
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 0.9, color: Colors.grey),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: bioField,
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      "Organization",
                      style: GoogleFonts.roboto(
                        fontSize: textFactor * 15,
                        color: Colors.black.withOpacity(0.99),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Container(
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 0.9, color: Colors.grey),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: GetBuilder<AppController>(
                    id: "org",
                    builder: (controller) {
                      return Column(
                        children: [
                          if (orgItems.isNotEmpty)
                            ...orgItems.map(
                              (e) => Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      orgItems.remove(e);
                                      controller.update(["org"]);
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      size: 22,
                                      color: Colors.red,
                                    ),
                                  ),
                                  SizedBox(width: width * 0.04),
                                  Text(
                                    e,
                                    style: GoogleFonts.roboto(
                                      fontSize: textFactor * 16,
                                      color: Colors.black.withOpacity(0.99),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          TextField(
                            controller: orgController,
                            decoration: InputDecoration(
                              hintText: "Type here",
                              hintStyle: TextStyle(
                                fontSize: textFactor * 15,
                              ),
                              iconColor: primaryColor,
                              icon: IconButton(
                                onPressed: () {
                                  if (orgController.text.isNotEmpty) {
                                    orgItems.add(orgController.text);
                                    orgController.clear();
                                    controller.update(["org"]);
                                  }
                                },
                                icon: const Icon(Icons.add),
                              ),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      "Education",
                      style: GoogleFonts.roboto(
                        fontSize: textFactor * 15,
                        color: Colors.black.withOpacity(0.99),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Container(
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 0.9, color: Colors.grey),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextField(
                    controller: stdyController,
                    decoration: InputDecoration(
                      hintText: "Ex: st. Joseph collage",
                      hintStyle: GoogleFonts.roboto(
                        fontSize: textFactor * 15,
                      ),
                      icon: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isDense: true,
                          value: studyType,
                          items: studyList
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e,
                                    style: TextStyle(
                                      fontSize: textFactor * 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  onTap: () {
                                    studyType = e;
                                    setState(() {});
                                  },
                                ),
                              )
                              .toList(),
                          onChanged: (value) {},
                        ),
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      "Experience",
                      style: GoogleFonts.roboto(
                        fontSize: textFactor * 16,
                        color: Colors.black.withOpacity(0.99),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Container(
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 0.9, color: Colors.grey),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: num,
                          // isExpanded: true,
                          items: numList
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e,
                                    style: TextStyle(
                                      fontSize: textFactor * 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  onTap: () {
                                    num = e;
                                    setState(() {});
                                  },
                                ),
                              )
                              .toList(),
                          onChanged: (value) {},
                        ),
                      ),
                      SizedBox(
                        width: width * 0.05,
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: long,
                          items: longList
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e,
                                    style: TextStyle(
                                      fontSize: textFactor * 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  onTap: () {
                                    long = e;
                                    setState(() {});
                                  },
                                ),
                              )
                              .toList(),
                          onChanged: (value) {},
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      "Social links",
                      style: GoogleFonts.roboto(
                        fontSize: textFactor * 16,
                        color: Colors.black.withOpacity(0.99),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.005,
                ),
                Container(
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 0.9, color: Colors.grey),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextField(
                    controller: gitController,
                    decoration: InputDecoration(
                      hintText: "github url",
                      focusColor: Colors.black,
                      hintStyle: TextStyle(
                        fontSize: textFactor * 15,
                      ),
                      icon: const ImageIcon(
                        AssetImage('assets/images/github.png'),
                        color: Colors.black,
                      ),
                      iconColor: primaryColor,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Container(
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 0.9, color: Colors.grey),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextField(
                    controller: linkController,
                    decoration: InputDecoration(
                      hintText: "linkedin url",
                      hintStyle: TextStyle(
                        fontSize: textFactor * 15,
                      ),
                      iconColor: primaryColor,
                      icon: const ImageIcon(
                        AssetImage('assets/images/linkedin.png'),
                        color: Colors.blue,
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 3),
                //     child: Text(
                //       "Skills",
                //       style: GoogleFonts.roboto(
                //         fontSize: textFactor * 15,
                //         color: Colors.black.withOpacity(0.99),
                //         fontWeight: FontWeight.w500,
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: height * 0.01,
                // ),
                // Container(
                //   alignment: Alignment.topCenter,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(10),
                //     border: Border.all(width: 0.9, color: Colors.grey),
                //   ),
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                //   child: GetBuilder<AppController>(
                //     id: "skl",
                //     builder: (controller) {
                //       return Column(
                //         children: [
                //           if (skillsItems.isNotEmpty)
                //             ...skillsItems.map(
                //               (e) => Row(
                //                 children: [
                //                   IconButton(
                //                     onPressed: () {
                //                       skillsItems.remove(e);
                //                       controller.update(["skl"]);
                //                     },
                //                     icon: const Icon(
                //                       Icons.close,
                //                       size: 22,
                //                       color: Colors.red,
                //                     ),
                //                   ),
                //                   SizedBox(width: width * 0.04),
                //                   Text(
                //                     e,
                //                     style: GoogleFonts.roboto(
                //                       fontSize: textFactor * 16,
                //                       color: Colors.black.withOpacity(0.99),
                //                       fontWeight: FontWeight.w500,
                //                     ),
                //                   )
                //                 ],
                //               ),
                //             ),
                //           TextField(
                //             controller: sklController,
                //             decoration: InputDecoration(
                //               iconColor: primaryColor,
                //               hintText: "Type here",
                //               hintStyle: TextStyle(
                //                 fontSize: textFactor * 15,
                //               ),
                //               icon: IconButton(
                //                 onPressed: () {
                //                   if (sklController.text.isNotEmpty) {
                //                     skillsItems.add(sklController.text);
                //                     sklController.clear();
                //                     controller.update(["skl"]);
                //                   }
                //                 },
                //                 icon: const Icon(Icons.add),
                //               ),
                //               border: InputBorder.none,
                //               focusedBorder: InputBorder.none,
                //               enabledBorder: InputBorder.none,
                //               errorBorder: InputBorder.none,
                //               disabledBorder: InputBorder.none,
                //             ),
                //           ),
                //         ],
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
