import 'package:flutter/material.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/models/user_profile_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';

class ProfileAboutView extends StatelessWidget {
  const ProfileAboutView({Key? key, required this.userData}) : super(key: key);
  final UserProfileModel userData;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textFactor = textfactorfind(MediaQuery.textScaleFactorOf(context));
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white.withOpacity(0.9),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Bio",
                style: GoogleFonts.poppins(
                  fontSize: textFactor * 16,
                  color: Colors.black.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: height * 0.001),
            Align(
              alignment: Alignment.centerLeft,
              child: ReadMoreText(
                userData.bio == null ? "" : userData.bio!,
                style: GoogleFonts.poppins(
                  fontSize: textFactor * 15,
                  color: Colors.black.withOpacity(0.8),
                  fontWeight: FontWeight.w400,
                ),
                colorClickableText: primaryColor,
                trimMode: TrimMode.Line,
              ),
            ),
            SizedBox(height: height * 0.002),
            const Divider(thickness: 1.5),
            SizedBox(height: height * 0.002),
            expationPanelWidget(
              img: "assets/icons/office.png",
              width: width,
              textFactor: textFactor,
              title: "Organizations",
              list: userData.organizations!,
            ),
            SizedBox(height: height * 0.02),
            expationPanelWidget(
              img: "assets/icons/office.png",
              width: width,
              textFactor: textFactor,
              title: "Experience",
              list: [],
            ),
            SizedBox(height: height * 0.02),
            expationPanelWidget(
              img: "assets/icons/office.png",
              width: width,
              textFactor: textFactor,
              title: "Education",
              list: [],
            ),
            SizedBox(height: height * 0.02),
            expationPanelWidget(
              img: "assets/icons/office.png",
              width: width,
              textFactor: textFactor,
              title: "Social",
              list: [],
            ),
            SizedBox(height: height * 0.02),
            expationPanelWidget(
              img: "assets/icons/office.png",
              width: width,
              textFactor: textFactor,
              title: "Skills",
              list: [],
            ),
            SizedBox(height: height * 0.02),
            expationPanelWidget(
              img: "assets/icons/office.png",
              width: width,
              textFactor: textFactor,
              title: "Works",
              list: [],
            ),
            SizedBox(height: height * 0.02),
          ],
        ),
      ),
    );
  }

  Widget expationPanelWidget({
    required String img,
    required String title,
    required List<String> list,
    required double width,
    required double textFactor,
  }) =>
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1.2, color: Colors.grey),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: ExpansionTile(
            iconColor: primaryColor,
            tilePadding: EdgeInsets.zero,
            title: Row(
              children: [
                ImageIcon(
                  AssetImage(img),
                  color: Colors.black,
                  size: 22,
                ),
                SizedBox(width: width * 0.04),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: textFactor * 16,
                    color: Colors.black.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            children: [
              ...list.map(
                (e) => Container(
                  padding: const EdgeInsets.only(bottom: 10, left: 5),
                  child: Row(
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.black.withOpacity(0.9),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 7),
                        child: Text(
                          e,
                          style: GoogleFonts.poppins(
                            fontSize: textFactor * 15,
                            color: Colors.black.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
