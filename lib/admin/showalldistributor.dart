import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fooddon/admin/userdonationadmin.dart';
import 'package:fooddon/distributor/userdonations.dart';
import 'package:fooddon/donor/catalog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShowAllDistributor extends StatefulWidget {
  const ShowAllDistributor({Key? key}) : super(key: key);

  @override
  State<ShowAllDistributor> createState() => _ShowAllDistributorState();
}

class _ShowAllDistributorState extends State<ShowAllDistributor> {
  User? user = FirebaseAuth.instance.currentUser;
  String? userName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Hi Admin',
          style: GoogleFonts.barlowSemiCondensed(
            color: const Color(0xffCDFF01),
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              'All Distributors :',
              style: GoogleFonts.barlowSemiCondensed(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('distributors')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Using a Set to store unique distributor names
                final Set<String> uniqueDistributorNames = {};

                // Extracting distributor names from snapshot and adding to the set
                snapshot.data!.docs.forEach((doc) {
                  final distributorName = doc['name'] as String?;
                  if (distributorName != null && distributorName.isNotEmpty) {
                    uniqueDistributorNames.add(distributorName);
                  }
                });

                return ListView.builder(
                  itemCount: uniqueDistributorNames.length,
                  itemBuilder: (context, index) {
                    final distributorName =
                        uniqueDistributorNames.elementAt(index);
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black.withOpacity(0.07),
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xffCDFF01),
                            child: Icon(
                              Icons.corporate_fare_rounded,
                              color: Colors.black,
                            ),
                          ),
                          title: Text(
                            distributorName,
                            style: GoogleFonts.barlowSemiCondensed(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserDonationAdmin(
                                  distributorName: distributorName,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
