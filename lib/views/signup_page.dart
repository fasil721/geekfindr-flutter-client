import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final userNameController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final userNameFocusNode = FocusNode();
  bool isVisible = true;

  final controller = Get.find<AppController>();
  @override
  void dispose() {
    passwordFocusNode.dispose();
    emailFocusNode.dispose();
    userNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (MediaQuery.of(context).viewInsets.bottom > 200) {
      isVisible = false;
      controller.update(["img"]);
    } else {
      isVisible = true;
      controller.update(["img"]);
    } //second name field
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
              "Sign Up",
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
            bottom: size.height * .32,
            child: RotationTransition(
              turns: const AlwaysStoppedAnimation(-45 / 360),
              child: Hero(
                tag: "con",
                child: FadeInDown(
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
          ),
          GetBuilder<AppController>(
            id: "im",
            builder: (context) {
              return SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                  child: AnimatedOpacity(
                    opacity: isVisible ? 1 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Hero(
                      tag: "im",
                      child: FadeInDown(
                        child: Image.asset(
                          'assets/images/Pull.png',
                          height: size.height * 0.28,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.height * 0.01),
                      child: Text(
                        "Sign Up",
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * .075,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.0175),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xffE7EAF0),
                      ),
                      child: userNameField,
                    ),
                    SizedBox(height: size.height * 0.0175),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xffE7EAF0),
                      ),
                      child: emailField,
                    ),
                    SizedBox(height: size.height * 0.0175),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xffE7EAF0),
                      ),
                      child: passwordField,
                    ),
                    SizedBox(height: size.height * 0.0175),
                    loginButton,
                    SizedBox(height: size.height * 0.0175),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.height * 0.005),
                      child: Text(
                        "Or Sign up with social platform",
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
