import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/views/signup_page.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final controller = Get.find<AppController>();
  AnimationController? animationController;
  Animation<double>? fadeInFadeOut;
  int duration = 2000;
  bool isVisible = true;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    fadeInFadeOut =
        Tween<double>(begin: 0.0, end: 0.5).animate(animationController!);

    animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController!.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController!.forward();
      }
    });
    animationController!.forward();
  }

  @override
  void dispose() {
    passwordFocusNode.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textFactor = MediaQuery.textScaleFactorOf(context);

    if (MediaQuery.of(context).viewInsets.bottom > 200) {
      isVisible = false;
    } else {
      isVisible = true;
    }
    // print(MediaQuery.of(context).viewInsets.bottom);
    final emailField = TextFormField(
      // onTap: () {
      //   isVisible = false;
      //   controller.update(["image"]);
      // },
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
      // onTap: () {
      //   isVisible = false;
      //   controller.update(["image"]);
      // },
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

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(40),
      color: const Color(0xffB954FE),
      child: GestureDetector(
        onTap: () {
          SystemChannels.textInput.invokeMethod("TextInput.hide");
          // isVisible = true;
          // controller.update(["image"]);
        },
        child: SizedBox(
          height: height * 0.066,
          width: width * 0.3,
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
                child: Hero(
                  tag: "cont",
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
          Align(
            alignment: Alignment.centerRight,
            child: FadeInDownBig(
              // duration: Duration(milliseconds: duration),
              // delay: const Duration(milliseconds: 1500),
              child: Padding(
                padding: isVisible
                    ? EdgeInsets.zero
                    : EdgeInsets.only(top: height * .15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: isVisible
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.045),
                      child: Text(
                        "Don't have a account?",
                        style: GoogleFonts.roboto(
                          fontSize: textFactor * 14,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => const SignUpPage());
                        },
                        child: Text(
                          "Sign Up",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: textFactor * 15,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
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
              key: _formkey,
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
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xffE7EAF0),
                      ),
                      child: emailField,
                    ),
                    SizedBox(height: height * 0.02),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xffE7EAF0),
                      ),
                      child: passwordField,
                    ),
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
                      onTap: () {},
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
