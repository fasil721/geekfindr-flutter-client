import 'dart:convert';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geek_findr/Api/user_model.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/main.dart';
import 'package:geek_findr/views/signup_page.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final controller = Get.find<AppController>();
  int duration = 2000;
  bool isVisible = true;
  final userModel = UserModel();
  @override
  void initState() {
    super.initState();
    passwordFocusNode.unfocus();
    emailFocusNode.unfocus();
  }

  @override
  void dispose() {
    super.dispose();
    passwordFocusNode.dispose();
    emailFocusNode.dispose();
  }

  Future<void> signIn() async {
    userModel.email = emailController.text;
    userModel.password = passwordController.text;
    try {
      final response = await post(
        Uri.parse("http://www.geekfindr-dev-app.xyz/api/v1/users/signin"),
        // heresponse.statusCodeaders: {"Authorization": "Bearer $token"},
        body: userModel.toJsonSignIn(),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final jsonData =
            Map<String, String>.from(json.decode(response.body) as Map);
        final user = UserModel.fromJson(jsonData);
        final box = Hive.box('usermodel');
        await box.put("user", user);
        final pref = await SharedPreferences.getInstance();
        pref.setBool("user", true);
        Get.offAll(() => const MyApp());
      } else if (response.statusCode == 400) {
        final a = json.decode(response.body) as Map;
        final b = a["errors"][0]["message"] as String;
        Fluttertoast.showToast(msg: b);
      }
    } on HttpException {
      Fluttertoast.showToast(msg: "No Internet");
    } on PlatformException {
      Fluttertoast.showToast(msg: "Invalid Format");
    } catch (e) {
      print(e);
    }
  }

  void validator() {
    String? emailError;
    String? passwordError;
    final regex = RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]");
    final regexpass = RegExp(r'^.{4,}$');

    if (!regex.hasMatch(emailController.text)) {
      emailError = "Please Enter a valid email";
    }
    if (emailController.text.isEmpty) {
      emailError = "Please Enter Your Email";
    }
    if (!regexpass.hasMatch(passwordController.text)) {
      passwordError = "Enter Valid Password(Min. 4 Character)";
    }
    if (passwordController.text.isEmpty) {
      passwordError = "Please Enter Your Password";
    }

    if (emailError != null || passwordError != null) {
      Get.defaultDialog(
        title: "Validation",
        content: Column(
          children: [
            if (emailError != null) Text(emailError),
            if (passwordError != null) Text(passwordError),
          ],
        ),
        confirm: ElevatedButton(
          onPressed: () {
            passwordFocusNode.unfocus();
            emailFocusNode.unfocus();
            Get.back();
          },
          child: const Text("ok"),
        ),
      );
    }
    if (emailError == null && passwordError == null) {
      signIn();
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textFactor = MediaQuery.textScaleFactorOf(context);

    if (MediaQuery.of(context).viewInsets.bottom > 20) {
      isVisible = false;
    } else {
      isVisible = true;
    }
    final emailField = TextField(
      controller: emailController,
      focusNode: emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(20),
        ),
        filled: true,
        fillColor: const Color(0xffE7EAF0),
        prefixIcon: Icon(
          Icons.mail,
          color: Theme.of(context).backgroundColor,
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
      ),
    );

    final passwordField = TextField(
      controller: passwordController,
      focusNode: passwordFocusNode,
      obscureText: true,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(20),
        ),
        filled: true,
        fillColor: const Color(0xffE7EAF0),
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
      onPressed: () async {
        SystemChannels.textInput.invokeMethod("TextInput.hide");
        validator();
      },
      child: SizedBox(
        height: height * 0.06,
        width: width * 0.25,
        child: Center(
          child: Text(
            "Login",
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
            bottom: height * .25,
            child: RotationTransition(
              turns: const AlwaysStoppedAnimation(-45 / 360),
              child: FadeInDownBig(
                // duration: Duration(milliseconds: ),
                // delay: const Duration(milliseconds: 1000),
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
                      ),
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
          AnimatedOpacity(
            opacity: isVisible ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: FadeInDownBig(
              // duration: Duration(milliseconds: duration),
              // delay: const Duration(milliseconds: 1000),
              child: Hero(
                tag: "img",
                child: Image.asset(
                  'assets/images/pair.png',
                  height: height * 0.4,
                ),
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: FadeInDownBig(
          //     // duration: Duration(milliseconds: duration),
          //     // delay: const Duration(milliseconds: 1500),
          //     child: Padding(
          //       padding: isVisible
          //           ? EdgeInsets.zero
          //           : EdgeInsets.only(top: height * .15),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.end,
          //         mainAxisAlignment: isVisible
          //             ? MainAxisAlignment.center
          //             : MainAxisAlignment.start,
          //         children: [
          //           Padding(
          //             padding: EdgeInsets.symmetric(horizontal: width * 0.045),
          //             child: Text(
          //               "Don't have a account?",
          //               style: GoogleFonts.roboto(
          //                 fontSize: textFactor * 14,
          //                 color: Colors.white.withOpacity(0.9),
          //                 fontWeight: FontWeight.normal,
          //               ),
          //             ),
          //           ),
          //           const SizedBox(height: 5),
          //           Padding(
          //             padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          //             child: GestureDetector(
          //               onTap: () {
          //                 Get.to(() => const SignUpPage());
          //               },
          //               child: Text(
          //                 "Sign Up",
          //                 textAlign: TextAlign.center,
          //                 style: GoogleFonts.roboto(
          //                   fontSize: textFactor * 15,
          //                   color: Colors.white.withOpacity(0.9),
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.075,
              right: width * 0.2,
              bottom: height * 0.05,
            ),
            child: FadeInUpBig(
              // duration: Duration(milliseconds: duration),
              // delay: const Duration(milliseconds: 1500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                    child: Text(
                      "Sign In",
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        fontSize: textFactor * 28,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  emailField,
                  SizedBox(height: height * 0.02),
                  passwordField,
                  SizedBox(height: height * 0.02),
                  loginButton,
                  SizedBox(height: height * 0.02),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                    child: Text(
                      "Or Sign In with social platform",
                      style: GoogleFonts.roboto(
                        fontSize: textFactor * 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const SignUpPage());
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
        ],
      ),
    );
  }
}
