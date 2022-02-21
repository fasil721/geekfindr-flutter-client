import 'package:flutter/material.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/services/projects.dart';
import 'package:geek_findr/widgets/feed_list.dart';

class MyProjectList extends StatefulWidget {
  const MyProjectList({Key? key}) : super(key: key);

  @override
  _MyProjectListState createState() => _MyProjectListState();
}

final myProjects = ProjectServices();

class _MyProjectListState extends State<MyProjectList> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: white,
      ),
      body: FutureBuilder<List<ProjectListModel>?>(
        future: myProjects.getMyProjects(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return skeleton(width);
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data != null) {
              final datas = snapshot.data!;
              return ListView.builder(
                itemCount: datas.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    color: white,
                    child: Row(
                      children: [
                        Expanded(child: Container()),
                        Expanded(
                          child: Center(
                            child: Text(datas[index].project!.name!),
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            }
          }
          return const SizedBox();
        },
      ),
    );
  }
}
