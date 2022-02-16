import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/services/posts.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class PostUploadDialoge extends StatelessWidget {
  PostUploadDialoge({Key? key}) : super(key: key);
  final descTextController = TextEditingController();
  File? image;
  final controller = Get.find<AppController>();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textFactor = textfactorfind(MediaQuery.textScaleFactorOf(context));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GetBuilder<AppController>(
          id: "img",
          builder: (controller) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              color: Colors.white,
              height: height * 0.5,
              child: Material(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: descTextController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        minLines: 1,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Description",
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                      Visibility(
                        visible: image != null,
                        child: SizedBox(
                          height: height * 0.43,
                          child: image != null
                              ? Image.file(
                                  image!,
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                )
                              : const SizedBox(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Material(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        image = await pickImage(source: ImageSource.gallery);
                        controller.update(["img"]);
                      },
                      icon: const Icon(Icons.image),
                    ),
                    IconButton(
                      onPressed: () async {
                        image = await pickImage(source: ImageSource.camera);
                        controller.update(["img"]);
                      },
                      icon: const Icon(Icons.camera),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      if (descTextController.text.isNotEmpty && image != null) {
                        uploadImage(
                          description: descTextController.text,
                          image: image!,
                        );
                      }
                    },
                    child: const Text("Post"),
                  ),
                )
              ],
            ),
          ),
        )
      ],
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
        toolbarTitle: 'Cropper',
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
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
