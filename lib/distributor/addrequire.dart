import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddRequire extends StatefulWidget {
  const AddRequire({super.key});

  @override
  State<AddRequire> createState() => _DistributorHomeState();
}

class _DistributorHomeState extends State<AddRequire> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerQuantity = TextEditingController();
  final TextEditingController _controllerExpiry = TextEditingController();
  final TextEditingController _controllerLocation = TextEditingController();

  GlobalKey<FormState> key = GlobalKey();

  CollectionReference required =
      FirebaseFirestore.instance.collection('required');

  String imageUrl = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: key,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: TextFormField(
                    controller: _controllerName,
                    decoration: InputDecoration(
                      labelText: "Food Item Name",
                      labelStyle: GoogleFonts.barlowSemiCondensed(
                          color: Color(0xffCDFF01)),
                      hintStyle: GoogleFonts.barlowSemiCondensed(
                          color: Colors.white,
                          fontWeight:
                              FontWeight.w500), // Adjust opacity as needed
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.white.withOpacity(0.25)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xffCDFF01)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _controllerQuantity,
                  decoration: InputDecoration(
                    labelText: "Quantity",
                    labelStyle: GoogleFonts.barlowSemiCondensed(
                        color: Color(0xffCDFF01)),
                    hintStyle: GoogleFonts.barlowSemiCondensed(
                        color: Colors.white,
                        fontWeight:
                            FontWeight.w500), // Adjust opacity as needed
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Colors.white.withOpacity(0.25)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xffCDFF01)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _controllerExpiry,
                  decoration: InputDecoration(
                    labelText: "Expiry time",
                    labelStyle: GoogleFonts.barlowSemiCondensed(
                        color: Color(0xffCDFF01)),
                    hintStyle: GoogleFonts.barlowSemiCondensed(
                        color: Colors.white,
                        fontWeight:
                            FontWeight.w500), // Adjust opacity as needed
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Colors.white.withOpacity(0.25)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xffCDFF01)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _controllerLocation,
                  decoration: InputDecoration(
                    labelText: "Location",
                    labelStyle: GoogleFonts.barlowSemiCondensed(
                        color: Color(0xffCDFF01)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Colors.white.withOpacity(0.25)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xffCDFF01)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 60,
                  width: 380,
                  child: FloatingActionButton.extended(
                    onPressed: () async {
                      if (key.currentState!.validate()) {
                        String itemName = _controllerName.text;
                        String itemQuantity = _controllerQuantity.text;
                        String itemExpiry = _controllerExpiry.text;
                        String itemLocation = _controllerLocation.text;

                        required.add({
                          'name': itemName,
                          'quantity': itemQuantity,
                          'expiry': itemExpiry,
                          'location': itemLocation,
                          'timestamp': FieldValue.serverTimestamp(),
                        });
                      }
                      Navigator.pop(context);
                    },
                    label: const Text(
                      'Upload',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                    backgroundColor: const Color(0xffCDFF01),
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
