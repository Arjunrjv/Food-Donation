import 'package:flutter/material.dart';
import 'package:fooddon/admin/adminlogin.dart';
import 'package:fooddon/distributor/distributorsignup.dart';
import 'package:fooddon/donor/donorsignup.dart';
import 'package:google_fonts/google_fonts.dart';

class UserSelectionPage extends StatelessWidget {
  const UserSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(top: 95, bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70),
              child: Image.asset('assets/mainlogo.png'),
            ),
            Text('Select user type',
                style: GoogleFonts.barlowSemiCondensed(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 50),
              child: Container(
                height: 400,
                width: 267,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                        width: 1,
                        color: const Color(0xffEAE5E5).withOpacity(0.25))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Container(
                          height: 68,
                          width: 74,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/Frame 141.png')),
                          )),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DonorSignup(),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 36),
                      child: GestureDetector(
                        child: Container(
                            height: 68,
                            width: 74,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/Frame 140.png')),
                            )),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DistributorSignup(),
                            ),
                          );
                        },
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                          height: 68,
                          width: 74,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/Frame 139.png')),
                          )),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdminLogIn(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
