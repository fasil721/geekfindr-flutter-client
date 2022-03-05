import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/services/postServices/posts.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class PostUploadDialoge extends StatelessWidget {
  PostUploadDialoge({
    Key? key,
    required this.image,
  }) : super(key: key);

  final descTextController = TextEditingController();
  final projTextController = TextEditingController();
  final controller = Get.find<AppController>();
  final postServices = PostServices();
  final File image;
  bool isProject = false;

  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textFactor = textfactorfind(MediaQuery.textScaleFactorOf(context));

    return GetBuilder<AppController>(
      id: "img",
      builder: (controller) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: height * 0.5,
              child: Material(
                color: white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Column(
                  children: [
                    SizedBox(height: height * 0.01),
                    Visibility(
                      visible: isProject,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          controller: projTextController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          maxLines: null,
                          minLines: 1,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Project Name",
                            filled: true,
                            fillColor: Colors.transparent,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: descTextController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        minLines: 1,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Description",
                          filled: true,
                          fillColor: Colors.transparent,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    Expanded(
                      child: Container(
                        color: secondaryColor,
                        height: height * 0.43,
                        child: Image.file(
                          image,
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Material(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Project",
                            style: GoogleFonts.roboto(
                              fontSize: textFactor * 16,
                              color: black.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Switch(
                            inactiveThumbColor: secondaryColor,
                            activeColor: primaryColor,
                            value: isProject,
                            onChanged: (val) {
                              isProject = val;
                              controller.update(["img"]);
                            },
                          )
                        ],
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(3),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(primaryColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (isProject) {
                            if (descTextController.text.isNotEmpty &&
                                projTextController.text.isNotEmpty) {
                              postServices.uploadImage(
                                description: descTextController.text,
                                image: image,
                                isProject: true,
                                projectName: projTextController.text,
                              );
                            } else {
                              Get.defaultDialog(
                                title: "Validation",
                                content: const Text("Field can't be empty"),
                                confirmTextColor: white,
                                buttonColor: primaryColor,
                                onConfirm: () {
                                  Get.back();
                                },
                              );
                            }
                          } else {
                            if (descTextController.text.isNotEmpty) {
                              postServices.uploadImage(
                                description: descTextController.text,
                                image: image,
                                isProject: false,
                              );
                            } else {
                              Get.defaultDialog(
                                title: "Validation",
                                content: const Text("Field can't be empty"),
                                confirmTextColor: white,
                                buttonColor: primaryColor,
                                onConfirm: () {
                                  Get.back();
                                },
                              );
                            }
                          }
                        },
                        child: const Text("Post"),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

Future<File?> pickImage({required ImageSource source}) async {
  final imagePicker = ImagePicker();
  final image = await imagePicker.pickImage(source: source);
  if (image != null) {
    final croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: const AndroidUiSettings(
        toolbarColor: primaryColor,
        toolbarWidgetColor: white,
        initAspectRatio: CropAspectRatioPreset.original,
        activeControlsWidgetColor: primaryColor,
        lockAspectRatio: false,
      ),
      iosUiSettings: const IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
    );
    return croppedFile;
  }
  return null;
}
