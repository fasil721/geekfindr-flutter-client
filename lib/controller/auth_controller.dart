import 'package:flutter/material.dart';
import 'package:geek_findr/constants.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthController extends GetxController {
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final signUpEmailController = TextEditingController();
  final signUpPasswordController = TextEditingController();
  final signUpUserNameController = TextEditingController();

  void validateLogin() {
    String? emailError;
    String? passwordError;
    final regex = RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]");
    final regexpass = RegExp(r'^.{4,}$');

    if (!regex.hasMatch(loginEmailController.text)) {
      emailError = "Enter a valid email";
    }
    if (loginEmailController.text.isEmpty) {
      emailError = "Enter Your Email";
    }
    if (!regexpass.hasMatch(loginPasswordController.text)) {
      passwordError = "Enter Valid Password(Min. 4 Character)";
    }
    if (loginPasswordController.text.isEmpty) {
      passwordError = "Enter Your Password";
    }

    if (emailError != null || passwordError != null) {
      Get.defaultDialog(
        title: "Validation",
        content: Column(
          children: [
            if (emailError != null)
              Text(
                emailError,
                style: GoogleFonts.roboto(
                  color: Colors.red,
                ),
              ),
            const SizedBox(height: 5),
            if (passwordError != null)
              Text(
                passwordError,
                style: GoogleFonts.roboto(
                  color: Colors.red,
                ),
              ),
          ],
        ),
        confirm: ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("ok"),
        ),
      );
    }
    if (emailError == null && passwordError == null) {
      authServices.userSignIn(
        email: loginEmailController.text,
        password: loginPasswordController.text,
      );
    }
  }

  void validateSignUp() {
    String? emailError;
    String? passwordError;
    String? usernameError;
    final regex = RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]");
    final regexpass = RegExp(r'^.{4,}$');

    if (!regex.hasMatch(signUpEmailController.text)) {
      emailError = "Enter a valid email";
    }
    if (signUpEmailController.text.isEmpty) {
      emailError = "Enter Your Email";
    }
    if (!regexpass.hasMatch(signUpPasswordController.text)) {
      passwordError = "Enter Valid Password(Min. 4 Character)";
    }
    if (signUpPasswordController.text.isEmpty) {
      passwordError = "Enter Your Password";
    }
    if (!regexpass.hasMatch(signUpUserNameController.text)) {
      usernameError = "Enter username(Min. 4 Character)";
    }
    if (signUpUserNameController.text.isEmpty) {
      usernameError = "Enter Your username";
    }

    if (emailError != null || passwordError != null || usernameError != null) {
      Get.defaultDialog(
        title: "Validation",
        content: Column(
          children: [
            if (usernameError != null)
              Text(
                usernameError,
                style: GoogleFonts.roboto(
                  color: Colors.red,
                ),
              ),
            const SizedBox(height: 5),
            if (emailError != null)
              Text(
                emailError,
                style: GoogleFonts.roboto(
                  color: Colors.red,
                ),
              ),
            const SizedBox(height: 5),
            if (passwordError != null)
              Text(
                passwordError,
                style: GoogleFonts.roboto(
                  color: Colors.red,
                ),
              ),
          ],
        ),
        confirm: ElevatedButton(
          onPressed: () => Get.back(),
          child: const Text("ok"),
        ),
      );
    }
    if (emailError == null && passwordError == null && usernameError == null) {
      authServices.userSignUp(
        email: signUpEmailController.text,
        password: signUpPasswordController.text,
        username: signUpUserNameController.text,
      );
    }
  }
}
