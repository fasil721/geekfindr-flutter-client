import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  bool isVisible = true;
  final controller = Get.find<AppController>();
  @override
  void dispose() {
    passwordFocusNode.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (MediaQuery.of(context).viewInsets.bottom > 200) {
      isVisible = false;
      controller.update(["image"]);
    } else {
      isVisible = true;
      controller.update(["image"]);
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
          height: size.width * 0.118,
          width: size.width * 0.3,
          child: Center(
            child: Text(
              "Login",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: size.width * 0.04,
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
            bottom: size.height * .25,
            child: RotationTransition(
              turns: const AlwaysStoppedAnimation(-45 / 360),
              child: FadeInDown(
                duration: const Duration(milliseconds: 1500),
                delay: const Duration(milliseconds: 1500),
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
                  height: size.height * .95,
                  width: size.width * 1.5,
                ),
              ),
            ),
          ),
          GetBuilder<AppController>(
            id: "image",
            builder: (context) {
              return AnimatedOpacity(
                opacity: isVisible ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: FadeInDown(
                  duration: const Duration(milliseconds: 1500),
                  delay: const Duration(milliseconds: 1500),
                  child: Image.asset(
                    'assets/images/pair.png',
                    height: size.height * 0.4,
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: FadeInDown(
              duration: const Duration(milliseconds: 1500),
              delay: const Duration(milliseconds: 1500),
              child: Padding(
                padding: isVisible
                    ? EdgeInsets.zero
                    : EdgeInsets.only(top: size.height * .15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: isVisible
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Don't have a account?",
                        style: GoogleFonts.roboto(
                          fontSize: size.width * 0.037,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          "Sign Up",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: size.width * 0.035,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     SystemChannels.textInput.invokeMethod("TextInput.hide");
                    //     isVisible = true;
                    //     setState(() {});
                    //   },
                    //   child: FadeInDown(
                    //     duration: const Duration(milliseconds: 1500),
                    //     delay: const Duration(milliseconds: 1500),
                    //     child: Container(
                    //       width: size.width * 0.2,
                    //       margin: const EdgeInsets.only(right: 20),
                    //       decoration: BoxDecoration(
                    //         // border: Border.all(
                    //         //   width: 1.1,
                    //         //   color: Colors.white.withOpacity(0.9),
                    //         // ),
                    //         borderRadius: BorderRadius.circular(40),
                    //         color: const Color(0xffB954FE),
                    //       ),
                    //       child: Center(
                    //         child: Text(
                    //           "Sign Up",
                    //           textAlign: TextAlign.center,
                    //           style: GoogleFonts.roboto(
                    //             fontSize: size.width * 0.035,
                    //             color: Colors.white.withOpacity(0.9),
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: size.width * 0.075,
              right: size.width * 0.2,
              bottom: size.height * 0.05,
            ),
            child: Form(
              key: _formkey,
              child: FadeInUp(
                duration: const Duration(milliseconds: 1500),
                delay: const Duration(milliseconds: 1500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.height * 0.01),
                      child: Text(
                        "Sign In",
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * .075,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xffE7EAF0),
                      ),
                      child: emailField,
                    ),
                    SizedBox(height: size.height * 0.02),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xffE7EAF0),
                      ),
                      child: passwordField,
                    ),
                    SizedBox(height: size.height * 0.02),
                    loginButton,
                    SizedBox(height: size.height * 0.02),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.height * 0.005),
                      child: Text(
                        "Or Sing up with social platform",
                        style: GoogleFonts.roboto(
                          fontSize: size.width * .036,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: size.height * 0.005,
                        ),
                        child: Image.asset(
                          'assets/images/github.png',
                          height: size.height * 0.04,
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
