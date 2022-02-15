import 'package:flutter/material.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/services/posts.dart';
import 'package:get/get.dart';

class PostEditDialoge extends StatefulWidget {
  const PostEditDialoge({
    Key? key,
    required this.imageModel,
  }) : super(key: key);
  final ImageModel imageModel;

  @override
  State<PostEditDialoge> createState() => _PostEditDialogeState();
}

class _PostEditDialogeState extends State<PostEditDialoge> {
  TextEditingController? descTextController;
  @override
  void initState() {
    super.initState();
    descTextController =
        TextEditingController(text: widget.imageModel.description);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GetBuilder<AppController>(
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
                      SizedBox(
                        height: height * 0.43,
                        child: Image.network(
                          widget.imageModel.mediaUrl!,
                          width: double.infinity,
                          fit: BoxFit.fitHeight,
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
                        // image = await pickImage(source: ImageSource.gallery);
                        // controller.update(["img"]);
                      },
                      icon: const Icon(Icons.image),
                    ),
                    IconButton(
                      onPressed: () async {
                        // image = await pickImage(source: ImageSource.camera);
                        // controller.update(["img"]);
                      },
                      icon: const Icon(Icons.camera),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      if (descTextController!.text.isNotEmpty &&
                          descTextController!.text !=
                              widget.imageModel.description) {
                        final body = {"description": descTextController!.text};
                        editImage(imageId: widget.imageModel.id!, body: body);
                      }
                    },
                    child: const Text("Save"),
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
