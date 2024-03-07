import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fooddon/distributor/distributorhome.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class EditRequirements extends StatefulWidget {
  final String documentId;

  const EditRequirements({Key? key, required this.documentId})
      : super(key: key);

  @override
  State<EditRequirements> createState() => _EditRequirementsState();
}

class _EditRequirementsState extends State<EditRequirements> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerQuantity = TextEditingController();
  final TextEditingController _controllerLocation = TextEditingController();
  final TextEditingController _controllerDate = TextEditingController();

  GlobalKey<FormState> key = GlobalKey();

  CollectionReference required =
      FirebaseFirestore.instance.collection('required');
  CollectionReference dates = FirebaseFirestore.instance.collection('dates');

  late DateTime startDate = DateTime.now();
  late DateTime endDate = DateTime.now();

  User? user = FirebaseAuth.instance.currentUser;
  String? userName;

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

  var logger = Logger();

  Future<void> _updateDocument(String documentId) async {
    try {
      // Update the document in the "required" collection using the provided documentId
      await required.doc(documentId).update({
        'name': _controllerName.text,
        'quantity': _controllerQuantity.text,
        'location': _controllerLocation.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      logger.i('Document updated successfully!');
    } catch (error) {
      logger.e('Error updating document: $error');
    }
  }

  // Method to fetch previously added requirements and populate the text controllers
  Future<void> _fetchPreviousRequirements() async {
    try {
      DocumentSnapshot documentSnapshot =
          await required.doc(widget.documentId).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        _controllerName.text = data['name'] ?? '';
        _controllerQuantity.text = data['quantity'].toString();
        _controllerLocation.text = data['location'] ?? '';
        _controllerDate.text = data['dates'] ?? '';
      }
    } catch (error) {
      logger.e('Error fetching document: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    // Call the method to fetch previous requirements when the widget initializes
    _fetchPreviousRequirements();
    fetchUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        // toolbarHeight: 20,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const DistributorHome(),
              ),
            );
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Form(
            key: key,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextFormField(
                    style: GoogleFonts.barlowSemiCondensed(
                        color: const Color(0xffCDFF01)),
                    controller: _controllerName,
                    decoration: InputDecoration(
                      labelText: "Food Item Name",
                      labelStyle: GoogleFonts.barlowSemiCondensed(
                          color: const Color(0xffCDFF01)),
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
                        borderSide: const BorderSide(color: Color(0xffCDFF01)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  style: GoogleFonts.barlowSemiCondensed(
                      color: const Color(0xffCDFF01)),
                  controller: _controllerQuantity,
                  decoration: InputDecoration(
                    labelText: "Quantity",
                    labelStyle: GoogleFonts.barlowSemiCondensed(
                        color: const Color(0xffCDFF01)),
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
                      borderSide: const BorderSide(color: Color(0xffCDFF01)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  style: GoogleFonts.barlowSemiCondensed(
                      color: const Color(0xffCDFF01)),
                  controller: _controllerLocation,
                  decoration: InputDecoration(
                    labelText: "Location",
                    labelStyle: GoogleFonts.barlowSemiCondensed(
                        color: const Color(0xffCDFF01)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Colors.white.withOpacity(0.25)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xffCDFF01)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  enabled: false,
                  style: GoogleFonts.barlowSemiCondensed(
                      color: const Color(0xffCDFF01)),
                  controller: _controllerDate,
                  decoration: InputDecoration(
                    labelText: "Date",
                    labelStyle: GoogleFonts.barlowSemiCondensed(
                        color: const Color(0xffCDFF01)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Colors.white.withOpacity(0.25)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xffCDFF01)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    height: 50,
                    width: 150,
                    child: FloatingActionButton.extended(
                      onPressed: () async {
                        if (key.currentState!.validate()) {
                          // Calculate the dates between startDate and endDate
                          List<String> datesBetween = [];
                          for (int i = 0;
                              i <= endDate.difference(startDate).inDays;
                              i++) {
                            DateTime dateToAdd =
                                startDate.add(Duration(days: i));
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(dateToAdd);

                            // Add the document to the "dates" collection
                            await dates.doc(formattedDate).set({
                              'name': _controllerName.text,
                              'quantity': _controllerQuantity.text,
                              'location': _controllerLocation.text,
                              'timestamp': FieldValue.serverTimestamp(),
                            });

                            datesBetween.add(formattedDate);
                          }

                          // Update the existing document with the new requirements
                          await _updateDocument(widget.documentId);

                          Navigator.pop(context);
                        }
                      },
                      label: Text(
                        'Edit',
                        style: GoogleFonts.barlowSemiCondensed(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      backgroundColor: const Color(0xffCDFF01),
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
