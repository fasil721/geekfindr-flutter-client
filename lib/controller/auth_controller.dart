import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geek_findr/resources/constants.dart';
import 'package:get/get.dart';

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
    if (emailError != null) {
      Fluttertoast.showToast(msg: emailError);
    } else if (passwordError != null) {
      Fluttertoast.showToast(msg: passwordError);
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
    if (usernameError != null) {
      Fluttertoast.showToast(msg: usernameError);
    } else if (emailError != null) {
      Fluttertoast.showToast(msg: emailError);
    } else if (passwordError != null) {
      Fluttertoast.showToast(msg: passwordError);
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
