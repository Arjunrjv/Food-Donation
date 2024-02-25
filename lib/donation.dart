// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class MyDonation extends StatefulWidget {
//   const MyDonation({super.key});

//   @override
//   State<MyDonation> createState() => _MyDonationState();
// }

// class _MyDonationState extends State<MyDonation> {
//   User? user = FirebaseAuth.instance.currentUser;
//   FirebaseFirestore firestore = FirebaseFirestore.instance;

//   String users = 'users';
//   Future<List<DocumentSnapshot>> fetchDonations() async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('donations')
//           .doc(user?.uid ?? '')
//           .collection('userdonations')
//           .orderBy('timestamp', descending: true)
//           .get();
//       return querySnapshot.docs;
//     } catch (e) {
//       print('Error fetching planted trees: $e');
//       return [];
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Hi Donor',
//           style: GoogleFonts.barlowSemiCondensed(
//             color: Colors.black,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10),
//         child: FutureBuilder<List<DocumentSnapshot>>(
//           future: fetchDonations(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             }
//             if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return const Center(child: Text('No donations available.'));
//             }

//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 final donations =
//                     snapshot.data![index].data() as Map<String, dynamic>;
//                 final name = donations['name'] ?? 'N/A';
//                 final quantity = donations['contributedQuantity'] ?? 'N/A';
//                 final date = donations['date'] ?? 'N/A';
//                 final location = donations['location'] ?? 'N/A';

//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 10),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: const BorderRadius.all(Radius.circular(20)),
//                       color: Colors.black.withOpacity(0.07),
//                     ),
//                     child: ListTile(
//                       title: Center(
//                           child: Text(
//                         '$name',
//                         style: const TextStyle(fontSize: 20),
//                       )),
//                       subtitle: Center(child: Text('$quantity')),
//                       leading: Text(date),
//                       trailing: Text(location),
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';

// class MyDonation extends StatefulWidget {
//   const MyDonation({Key? key}) : super(key: key);

//   @override
//   State<MyDonation> createState() => _MyDonationState();
// }

// class _MyDonationState extends State<MyDonation> {
//   User? user = FirebaseAuth.instance.currentUser;
//   FirebaseFirestore firestore = FirebaseFirestore.instance;

//   String users = 'users';
//   Future<List<DocumentSnapshot>> fetchDonations() async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('donations')
//           .doc(user?.uid ?? '')
//           .collection('userdonations')
//           .orderBy('timestamp', descending: true)
//           .get();
//       return querySnapshot.docs;
//     } catch (e) {
//       print('Error fetching donations: $e');
//       return [];
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Hi Donor',
//           style: GoogleFonts.barlowSemiCondensed(
//             color: Colors.black,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10),
//         child: FutureBuilder<List<DocumentSnapshot>>(
//           future: fetchDonations(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             }
//             if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return const Center(child: Text('No donations available.'));
//             }

//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 final donations =
//                     snapshot.data![index].data() as Map<String, dynamic>;
//                 final name = donations['name'] ?? 'N/A';
//                 final quantity = donations['contributedQuantity'] ?? 'N/A';
//                 final timestamp = donations['timestamp'];
//                 final location = donations['location'] ?? 'N/A';

//                 // Convert timestamp to DateTime object
//                 DateTime dateTime = (timestamp as Timestamp).toDate();
//                 // Format DateTime object to display only the date
//                 String formattedDate =
//                     DateFormat('yyyy-MM-dd').format(dateTime);

//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 10),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: const BorderRadius.all(Radius.circular(20)),
//                       color: Colors.black.withOpacity(0.07),
//                     ),
//                     child: ListTile(
//                       title: Center(
//                         child: Text(
//                           '$name',
//                           style: const TextStyle(fontSize: 20),
//                         ),
//                       ),
//                       subtitle:
//                           Center(child: Text('No. of food packets: $quantity')),
//                       leading: Text(formattedDate), // Display formatted date
//                       trailing: Text(location),
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fooddon/donor/contribute.dart';
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
        title: Text(
          'Hi Donor',
          style: GoogleFonts.barlowSemiCondensed(
            color: Colors.black,
          ),
        ),
      ),
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
                                        .doc(snapshot.data![index]['itemId'])
                                        .update({
                                      'quantity':
                                          FieldValue.increment(quantity as int),
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
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        color: Colors.black.withOpacity(0.07),
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
                        leading: Text(formattedDate), // Display formatted date
                        trailing: Text(location),
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
}
