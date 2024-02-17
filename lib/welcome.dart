import 'package:flutter/material.dart';
import 'package:fooddon/donorselection.dart';
import 'package:fooddon/userselection.dart';
import 'package:google_fonts/google_fonts.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 34, bottom: 60),
                child: Text(
                  'fooddon',
                  style: GoogleFonts.barlowSemiCondensed(
                      color: Colors.white, fontSize: 20),
                ),
              ),
              Row(
                children: [
                  Text(
                    'INCREASE',
                    style: GoogleFonts.barlowSemiCondensed(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ' FOOD',
                    style: GoogleFonts.barlowSemiCondensed(
                        color: const Color(0xffCDFF01),
                        fontSize: 42,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                'DONATION',
                style: GoogleFonts.barlowSemiCondensed(
                    color: const Color(0xffCDFF01),
                    fontSize: 42,
                    fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text(
                    'BY',
                    style: GoogleFonts.barlowSemiCondensed(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ' CONNECTING',
                    style: GoogleFonts.barlowSemiCondensed(
                        color: const Color(0xffCDFF01),
                        fontSize: 42,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                'FOOD DONORS',
                style: GoogleFonts.barlowSemiCondensed(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'AND',
                style: GoogleFonts.barlowSemiCondensed(
                    color: const Color(0xffCDFF01),
                    fontSize: 42,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'DISTRIBUTORS',
                style: GoogleFonts.barlowSemiCondensed(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 121),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserSelectionPage(),
                      ),
                    );
                  },
                  child: Container(
                    height: 56,
                    width: 228,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/button.png'))),
                    child: const Text(''),
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    'Already have an account?',
                    style: GoogleFonts.barlowSemiCondensed(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DonorSelection(),
                        ),
                      );
                    },
                    child: Text(
                      'Login',
                      style: GoogleFonts.barlowSemiCondensed(
                          color: const Color(0xffCDFF01),
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
