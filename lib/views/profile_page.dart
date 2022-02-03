import 'package:flutter/material.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/models/user_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);
  final box = Hive.box('usermodel');

  Future<void> updatedata() async {
    final user = box.get("user") as UserModel;
    const url = "$prodUrl/api/v1/profiles/my-profile";
    try {
      await http.patch(
        Uri.parse(url),
        headers: {"Authorization": "Bearer ${user.token}"},
        body: {
          "bio": "gasdas",
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> getData() async {
    final user = box.get("user") as UserModel;
    const url = "$prodUrl/api/v1/profiles/my-profile/";
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer ${user.token}"},
      );

      print(response.body);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;
    final textFactor = MediaQuery.textScaleFactorOf(context);
    final user = box.get("user") as UserModel;
    return Scaffold(
      backgroundColor: const Color(0xffB954FE),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await updatedata();
          getData();
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
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        "${user.avatar!}&s=130",
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.blue,
                          height: 130,
                          width: 130,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    user.username!,
                    style: GoogleFonts.roboto(
                      fontSize: textFactor * 25,
                      color: Colors.black.withOpacity(0.9),
                      fontWeight: FontWeight.normal,
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
