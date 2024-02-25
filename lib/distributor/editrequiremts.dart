// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';

// class EditRequirements extends StatefulWidget {
//   const EditRequirements({Key? key}) : super(key: key);

//   @override
//   State<EditRequirements> createState() => _AddRequireState();
// }

// class _AddRequireState extends State<EditRequirements> {
//   final TextEditingController _controllerName = TextEditingController();
//   final TextEditingController _controllerQuantity = TextEditingController();
//   final TextEditingController _controllerExpiry = TextEditingController();
//   final TextEditingController _controllerLocation = TextEditingController();

//   GlobalKey<FormState> key = GlobalKey();

//   CollectionReference required =
//       FirebaseFirestore.instance.collection('required');

//   Future<void> _selectTime(BuildContext context) async {
//     DateTime? pickedDateTime = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate:
//           DateTime.now().add(Duration(days: 365)), // Adjust the range as needed
//     );

//     if (pickedDateTime != null) {
//       TimeOfDay? pickedTime = await showTimePicker(
//         context: context,
//         initialEntryMode: TimePickerEntryMode.inputOnly,
//         initialTime: TimeOfDay.now(),
//       );

//       if (pickedTime != null) {
//         setState(() {
//           // Combine the picked date and time into a single DateTime object
//           DateTime combinedDateTime = DateTime(
//             pickedDateTime.year,
//             pickedDateTime.month,
//             pickedDateTime.day,
//             pickedTime.hour,
//             pickedTime.minute,
//           );

//           // Format the combined DateTime and set it to the text field
//           _controllerExpiry.text =
//               DateFormat('yyyy-MM-dd hh:mm a').format(combinedDateTime);
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(15),
//           child: Form(
//             key: key,
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 50),
//                   child: TextFormField(
//                     style: GoogleFonts.barlowSemiCondensed(
//                         color: Color(0xffCDFF01)),
//                     controller: _controllerName,
//                     decoration: InputDecoration(
//                       labelText: "Food Item Name",
//                       labelStyle: GoogleFonts.barlowSemiCondensed(
//                           color: Color(0xffCDFF01)),
//                       hintStyle: GoogleFonts.barlowSemiCondensed(
//                           color: Colors.white,
//                           fontWeight:
//                               FontWeight.w500), // Adjust opacity as needed
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide:
//                             BorderSide(color: Colors.white.withOpacity(0.25)),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(color: Color(0xffCDFF01)),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 TextFormField(
//                   style:
//                       GoogleFonts.barlowSemiCondensed(color: Color(0xffCDFF01)),
//                   controller: _controllerQuantity,
//                   decoration: InputDecoration(
//                     labelText: "Quantity",
//                     labelStyle: GoogleFonts.barlowSemiCondensed(
//                         color: Color(0xffCDFF01)),
//                     hintStyle: GoogleFonts.barlowSemiCondensed(
//                         color: Colors.white,
//                         fontWeight:
//                             FontWeight.w500), // Adjust opacity as needed
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide:
//                           BorderSide(color: Colors.white.withOpacity(0.25)),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide(color: Color(0xffCDFF01)),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 TextFormField(
//                   style:
//                       GoogleFonts.barlowSemiCondensed(color: Color(0xffCDFF01)),
//                   keyboardType: TextInputType.datetime,
//                   controller: _controllerExpiry,
//                   decoration: InputDecoration(
//                     labelText: "Expiry time",

//                     labelStyle: GoogleFonts.barlowSemiCondensed(
//                         color: Color(0xffCDFF01)),
//                     hintStyle: GoogleFonts.barlowSemiCondensed(
//                         color: Colors.white,
//                         fontWeight:
//                             FontWeight.w500), // Adjust opacity as needed
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide:
//                           BorderSide(color: Colors.white.withOpacity(0.25)),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide(color: Color(0xffCDFF01)),
//                     ),
//                     suffixIcon: IconButton(
//                       icon: const Icon(
//                         Icons.access_time,
//                         color: Colors.white,
//                       ),
//                       onPressed: () {
//                         _selectTime(context);
//                       },
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 TextFormField(
//                   style:
//                       GoogleFonts.barlowSemiCondensed(color: Color(0xffCDFF01)),
//                   controller: _controllerLocation,
//                   decoration: InputDecoration(
//                     labelText: "Location",
//                     labelStyle: GoogleFonts.barlowSemiCondensed(
//                         color: Color(0xffCDFF01)),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide:
//                           BorderSide(color: Colors.white.withOpacity(0.25)),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide(color: Color(0xffCDFF01)),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 SizedBox(
//                   height: 60,
//                   width: 380,
//                   child: FloatingActionButton.extended(
//                     onPressed: () async {
//                       if (key.currentState!.validate()) {
//                         String itemName = _controllerName.text;
//                         String itemQuantity = _controllerQuantity.text;
//                         String itemExpiry = _controllerExpiry.text;
//                         String itemLocation = _controllerLocation.text;

//                         required.add({
//                           'name': itemName,
//                           'quantity': itemQuantity,
//                           'expiry': itemExpiry,
//                           'location': itemLocation,
//                           'timestamp': FieldValue.serverTimestamp(),
//                         });
//                       }
//                       Navigator.pop(context);
//                     },
//                     label: const Text(
//                       'Upload',
//                       style: TextStyle(
//                           color: Colors.black, fontWeight: FontWeight.w500),
//                     ),
//                     backgroundColor: const Color(0xffCDFF01),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EditRequirements extends StatefulWidget {
  const EditRequirements({Key? key}) : super(key: key);

  @override
  State<EditRequirements> createState() => _AddRequireState();
}

class _AddRequireState extends State<EditRequirements> {
  User? user = FirebaseAuth.instance.currentUser;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String users = 'users';
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerQuantity = TextEditingController();
  final TextEditingController _controllerExpiry = TextEditingController();
  final TextEditingController _controllerLocation = TextEditingController();

  GlobalKey<FormState> key = GlobalKey();

  CollectionReference required =
      FirebaseFirestore.instance.collection('required');

  @override
  void initState() {
    super.initState();
    // Load existing data from Firestore when the widget initializes
    loadDataFromFirestore();
  }

  Future<void> loadDataFromFirestore() async {
    // Fetch the document data from Firestore
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('required')
        .doc('your_document_id')
        .get();

    // Extract data from the document snapshot
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

    // Set the initial values of the text controllers
    setState(() {
      _controllerName.text = data['name'];
      _controllerQuantity.text = data['quantity'];
      _controllerExpiry.text = data['expiry'];
      _controllerLocation.text = data['location'];
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate:
          DateTime.now().add(Duration(days: 365)), // Adjust the range as needed
    );

    if (pickedDateTime != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialEntryMode: TimePickerEntryMode.inputOnly,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          // Combine the picked date and time into a single DateTime object
          DateTime combinedDateTime = DateTime(
            pickedDateTime.year,
            pickedDateTime.month,
            pickedDateTime.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          // Format the combined DateTime and set it to the text field
          _controllerExpiry.text =
              DateFormat('yyyy-MM-dd hh:mm a').format(combinedDateTime);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String userId = '';
    if (user != null) {
      userId = user?.uid ?? '';
    }
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
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.datetime,
                  controller: _controllerExpiry,
                  decoration: InputDecoration(
                    labelText: "Expiry time",
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.access_time,
                      ),
                      onPressed: () {
                        _selectTime(context);
                      },
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

                        // Update the existing data in Firestore
                        await required.doc('your_document_id').update({
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
                    ),
                    backgroundColor: Colors.blue,
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
