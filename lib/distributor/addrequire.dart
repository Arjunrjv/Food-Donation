import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fooddon/distributor/distributorhome.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddRequire extends StatefulWidget {
  const AddRequire({Key? key}) : super(key: key);

  @override
  State<AddRequire> createState() => _AddRequireState();
}

class _AddRequireState extends State<AddRequire> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerQuantity = TextEditingController();
  final TextEditingController _controllerLocation = TextEditingController();

  GlobalKey<FormState> key = GlobalKey();

  CollectionReference required =
      FirebaseFirestore.instance.collection('required');
  CollectionReference dates = FirebaseFirestore.instance.collection('dates');

  late DateTime startDate = DateTime.now();
  late DateTime endDate = DateTime.now();

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now()
          .add(const Duration(days: 365)), // Adjust the range as needed
    );

    if (pickedDate != null) {
      setState(() {
        // Set the respective start or end date
        if (isStartDate) {
          startDate = pickedDate;
        } else {
          endDate = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Fooddon Distributor',
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
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _selectDate(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: const Color(0xffCDFF01),
                      ),
                      child: Text(
                        'Select Start Date',
                        style: GoogleFonts.barlowSemiCondensed(
                            color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _selectDate(context, false);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: const Color(0xffCDFF01),
                      ),
                      child: Text(
                        'Select End Date',
                        style: GoogleFonts.barlowSemiCondensed(
                            color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    height: 50,
                    width: 150,
                    child: FloatingActionButton.extended(
                      onPressed: () async {
                        if (key.currentState!.validate()) {
                          String itemName = _controllerName.text;
                          String itemQuantity = _controllerQuantity.text;
                          String itemLocation = _controllerLocation.text;

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
                            // await dates.doc(formattedDate).set({
                            //   'name': itemName,
                            //   'quantity': itemQuantity,
                            //   'location': itemLocation,
                            //   'timestamp': FieldValue.serverTimestamp(),
                            // });
                            await required.add({
                              'name': itemName,
                              'quantity': itemQuantity,
                              'location': itemLocation,
                              'dates': formattedDate,
                              'timestamp': FieldValue.serverTimestamp(),
                            });

                            datesBetween.add(formattedDate);
                          }

                          Navigator.pop(context);
                        }
                      },
                      label: Text(
                        'Upload',
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
