import 'package:flutter/material.dart';
import 'package:geek_findr/resources/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class NoConnectionScreen extends StatelessWidget {
  const NoConnectionScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/1_No Connection.png",
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 100,
            left: 30,
            child: ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all<double>(5),
                backgroundColor: MaterialStateProperty.all<Color>(white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () {},
              child: Text(
                "Retry",
                style: GoogleFonts.roboto(color: black),
              ),
            ),
          )
        ],
      ),
    );
  }
}
