import 'package:flutter/material.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/models/user_model.dart';
import 'package:geek_findr/models/user_profile_model.dart';
import 'package:geek_findr/services/user_services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProfileUpatePage extends StatefulWidget {
  const ProfileUpatePage({Key? key, required this.userData}) : super(key: key);
  final UserProfileModel userData;
  @override
  State<ProfileUpatePage> createState() => _ProfileUpatePageState();
}

class _ProfileUpatePageState extends State<ProfileUpatePage> {
  final box = Hive.box('usermodel');
  final orgItems = <String>[];
  final orgController = TextEditingController();
  final sklController = TextEditingController();
  final skillsItems = <String>[];
  TextEditingController? bioController;

  @override
  void initState() {
    super.initState();
    bioController = TextEditingController(
      text: widget.userData.bio!.isEmpty ? "" : widget.userData.bio,
    );
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
  }

  @override
  Widget build(BuildContext context) {
    final user = box.get("user") as UserModel;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textFactor = MediaQuery.textScaleFactorOf(context);

    final bioField = TextFormField(
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
              final Map<String, dynamic> body = {
                "bio": bioController!.text,
                "organizations": orgItems,
                "skills": skillsItems,
              };
              updateProfileData(body);
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
                    "${user.avatar!}&s=120",
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
                  height: height * 0.02,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      "Skills",
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
                    id: "skl",
                    builder: (controller) {
                      return Column(
                        children: [
                          if (skillsItems.isNotEmpty)
                            ...skillsItems.map(
                              (e) => Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      skillsItems.remove(e);
                                      controller.update(["skl"]);
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
                            controller: sklController,
                            decoration: InputDecoration(
                              iconColor: primaryColor,
                              hintText: "Type here",
                              icon: IconButton(
                                onPressed: () {
                                  if (sklController.text.isNotEmpty) {
                                    skillsItems.add(sklController.text);
                                    sklController.clear();
                                    controller.update(["skl"]);
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
                // Center(
                //   child: NumberPicker(
                //     value: _currentValue,
                //     minValue: 0,
                //     maxValue: 15,
                //     itemHeight: 30,
                //     // decoration: BoxDecoration(
                //     //   borderRadius: BorderRadius.circular(16),
                //     //   border: Border.all(color: Colors.black26),
                //     // ),
                //     onChanged: (value) => setState(() {
                //       _currentValue = value;
                //       print(value);
                //     }),
                //   ),
                // ),
                // DropdownButton<String>(
                //   items: <String>['6 Months', '1 Year', '2 Year', '3 Year']
                //       .map((String value) {
                //     return DropdownMenuItem<String>(
                //       value: value,
                //       child: Text(value),
                //     );
                //   }).toList(),
                //   onChanged: (value) {
                //     print(value);
                //   },
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
