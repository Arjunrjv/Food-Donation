import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class UserDonations extends StatefulWidget {
  const UserDonations({Key? key}) : super(key: key);

  @override
  State<UserDonations> createState() => _UserDonationsState();
}

class _UserDonationsState extends State<UserDonations> {
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
                final donorName = donations['donorName'] ?? 'N/A';
                final donorPhone = donations['donorNumber'] ?? 'N/A';

                // Convert timestamp to DateTime object
                DateTime dateTime = (timestamp as Timestamp).toDate();
                // Format DateTime object to display only the date
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(dateTime);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Colors.black.withOpacity(0.07),
                    ),
                    // child: ListTile(
                    //   title: Center(
                    //     child: Text(
                    //       '$name',
                    //       style: const TextStyle(fontSize: 20),
                    //     ),
                    //   ),
                    //   subtitle:
                    //       Center(child: Text('No of food packets: $quantity')),
                    //   leading: Text(formattedDate), // Display formatted date
                    //   trailing: Text(location),
                    // ),
                    child: Container(
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            formattedDate,
                            style: GoogleFonts.barlowSemiCondensed(
                              color: Colors.black,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                donorName,
                                style: GoogleFonts.barlowSemiCondensed(
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Ph: $donorPhone',
                                style: GoogleFonts.barlowSemiCondensed(
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                '$name : $quantity',
                                style: GoogleFonts.barlowSemiCondensed(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            location,
                            style: GoogleFonts.barlowSemiCondensed(
                              color: Colors.black,
                            ),
                          ),
                        ],
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
