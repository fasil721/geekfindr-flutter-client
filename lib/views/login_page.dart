import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  void dispose() {
    passwordFocusNode.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

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

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(40),
      color: const Color(0xffB954FE),
      child: MaterialButton(
        minWidth: size.width * 0.3,
        onPressed: () {
          SystemChannels.textInput.invokeMethod("TextInput.hide");
        },
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
    );

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          left: size.width * 0.075,
          right: size.width * 0.2,
          bottom: size.height * 0.05,
        ),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.height * 0.01),
                child: Text(
                  "Sign In",
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
                padding: EdgeInsets.symmetric(horizontal: size.height * 0.005),
                child: Text(
                  "Or Sing up with social platform",
                  style: GoogleFonts.roboto(
                    fontSize: size.width * .036,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.0175),
              GestureDetector(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: size.height * 0.005),
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
    );
  }
}
