import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geek_findr/Api/user_model.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geek_findr/views/home_page.dart';
import 'package:geek_findr/views/login_page.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final userNameController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final userNameFocusNode = FocusNode();
  final controller = Get.find<AppController>();
  bool isVisible = true;
  final userModel = UserModel();
  @override
  void dispose() {
    passwordFocusNode.dispose();
    emailFocusNode.dispose();
    userNameFocusNode.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    userModel.username = userNameController.text;
    userModel.email = emailController.text;
    userModel.password = passwordController.text;
    try {
      print(userModel.toJsonSignUp());
      final response = await post(
        Uri.parse("http://www.geekfindr-dev-app.xyz/api/v1/users/signup/"),
        // headers: {"Authorization": "Bearer $token"},
        body: userModel.toJsonSignUp(),
      );
      print(response.statusCode);
      if (response.statusCode == 201) {
        final jsonData =
            Map<String, String>.from(json.decode(response.body) as Map);
        controller.user = UserModel.fromJson(jsonData);
        Get.offAll(() => const MyApp());
        final pref = await SharedPreferences.getInstance();
        await pref.setBool("user", true);
      } else if (response.statusCode == 400) {
        final a = json.decode(response.body);
        final err = a["errors"][0]["message"] as String;
        Fluttertoast.showToast(msg: err);
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textFactor = MediaQuery.textScaleFactorOf(context);
    final orientation = MediaQuery.of(context).orientation;
    if (MediaQuery.of(context).viewInsets.bottom > 200) {
      isVisible = false;
    } else {
      isVisible = true;
    }
    final userNameField = TextFormField(
      focusNode: userNameFocusNode,
      controller: userNameController,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.account_circle,
          color: Theme.of(context).backgroundColor,
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "User Name",
        border: InputBorder.none,
      ),
    );
    final emailField = TextFormField(
      controller: emailController,
      focusNode: emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: Icon(
          Icons.mail,
          color: Theme.of(context).backgroundColor,
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
      ),
    );

    final passwordField = TextFormField(
      controller: passwordController,
      focusNode: passwordFocusNode,
      obscureText: true,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: Icon(
          Icons.vpn_key,
          color: Theme.of(context).backgroundColor,
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
      ),
    );

    final loginButton = ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(5),
        backgroundColor:
            MaterialStateProperty.all<Color>(const Color(0xffB954FE)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
      ),
      onPressed: () {
        SystemChannels.textInput.invokeMethod("TextInput.hide");
        signUp();
      },
      child: SizedBox(
        height: height * 0.06,
        width: width * 0.25,
        child: Center(
          child: Text(
            "Sign Up",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: textFactor * 15,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          Positioned(
            bottom: height * .32,
            child: RotationTransition(
              turns: const AlwaysStoppedAnimation(-45 / 360),
              child: Hero(
                tag: "con",
                child: FadeInDownBig(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffB954FE),
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
                        )
                      ],
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(1000),
                      ),
                    ),
                    height: height * .95,
                    width: width * 1.5,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: width * 0.1),
              child: AnimatedOpacity(
                opacity: isVisible ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: FadeInDownBig(
                  child: Image.asset(
                    'assets/images/Pull.png',
                    height: height * 0.28,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.075,
              right: width * 0.2,
              bottom: height * 0.05,
            ),
            child: Form(
              key: formkey,
              child: FadeInUpBig(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * .01),
                      child: Text(
                        "Sign Up",
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          fontSize: textFactor * 28,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.0175),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xffE7EAF0),
                      ),
                      child: userNameField,
                    ),
                    SizedBox(height: height * 0.0175),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xffE7EAF0),
                      ),
                      child: emailField,
                    ),
                    SizedBox(height: height * 0.0175),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xffE7EAF0),
                      ),
                      child: passwordField,
                    ),
                    SizedBox(height: height * 0.0175),
                    loginButton,
                    SizedBox(height: height * 0.0175),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                      child: Text(
                        "Or Sign up with social platform",
                        style: GoogleFonts.roboto(
                          fontSize: textFactor * 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    GestureDetector(
                      onTap: () {
                        Get.off(() => const LoginPage());
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: width * 0.01,
                        ),
                        child: Image.asset(
                          'assets/images/github.png',
                          height: height * 0.04,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
