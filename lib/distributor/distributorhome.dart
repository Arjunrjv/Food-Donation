import 'package:cloud_firestore/cloud_firestore.dart';
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
  User? user = FirebaseAuth.instance.currentUser;
  String? userName;

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('distributors')
          .doc(user!.uid)
          .get();

      setState(() {
        userName = userDoc['name'];
      });
    } catch (e) {
      print('Error fetching user name: $e');
    }
  }

  void _signOut(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Log out',
          style: GoogleFonts.barlowSemiCondensed(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: GoogleFonts.barlowSemiCondensed(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.barlowSemiCondensed(
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
            child: Text(
              'Log out',
              style: GoogleFonts.barlowSemiCondensed(
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
          elevation: 0,
          title: Text(
            'Hi ${userName ?? ''} (Distributor)',
            style: GoogleFonts.barlowSemiCondensed(
              color: const Color(0xffCDFF01),
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
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
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            shape: BoxShape.rectangle,
                            color: const Color(0xffCDFF01),
                          ),
                          child: const Icon(Icons.post_add_rounded,
                              color: Colors.black),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          alignment: Alignment.center,
                          height: 80,
                          width: 250,
                          decoration: const BoxDecoration(
                            color: Color(0xffCDFF01),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Add Requirements',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.barlowSemiCondensed(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
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
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            shape: BoxShape.rectangle,
                            color: const Color(0xffCDFF01),
                          ),
                          child: const Icon(Icons.preview_rounded,
                              color: Colors.black),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          alignment: Alignment.center,
                          height: 80,
                          width: 250,
                          decoration: const BoxDecoration(
                            color: Color(0xffCDFF01),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            'View and edit Requirements',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.barlowSemiCondensed(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
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
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            shape: BoxShape.rectangle,
                            color: const Color(0xffCDFF01),
                          ),
                          child: const Icon(Icons.food_bank_rounded,
                              color: Colors.black),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          alignment: Alignment.center,
                          height: 80,
                          width: 250,
                          decoration: const BoxDecoration(
                            color: Color(0xffCDFF01),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            'User Donations',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.barlowSemiCondensed(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: GestureDetector(
                    onTap: () => _signOut(context),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            shape: BoxShape.rectangle,
                            color: const Color(0xffCDFF01),
                          ),
                          child: const Icon(Icons.logout_rounded,
                              color: Colors.black),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          alignment: Alignment.center,
                          height: 80,
                          width: 250,
                          decoration: const BoxDecoration(
                            color: Color(0xffCDFF01),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            'LogOut',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.barlowSemiCondensed(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
