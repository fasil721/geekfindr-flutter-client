import 'package:flutter/material.dart';
import 'package:geek_findr/models/user_profile_model.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileAboutView extends StatelessWidget {
  const ProfileAboutView({Key? key, required this.userData}) : super(key: key);
  final UserProfileModel userData;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textFactor = MediaQuery.textScaleFactorOf(context);
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white.withOpacity(0.9),
      ),
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
            child: Text(
              userData.bio!,
              style: GoogleFonts.poppins(
                fontSize: textFactor * 15,
                color: Colors.black.withOpacity(0.8),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: height * 0.002),
          const Divider(thickness: 1.5),
          SizedBox(height: height * 0.002),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Organization",
              style: GoogleFonts.poppins(
                fontSize: textFactor * 16,
                color: Colors.black.withOpacity(0.8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: height * 0.002),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              direction: Axis.vertical,
              children: [
                ...userData.organizations!.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      e,
                      style: GoogleFonts.poppins(
                        fontSize: textFactor * 15,
                        color: Colors.black.withOpacity(0.8),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
