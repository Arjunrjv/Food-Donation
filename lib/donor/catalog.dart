import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:google_fonts/google_fonts.dart';

import '../home.dart';
import 'donorcharity.dart';

class Catalog extends StatefulWidget {
  const Catalog({Key? key}) : super(key: key);

  @override
  State<Catalog> createState() => _CatalogState();
}

class _CatalogState extends State<Catalog> {
  final CollectionReference item =
      FirebaseFirestore.instance.collection('required');

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _contributionController = TextEditingController();

  String _searchLocation = "";

  // Function to show the bottom sheet
  void _showContributionBottomSheet(
      BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      backgroundColor: Colors.black,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 400,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: ${item['name']}',
                    style: GoogleFonts.barlowSemiCondensed(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Quantity: ${item['quantity']}',
                    style: GoogleFonts.barlowSemiCondensed(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Expiry: ${item['expiry']}',
                    style: GoogleFonts.barlowSemiCondensed(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: TextField(
                      style:
                          GoogleFonts.barlowSemiCondensed(color: Colors.white),
                      controller: _contributionController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Contribution Quantity',
                        labelStyle: GoogleFonts.barlowSemiCondensed(
                            color: Colors.white),
                        hintStyle: GoogleFonts.barlowSemiCondensed(
                            color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffCDFF01),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      // Perform contribution logic here
                      int contributedQuantity =
                          int.tryParse(_contributionController.text) ?? 0;

                      int itemQuantity =
                          int.tryParse(item['quantity'].toString()) ?? 0;

                      // Update the quantity in the catalog page
                      int remainingQuantity =
                          itemQuantity - contributedQuantity;

                      if (remainingQuantity > 0) {
                        // If remaining quantity is greater than 0, update the item
                        // in the catalog with the new quantity
                        FirebaseFirestore.instance
                            .collection('required')
                            .doc(item['id'])
                            .update({'quantity': remainingQuantity});
                      } else {
                        // If remaining quantity is 0 or less, delete the item from the catalog
                        FirebaseFirestore.instance
                            .collection('required')
                            .doc(item['id'])
                            .delete();
                      }

                      _contributionController.text = "";

                      // Close the bottom sheet
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Contribute',
                      style: GoogleFonts.barlowSemiCondensed(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          toolbarHeight: 80,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              // Navigate to the home screen, replacing the current screen
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
            'Fooddon',
            style: GoogleFonts.barlowSemiCondensed(
              color: const Color(0xffCDFF01),
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TextField for searching
              TextField(
                controller: _searchController,
                style: GoogleFonts.barlowSemiCondensed(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter your location...',
                  hintStyle:
                      GoogleFonts.barlowSemiCondensed(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchLocation =
                        value; // Update the searchLocation variable
                  });
                },
              ),
              const SizedBox(height: 30),
              Text(
                'Available Distributors',
                style: GoogleFonts.barlowSemiCondensed(color: Colors.white),
              ),
              const SizedBox(height: 10),
              StreamBuilder(
                stream: item.orderBy('timestamp', descending: true).snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Some error occurred ${snapshot.error}'),
                    );
                  }
                  if (snapshot.hasData) {
                    QuerySnapshot querySnapshot = snapshot.data;
                    List<QueryDocumentSnapshot> documents = querySnapshot.docs;

                    List<Map<String, dynamic>> items = documents.map((e) {
                      Map<String, dynamic> data =
                          e.data() as Map<String, dynamic>;
                      data['id'] = e.id; // Add the document ID to the data
                      return data;
                    }).toList();

                    // Filter out and delete expired items
                    DateTime currentTime = DateTime.now();
                    items.forEach((item) async {
                      String expiryString = item['expiry'];

                      try {
                        DateTime expiryTime =
                            DateFormat('hh:mm a').parse(expiryString);

                        // Assuming that expiry date is set to today
                        expiryTime = DateTime(
                          currentTime.year,
                          currentTime.month,
                          currentTime.day,
                          expiryTime.hour,
                          expiryTime.minute,
                        );

                        if (expiryTime.isBefore(currentTime)) {
                          // Item has expired, delete it from Firebase
                          await FirebaseFirestore.instance
                              .collection('required')
                              .doc(item['id'])
                              .delete();

                          print('Deleted item with ID: ${item['id']}');
                          setState(() {
                            items.remove(item);
                          });

                          // Show a snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Item Expired'),
                            ),
                          );
                        }
                      } catch (e) {
                        print('Error parsing expiry time: $e');
                        // Skip items with invalid expiry format
                      }
                    });

                    // Filter out expired items for UI display
                    items = items.where((item) {
                      String expiryString = item['expiry'];

                      try {
                        DateTime expiryTime =
                            DateFormat('hh:mm a').parse(expiryString);

                        // Assuming that expiry date is set to today
                        expiryTime = DateTime(
                          currentTime.year,
                          currentTime.month,
                          currentTime.day,
                          expiryTime.hour,
                          expiryTime.minute,
                        );

                        return expiryTime.isAfter(currentTime);
                      } catch (e) {
                        print('Error parsing expiry time: $e');
                        return false; // Skip items with invalid expiry format
                      }
                    }).toList();

                    // Filter items based on the search location
                    items = items.where((item) {
                      return item['location']
                          .toLowerCase()
                          .contains(_searchLocation.toLowerCase());
                    }).toList();

                    if (items.isEmpty && _searchLocation.isNotEmpty) {
                      Future.delayed(Duration.zero, () {
                        _showNoDistributorsDialog(context);
                      });
                    }

                    return Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> thisItem = items[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                // Container with logo (you can replace this with your logo)
                                Container(
                                  width: 50, // Adjust the width as needed
                                  height: 80, // Adjust the height as needed
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    shape: BoxShape.rectangle,
                                    color: const Color(
                                        0xffCDFF01), // Change color as needed
                                  ),
                                  // Add your logo or image widget here
                                  child: const Icon(Icons.restaurant,
                                      color: Colors.black),
                                ),
                                const SizedBox(
                                    width:
                                        10), // Add spacing between logo and ListTile
                                // List tile
                                Container(
                                  height: 80,
                                  width: MediaQuery.of(context).size.width -
                                      80, // Adjust width
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.25),
                                        width: 1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    color: Colors.black.withOpacity(0.07),
                                  ),
                                  child: ListTile(
                                    horizontalTitleGap: 25,
                                    // leading: Text('${thisItem['name']}'),
                                    titleTextStyle:
                                        GoogleFonts.barlowSemiCondensed(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                    leadingAndTrailingTextStyle:
                                        GoogleFonts.barlowSemiCondensed(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    title: Text(
                                      'Name: ${thisItem['name']}\nNeeded quantity: ${thisItem['quantity']}',
                                    ),
                                    trailing: Text(
                                        'Expiry time: ${thisItem['expiry']}'),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            color: const Color(0xffCDFF01),
                                            size: 12,
                                          ),
                                          const SizedBox(width: 5),
                                          Text('${thisItem['location']}'),
                                        ],
                                      ),
                                    ),
                                    subtitleTextStyle:
                                        GoogleFonts.barlowSemiCondensed(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                    onTap: () {
                                      _showContributionBottomSheet(
                                          context, thisItem);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNoDistributorsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'No distributors found',
            style: GoogleFonts.barlowSemiCondensed(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Don\'t worry if your location doesn\'t have any distributors. You can contribute for charity.',
            style: GoogleFonts.barlowSemiCondensed(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.barlowSemiCondensed(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Navigate to the charity contribution page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CharityContributionPage(),
                  ),
                );
              },
              child: Text(
                'Contribute for Charity',
                style: GoogleFonts.barlowSemiCondensed(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
