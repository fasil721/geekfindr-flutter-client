import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/models/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

final box = Hive.box('usermodel');
Future<void> postImage() async {
  final user = box.get("user") as UserModel;
  final imagePicker = ImagePicker();

  final image = await imagePicker.pickImage(source: ImageSource.camera);
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

    const url =
        "$prodUrl/api/v1/uploads/signed-url?fileType=image&fileSubType=jpg";
    try {
      final response1 = await http.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer ${user.token}"},
      );
      final jsonData = json.decode(response1.body) as Map;
      final data = Signedurl.fromJson(jsonData.cast());
      final response2 = await http.put(
        Uri.parse(data.url!),
        body: croppedFile!.readAsBytesSync(),
        headers: {"Content-Type": "image/jpg"},
        // encoding: Encoding.getByName("utf-8"),
      );
  print(croppedFile.readAsBytesSync());
      print(response2.statusCode);
      print(data.key);
    
    } on HttpException {
      Fluttertoast.showToast(msg: "No Internet");
    } on SocketException {
      Fluttertoast.showToast(msg: "No Internet");
    } on PlatformException {
      Fluttertoast.showToast(msg: "Invalid Format");
    }
  }
}

class Signedurl {
  Signedurl({
    this.key,
    this.url,
  });

  String? key;
  String? url;

  factory Signedurl.fromJson(Map<String, String> json) => Signedurl(
        key: json["key"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "url": url,
      };
}
