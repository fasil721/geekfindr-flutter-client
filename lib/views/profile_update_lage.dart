import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/models/error_model.dart';
import 'package:geek_findr/models/user_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class ProfileUpatePage extends StatelessWidget {
  ProfileUpatePage({Key? key}) : super(key: key);
  final bioController = TextEditingController();
  final box = Hive.box('usermodel');
  Future<void> updatedata() async {
    final user = box.get("user") as UserModel;
    const url = "$prodUrl/api/v1/profiles/my-profile";
    final body = {
      "bio": "hai all",
      "organizations": ["hello", ""],
      "skills": ["coding"],
    };
    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${user.token}",
          "Content-Type": "application/json"
        },
        body: json.encode(body),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 422) {
        final errorJson = json.decode(response.body) as Map;
        final err = ErrorModel.fromJson(errorJson.cast());
        final a = <Error>[];
      }
      if (response.statusCode == 200) {
        getData();
      }
    } on HttpException {
      Fluttertoast.showToast(msg: "No Internet");
    } on PlatformException {
      Fluttertoast.showToast(msg: "Invalid Format");
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          updatedata();
        },
      ),
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
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.check,
              size: 26,
              color: roseColor,
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
                  height: height * .1,
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 0.9, color: Colors.grey),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: bioField,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
