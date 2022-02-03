
import 'package:flutter/material.dart';
import 'package:geek_findr/models/user_model.dart';
import 'package:geek_findr/views/profile_update_lage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';


class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);
  final box = Hive.box('usermodel');

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textFactor = MediaQuery.textScaleFactorOf(context);
    final user = box.get("user") as UserModel;
    return Scaffold(
      backgroundColor: const Color(0xffB954FE),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() =>  ProfileUpatePage());
        },
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Align(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                "${user.avatar!}&s=100",
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  color: Colors.blue,
                                  height: 130,
                                  width: 130,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                user.username!,
                                style: GoogleFonts.roboto(
                                  fontSize: textFactor * 22,
                                  color: Colors.black.withOpacity(0.9),
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(
                                height: height * 0.005,
                              ),
                              Text(
                                "Mobile Developer",
                                style: GoogleFonts.roboto(
                                  fontSize: textFactor * 15,
                                  color: Colors.black.withOpacity(0.6),
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    child: Text(
                      user.username!,
                      style: GoogleFonts.roboto(
                        fontSize: textFactor * 25,
                        color: Colors.black.withOpacity(0.9),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
