import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fooddon/distributor/distributorlogin.dart';
import 'package:google_fonts/google_fonts.dart';

class DistributorSignup extends StatefulWidget {
  const DistributorSignup({Key? key}) : super(key: key);

  @override
  _DistributorSignupState createState() => _DistributorSignupState();
}

class _DistributorSignupState extends State<DistributorSignup> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _registerDistributor(
    String name,
    String location,
    String email,
    String password,
    BuildContext context,
  ) async {
    // Input validations
    if (name.isEmpty || location.isEmpty || email.isEmpty || password.isEmpty) {
      // Display a snackbar with an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('All fields must be filled.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check if the email is a valid Gmail address
    RegExp gmailRegex = RegExp(r'^[a-zA-Z0-9_.+-]+@gmail\.com$');
    if (!gmailRegex.hasMatch(email)) {
      // Display a snackbar with an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid Gmail address.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Register the user with Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add distributor information to Firestore "distributors" collection
      await FirebaseFirestore.instance
          .collection('distributors')
          .doc(userCredential.user!.uid)
          .set({
        'name': name,
        'location': location,
        'email': email,
        // Additional distributor information...
      });

      // Navigate to the distributor login screen after successful registration.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DistributorLogin(),
        ),
      );
    } catch (e) {
      // Display a snackbar with an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error registering distributor: $e'),
          backgroundColor: Colors.red,
        ),
      );
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
                              keyboardType: TextInputType.emailAddress,
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
                              // Register the distributor user
                              _registerDistributor(
                                // Get values from text fields
                                _nameController.text,
                                _locationController.text,
                                _emailController.text,
                                _passwordController.text,
                                context,
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
