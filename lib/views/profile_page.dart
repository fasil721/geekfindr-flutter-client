import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geek_findr/Services/user_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);
  final box = Hive.box<UserModel>('usermodel');

  Future<void> makePatchRequest() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
    final headers = {"Content-type": "application/json"};
    const json = '{"userId": "Hai"}';
    final response = await patch(url, headers: headers, body: json);
    if (kDebugMode) {
      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');
    }
  }

  Future<void> getData() async {
    final user = box.get("user") ;
    const url = "http://www.geekfindr-dev-app.xyz/api/v1/profiles/my-profile/";
    print(user!.username);
    try {
      final response = await patch(
        Uri.parse(url),
        headers: {"Authorization": "Bearer ${user.token}"},
        body: {
          "bio": "data",
        },
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
        onPressed: () {
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
