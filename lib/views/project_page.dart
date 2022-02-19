import 'package:flutter/material.dart';
import 'package:geek_findr/contants.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({Key? key}) : super(key: key);

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: DefaultTabController(
        // initialIndex: 0,
        length: categories.length,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: TabBar(
            // isScrollable: true,
            indicatorColor: Colors.blue,
            physics: const BouncingScrollPhysics(),
            indicatorWeight: .0001,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            tabs: [
              ...categories.map(
                (element) => Container(
                  width: 90,
                  height: 75,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: categories[_currentIndex] == element
                        ? primaryColor
                        : Colors.white,
                    boxShadow: shadowList,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Tab(
                    child: Column(
                      children: [
                        Image.asset(
                          element["iconPath"] as String,
                          height: 30,
                          width: 30,
                          color: categories[_currentIndex] == element
                              ? Colors.white
                              : Colors.grey[700],
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          child: Text(
                            element['name'] as String,
                            style: GoogleFonts.poppins(
                              color: categories[_currentIndex] == element
                                  ? Colors.white
                                  : Colors.grey[700],
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
