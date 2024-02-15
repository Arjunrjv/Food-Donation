import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Text(
        'Admin page',
        style:
            GoogleFonts.barlowSemiCondensed(color: Colors.white, fontSize: 40),
      )),
    );
  }
}
