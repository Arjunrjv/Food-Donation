import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fooddon/donor/contribute.dart';
import 'package:fooddon/donor/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MyDonation extends StatefulWidget {
  const MyDonation({Key? key}) : super(key: key);

  @override
  State<MyDonation> createState() => _MyDonationState();
}

class _MyDonationState extends State<MyDonation> {
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String users = 'users';

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
                builder: (context) => const HomeScreen(),
              ),
            );
          },
        ),
        elevation: 0,
        title: Text(
          'Fooddon Donor',
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
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<DocumentSnapshot>>(
          future: fetchDonations(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No donations available.'));
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final donations =
                    snapshot.data![index].data() as Map<String, dynamic>;
                final name = donations['name'] ?? 'N/A';
                final quantity = donations['contributedQuantity'] ?? 'N/A';
                final timestamp = donations['timestamp'];
                final location = donations['location'] ?? 'N/A';
                final date = donations['date'] ?? 'N/A';

                // Convert timestamp to DateTime object
                DateTime dateTime = (timestamp as Timestamp).toDate();
                // Format DateTime object to display only the date
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(dateTime);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Options'),
                            content: const Text(
                                'Do you want to cancel or donate instead?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  // "Yes" option
                                  // Delete the document and add contributed quantity to quantity
                                  FirebaseFirestore.instance
                                      .collection('donations')
                                      .doc(user!.uid)
                                      .collection('userdonations')
                                      .doc(snapshot.data![index].id)
                                      .delete()
                                      .then((_) {
                                    FirebaseFirestore.instance
                                        .collection('required')
                                        .where('name',
                                            isEqualTo: snapshot.data![index]
                                                ['name'])
                                        .where('location',
                                            isEqualTo: snapshot.data![index]
                                                ['location'])
                                        .where('dates',
                                            isEqualTo: snapshot.data![index]
                                                ['date'])
                                        .get()
                                        .then((querySnapshot) {
                                      if (querySnapshot.docs.isNotEmpty) {
                                        // Update the quantity for the matching document
                                        FirebaseFirestore.instance
                                            .collection('required')
                                            .doc(querySnapshot.docs.first.id)
                                            .update({
                                          'quantity': FieldValue.increment(
                                              quantity as int),
                                        });
                                      }
                                    });
                                  });

                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: const Text(
                                  'Yes',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // "No" option
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: const Text(
                                  'No',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // "Contribute" option
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                  // Navigate to another page here
                                  // Replace the next line with your navigation logic
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Contribute(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Contribute',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // "Select Another Date" option
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                  // Navigate to date selection page here
                                  // Replace the next line with your navigation logic
                                  _selectAnotherDate(
                                      snapshot.data![index].id,
                                      snapshot.data![index]['name'],
                                      snapshot.data![index]['date'],
                                      quantity);
                                },
                                child: const Text(
                                  'Select Another Date',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: Colors.black.withOpacity(0.07),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.25),
                          width: 1,
                        ),
                      ),
                      child: ListTile(
                        title: Center(
                          child: Text(
                            '$name',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        subtitle: Center(
                            child: Text('No. of food packets: $quantity')),
                        leading: Text(date), // Display formatted date
                        trailing: Text(location),
                        leadingAndTrailingTextStyle:
                            GoogleFonts.barlowSemiCondensed(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        subtitleTextStyle: GoogleFonts.barlowSemiCondensed(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                        titleTextStyle: GoogleFonts.barlowSemiCondensed(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _selectAnotherDate(String donationId, String itemName,
      String currentSelectedDate, int currentQuantity) {
    // Fetch all documents from Firestore based on the itemName
    FirebaseFirestore.instance
        .collection('required')
        .where('name', isEqualTo: itemName)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        // Extract all dates from all documents
        List<String> allDates = [];

        querySnapshot.docs.forEach((doc) {
          var dates = doc['dates'];
          if (dates != null) {
            if (dates is String) {
              // If it's a single string, extract the date
              allDates.add(dates);
            } else if (dates is List) {
              // If it's a list, add each element to allDates
              allDates.addAll(dates.cast<String>());
            } else {
              // Handle unsupported types or missing data
              print("Unsupported data type for 'dates' field.");
            }
          }
        });

        // Show dialog with all available dates
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Select Another Date'),
              content: Column(
                children: allDates.map((date) {
                  return ListTile(
                    title: Text(date),
                    onTap: () {
                      print("Updating date to: $date");

                      // After the donation update is complete, retrieve the previous document
                      FirebaseFirestore.instance
                          .collection('required')
                          .where('name', isEqualTo: itemName)
                          .where('dates', isEqualTo: currentSelectedDate)
                          .get()
                          .then((querySnapshot) {
                        if (querySnapshot.docs.isNotEmpty) {
                          // Restore quantity for the old date
                          FirebaseFirestore.instance
                              .collection('required')
                              .doc(querySnapshot.docs.first.id)
                              .update({
                            'quantity': FieldValue.increment(currentQuantity),
                          }).then((_) {
                            print(
                                "Restoring quantity for $currentSelectedDate");
                          }).catchError((error) {
                            print("Error restoring quantity: $error");
                          });
                        } else {
                          print(
                              "Document not found for date: $currentSelectedDate");
                        }
                      }).catchError((error) {
                        print(
                            "Error retrieving document for date: $currentSelectedDate");
                      });

                      // Update the date for the donation
                      FirebaseFirestore.instance
                          .collection('donations')
                          .doc(user!.uid)
                          .collection('userdonations')
                          .doc(donationId)
                          .update({'date': date}).then((_) {
                        // Update quantity for the new date
                        FirebaseFirestore.instance
                            .collection('required')
                            .where('name', isEqualTo: itemName)
                            .where('dates', arrayContains: date)
                            .get()
                            .then((newDateQuerySnapshot) {
                          if (newDateQuerySnapshot.docs.isNotEmpty) {
                            FirebaseFirestore.instance
                                .collection('required')
                                .doc(newDateQuerySnapshot.docs.first.id)
                                .update({
                              'quantity':
                                  FieldValue.increment(-currentQuantity),
                            }).then((_) {
                              print("Updating quantity for $date");
                            }).catchError((error) {
                              print(
                                  "Error updating quantity for $date: $error");
                            });
                          } else {
                            print("Document not found for date: $date");
                          }
                        }).catchError((error) {
                          print("Error retrieving document for date: $date");
                        });

                        Navigator.of(context).pop(); // Close the dialog
                      }).catchError((error) {
                        print("Error updating date: $error");
                      });
                    },
                  );
                }).toList(),
              ),
            );
          },
        );
      }
    });
  }
}
