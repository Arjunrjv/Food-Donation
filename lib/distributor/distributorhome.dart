import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fooddon/distributor/addrequire.dart';
import 'package:fooddon/distributor/requirements.dart';
import 'package:fooddon/distributor/userdonations.dart';
import 'package:fooddon/welcome.dart';
import 'package:google_fonts/google_fonts.dart';

class DistributorHome extends StatefulWidget {
  const DistributorHome({super.key});

  @override
  State<DistributorHome> createState() => _DistributorHomeState();
}

class _DistributorHomeState extends State<DistributorHome> {
  void _signOut(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Log out',
          style: TextStyle(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const Welcome(),
                ),
              );
            },
            child: const Text(
              'Log out',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'Hi Distributor',
            style: GoogleFonts.barlowSemiCondensed(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddRequire(),
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 100,
                    width: 400,
                    decoration: const BoxDecoration(
                      color: Color(0xffCDFF01),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Add Requirements',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RequireEdit(),
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 100,
                    width: 400,
                    decoration: const BoxDecoration(
                      color: Color(0xffCDFF01),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'View and edit Requirements',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserDonations(),
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 100,
                    width: 400,
                    decoration: const BoxDecoration(
                      color: Color(0xffCDFF01),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'User Donations',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: GestureDetector(
                  onTap: () => _signOut(context),
                  child: Container(
                    alignment: Alignment.center,
                    height: 100,
                    width: 400,
                    decoration: const BoxDecoration(
                      color: Color(0xffCDFF01),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'LogOut',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 20),
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
