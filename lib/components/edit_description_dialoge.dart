import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/services/projectServices/project_model_classes.dart';
import 'package:geek_findr/views/project_list.dart';


class EditDescriptionDialoge extends StatefulWidget {
  const EditDescriptionDialoge({Key? key, required this.project})
      : super(key: key);
  final Project project;
  @override
  State<EditDescriptionDialoge> createState() => _EditDescriptionDialogeState();
}

class _EditDescriptionDialogeState extends State<EditDescriptionDialoge> {
  TextEditingController? descTextController;
  @override
  void initState() {
    super.initState();
    descTextController =
        TextEditingController(text: widget.project.description);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;
    // final textFactor = textfactorfind(MediaQuery.textScaleFactorOf(context));
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: width * 0.8,
          child: Material(
            borderRadius: BorderRadius.circular(
              20,
            ),
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(
                    10.0,
                  ),
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
                      fillColor: white,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(3),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(primaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (descTextController!.text.isNotEmpty) {
                      final body = {"description": descTextController!.text};
                      myProjects.editProjectDescription(
                        projectId: widget.project.id!,
                        body: body,
                      );
                    } else {
                      Fluttertoast.showToast(msg: "Field can't be empty");
                    }
                  },
                  child: const Text("Save"),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
