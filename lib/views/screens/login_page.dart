import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geek_findr/resources/colors.dart';
import 'package:geek_findr/resources/constants.dart';
import 'package:geek_findr/resources/functions.dart';
import 'package:geek_findr/views/screens/signup_page.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
  bool isVisible = true;
  bool isLoading = false;
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

  Future<void> validator() async {
    String? emailError;
    String? passwordError;
    final regex = RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]");
    final regexpass = RegExp(r'^.{4,}$');

    if (!regex.hasMatch(emailController.text)) {
      emailError = "Enter a valid email";
    }
    if (emailController.text.isEmpty) {
      emailError = "Enter Your Email";
    }
    if (!regexpass.hasMatch(passwordController.text)) {
      passwordError = "Enter Valid Password(Min. 4 Character)";
    }
    if (passwordController.text.isEmpty) {
      passwordError = "Enter Your Password";
    }
    if (emailError != null) {
      Fluttertoast.showToast(msg: emailError);
    } else if (passwordError != null) {
      Fluttertoast.showToast(msg: passwordError);
    }
    if (emailError == null && passwordError == null) {
      await Future.delayed(const Duration(seconds: 2));
      await authServices.userSignIn(
        email: emailController.text,
        password: passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textFactor =
        textfactorCustomize(MediaQuery.textScaleFactorOf(context));

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
        hintStyle: TextStyle(
          fontSize: textFactor * 14,
        ),
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
        hintStyle: TextStyle(
          fontSize: textFactor * 14,
        ),
      ),
    );

    final loginButton = ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(5),
        backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
      ),
      onPressed: () async {
        FocusScope.of(context).unfocus();
        setState(() {
          isLoading = true;
        });
        await validator();
        setState(() {
          isLoading = false;
        });
      },
      child: isLoading
          ? SizedBox(
              height: height * 0.06,
              width: width * 0.25,
              child: const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          : SizedBox(
              height: height * 0.06,
              width: width * 0.25,
              child: Center(
                child: Text(
                  "Login",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: textFactor * 15,
                    color: white,
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
                    color: primaryColor,
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
              child: Image.asset(
                'assets/images/pair.png',
                height: height * 0.4,
              ),
            ),
          ),
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
                  SizedBox(height: height * 0.01),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                    child: Row(
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: GoogleFonts.roboto(
                            fontSize: textFactor * 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () async {
                                  await Future.delayed(
                                    const Duration(milliseconds: 500),
                                  );
                                  await Get.to(() => const SignUpPage());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    "Sign up",
                                    style: GoogleFonts.roboto(
                                      fontSize: textFactor * 15,
                                      color: primaryColor,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
