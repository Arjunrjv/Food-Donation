import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fooddon/welcome.dart';
import 'package:google_fonts/google_fonts.dart';

class DonorLogout extends StatefulWidget {
  DonorLogout({super.key});

  @override
  State<DonorLogout> createState() => _DonorLogoutState();
}

class _DonorLogoutState extends State<DonorLogout> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

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
            child: Text(
              'Log out',
              style: GoogleFonts.barlowSemiCondensed(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? userName;

  Future<void> fetchUserName() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('donors')
          .doc(user!.uid)
          .get();

      setState(() {
        userName = userDoc['name'];
      });
    } catch (e) {
      print('Error fetching user name: $e');
    }
  }

  Future<List<DocumentSnapshot>> fetchDonations() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('donations')
          .doc(user?.uid ?? '')
          .collection('userdonations')
          .orderBy('timestamp', descending: true)
          .get();
      return querySnapshot.docs;
    } catch (e) {
      print('Error fetching donations: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Welcome(),
              ),
            );
          },
        ),
        elevation: 0,
        title: Text(
          'Hi ${userName ?? ''}',
          style: GoogleFonts.barlowSemiCondensed(
            color: const Color(0xffCDFF01),
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(top: 500, left: 30),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _signOut(context),
              child: Container(
                alignment: Alignment.center,
                height: 100,
                width: 350,
                decoration: const BoxDecoration(
                  color: Color(0xffCDFF01),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Text(
                  'Log Out',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.barlowSemiCondensed(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
