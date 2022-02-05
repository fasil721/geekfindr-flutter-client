import 'package:flutter/material.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/models/user_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProfilePage2 extends StatelessWidget {
  ProfilePage2({Key? key}) : super(key: key);
  final box = Hive.box('usermodel');

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textFactor = MediaQuery.textScaleFactorOf(context);
    final user = box.get("user") as UserModel;
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: height * .15),
                height: height,
                width: width,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.7),
                      blurRadius: 5,
                      offset: const Offset(0, 7),
                    ),
                    BoxShadow(
                      color: Colors.grey.withOpacity(.7),
                      blurRadius: 5,
                      offset: const Offset(10, 0),
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: height * .07,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: const Color(0xffE7EAF0),
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        "${user.avatar!}&s=${height * 0.15}",
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.blue,
                          height: 130,
                          width: 130,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Text(
                    user.username!,
                    style: GoogleFonts.poppins(
                      fontSize: textFactor * 25,
                      color: Colors.black.withOpacity(0.9),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Mobile Developer",
                    style: GoogleFonts.roboto(
                      fontSize: textFactor * 15,
                      color: Colors.black.withOpacity(0.6),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            "10",
                            style: GoogleFonts.poppins(
                              fontSize: textFactor * 18,
                              color: Colors.black.withOpacity(0.8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "  Posts  ",
                            style: GoogleFonts.poppins(
                              fontSize: textFactor * 15,
                              color: Colors.black.withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        color: Colors.grey,
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        height: 20,
                        width: 1.5,
                      ),
                      Column(
                        children: [
                          Text(
                            "10.k",
                            style: GoogleFonts.poppins(
                              fontSize: textFactor * 18,
                              color: Colors.black.withOpacity(0.8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            " Followers",
                            style: GoogleFonts.poppins(
                              fontSize: textFactor * 15,
                              color: Colors.black.withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        color: Colors.grey,
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        height: 20,
                        width: 1.5,
                      ),
                      Column(
                        children: [
                          Text(
                            "1.9k",
                            style: GoogleFonts.poppins(
                              fontSize: textFactor * 18,
                              color: Colors.black.withOpacity(0.8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Followings",
                            style: GoogleFonts.poppins(
                              fontSize: textFactor * 14,
                              color: Colors.black.withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(5),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(primaryColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () {},
                    child: SizedBox(
                      height: height * 0.058,
                      width: width * 0.25,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.edit_outlined,
                            size: 18,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: width * 0.01,
                          ),
                          Text(
                            "Edit Profile",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: textFactor * 14,
                              color: Colors.white.withOpacity(0.95),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
