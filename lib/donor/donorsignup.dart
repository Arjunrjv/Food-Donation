import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fooddon/donor/donorlogin.dart';
import 'package:google_fonts/google_fonts.dart';

class DonorSignup extends StatefulWidget {
  const DonorSignup({Key? key}) : super(key: key);

  @override
  _DonorSignupState createState() => _DonorSignupState();
}

class _DonorSignupState extends State<DonorSignup> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _registerDonor(
    String name,
    String location,
    String email,
    String password,
  ) async {
    try {
      // Register the user with Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add donor information to Firestore "donors" collection
      await FirebaseFirestore.instance
          .collection('donors')
          .doc(userCredential.user!.uid)
          .set({
        'name': name,
        'location': location,
        'email': email,
        // Additional donor information...
      });

      // Navigate to the home screen after successful registration.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DonorLogin(),
        ),
      );
    } catch (e) {
      print('Error registering donor: $e');
      // Handle registration errors here.
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.25),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            'SIGN UP',
                            style: GoogleFonts.barlowSemiCondensed(
                                color: Colors.white, fontSize: 30),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 44,
                            ),
                            child: SizedBox(
                              height: 56,
                              child: TextField(
                                controller: _nameController,
                                style: GoogleFonts.barlowSemiCondensed(
                                    color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Name',
                                  hintStyle: GoogleFonts.barlowSemiCondensed(
                                      color: const Color(0xffCDFF01),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300),
                                  suffixIcon:
                                      Image.asset('assets/nameicon.png'),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: SizedBox(
                              height: 56,
                              child: TextField(
                                controller: _locationController,
                                style: GoogleFonts.barlowSemiCondensed(
                                    color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Location',
                                  hintStyle: GoogleFonts.barlowSemiCondensed(
                                      color: const Color(0xffCDFF01),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300),
                                  suffixIcon: Image.asset('assets/locicon.png'),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 56,
                            child: TextField(
                              controller: _emailController,
                              style: GoogleFonts.barlowSemiCondensed(
                                  color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle: GoogleFonts.barlowSemiCondensed(
                                    color: const Color(0xffCDFF01),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300),
                                suffixIcon: Image.asset('assets/emailicon.png'),
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: SizedBox(
                              height: 56,
                              child: TextField(
                                controller: _passwordController,
                                obscureText: true,
                                style: GoogleFonts.barlowSemiCondensed(
                                    color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  hintStyle: GoogleFonts.barlowSemiCondensed(
                                      color: const Color(0xffCDFF01),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300),
                                  suffixIcon:
                                      Image.asset('assets/passicon.png'),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Register the donor user
                              _registerDonor(
                                // Get values from text fields
                                _nameController.text,
                                _locationController.text,
                                _emailController.text,
                                _passwordController.text,
                              );
                            },
                            child: Container(
                              height: 56,
                              width: 228,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/signupicon.png'),
                                ),
                              ),
                              child: const Text(''),
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
      ),
    );
  }
}
