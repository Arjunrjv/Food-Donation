import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fooddon/admin/adminhome.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class UserDonationAdmin extends StatefulWidget {
  const UserDonationAdmin({Key? key, required this.distributorName})
      : super(key: key);

  final String distributorName;

  @override
  State<UserDonationAdmin> createState() => _UserDonationAdminState();
}

class _UserDonationAdminState extends State<UserDonationAdmin> {
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var logger = Logger();

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      fetchAllDonations() async {
    try {
      // Check if user is not null
      if (user != null) {
        // Get the user's document
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
            .instance
            .collection('donations')
            .doc(user!.uid)
            .get();

        // Get the user's donations subcollection reference
        CollectionReference<Map<String, dynamic>> userDonationAdminRef =
            FirebaseFirestore.instance
                .collection('donations')
                .doc(user!.uid)
                .collection('userdonations');

        // Get all documents from the user's donations subcollection
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await userDonationAdminRef.get();

        List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
            querySnapshot.docs;

        logger.i('Number of documents: ${documents.length}');

        for (QueryDocumentSnapshot<Map<String, dynamic>> document
            in documents) {
          logger.i('Document ID: ${document.id}');
          logger.i('Document data: ${document.data()}');
        }

        return documents;
      } else {
        // Handle the case where user is null (e.g., show an error message)
        logger.e('Error: User is null');
        return [];
      }
    } catch (e) {
      logger.e('Error fetching all donations: $e');
      return [];
    }
  }

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

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminHome(),
              ),
            );
          },
        ),
        elevation: 0,
        title: Text(
          'Hi Admin',
          style: GoogleFonts.barlowSemiCondensed(
            color: const Color(0xffCDFF01),
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
          future: fetchAllDonations(),
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

            snapshot.data!.forEach((doc) {
              logger.i('Number of documents: ${snapshot.data!.length}');
              logger.i('Document ID: ${doc.id}');
              logger.i('Document data: ${doc.data()}');
            });

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final donations = snapshot.data![index].data();
                final name = donations['name'] ?? 'N/A';
                final quantity = donations['contributedQuantity'] ?? 'N/A';
                final timestamp = donations['timestamp'];
                final location = donations['location'] ?? 'N/A';
                final donorName = donations['donorName'] ?? 'N/A';
                final donorPhone = donations['donorNumber'] ?? 'N/A';
                final date = donations['date'] ?? 'N/A';

                // Convert timestamp to DateTime object
                DateTime dateTime = (timestamp as Timestamp).toDate();
                // Format DateTime object to display only the date
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(dateTime);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.25),
                        width: 1,
                      ),
                    ),
                    child: SizedBox(
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            date,
                            style: GoogleFonts.barlowSemiCondensed(
                              color: Colors.white,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                donorName,
                                style: GoogleFonts.barlowSemiCondensed(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Ph: $donorPhone',
                                style: GoogleFonts.barlowSemiCondensed(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '$name : $quantity',
                                style: GoogleFonts.barlowSemiCondensed(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            location,
                            style: GoogleFonts.barlowSemiCondensed(
                              color: Colors.white,
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
