import 'package:flutter/material.dart';
import 'package:fooddon/admin/adminhome.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminLogIn extends StatelessWidget {
  const AdminLogIn({Key? key}) : super(key: key);

  // Admin credentials
  final String adminEmail = 'projectfooddon@gmail.com';
  final String adminPassword = 'Fooddon@2024';

  // Function to handle admin login
  void _loginAdmin(String email, String password, BuildContext context) {
    if (email == adminEmail && password == adminPassword) {
      // If login is successful, navigate to the home screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AdminHome(),
        ),
      );
    } else {
      // Display error message using a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Admin email or password is incorrect.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 150),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Text(
                              'Admin Log In',
                              style: GoogleFonts.barlowSemiCondensed(
                                color: Colors.white,
                                fontSize: 30,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 56,
                            child: TextField(
                              controller: emailController,
                              style: GoogleFonts.barlowSemiCondensed(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle: GoogleFonts.barlowSemiCondensed(
                                  color: const Color(0xffCDFF01),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                ),
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
                                controller: passwordController,
                                obscureText: true,
                                style: GoogleFonts.barlowSemiCondensed(
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  hintStyle: GoogleFonts.barlowSemiCondensed(
                                    color: const Color(0xffCDFF01),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                  ),
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
                              // Retrieve email and password from text fields
                              String email = emailController.text;
                              String password = passwordController.text;

                              // Call login function with email and password
                              _loginAdmin(email, password, context);
                            },
                            child: Container(
                              height: 56,
                              width: 228,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/loginicon.png'),
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
