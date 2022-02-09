import 'package:flutter/material.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:get/get.dart';

class PostUploadDialoge extends StatelessWidget {
  PostUploadDialoge({Key? key}) : super(key: key);
  final descTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textFactor = textfactorfind(MediaQuery.textScaleFactorOf(context));
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 50,
      ),
      height: 200,
      color: secondaryColor,
      child: Column(
        children: [
          Container(
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 0.9, color: Colors.grey),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: GetBuilder<AppController>(
              builder: (controller) {
                return Column(
                  children: [
                    TextField(
                      controller: descTextController,
                      decoration: InputDecoration(
                        hintText: "Type here",
                        hintStyle: TextStyle(
                          fontSize: textFactor * 15,
                        ),
                        iconColor: primaryColor,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
