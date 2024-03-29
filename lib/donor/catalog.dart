import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'home.dart';

class Catalog extends StatefulWidget {
  final String distributorName;

  const Catalog({Key? key, required this.distributorName}) : super(key: key);

  @override
  State<Catalog> createState() => _CatalogState();
}

class _CatalogState extends State<Catalog> with TickerProviderStateMixin {
  User? user = FirebaseAuth.instance.currentUser;
  String? userName;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late TabController _tabController;
  final CollectionReference item =
      FirebaseFirestore.instance.collection('required');
  final CollectionReference donations =
      FirebaseFirestore.instance.collection('donations');

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _contributionController = TextEditingController();
  final TextEditingController _donorNameController = TextEditingController();
  final TextEditingController _donorNumberController = TextEditingController();

  String _searchLocation = "";

  String? distributorName;

  Future<void> fetchUserData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('donors')
          .doc(user!.uid)
          .get();

      // Set the retrieved user data to the controllers
      setState(() {
        _donorNameController.text = userDoc['name'];
        _donorNumberController.text = userDoc['phone'];
      });
    } catch (e) {
      logger.e('Error fetching user data: $e');
    }
  }

  // Function to show the bottom sheet
  void _showContributionBottomSheet(
    BuildContext context,
    Map<String, dynamic> item,
    String userName,
  ) {
    fetchUserData();
    showModalBottomSheet(
      backgroundColor: Colors.black,
      context: context,
      builder: (context) {
        return Builder(
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  height: 600,
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
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Quantity: ${item['quantity']}',
                        style: GoogleFonts.barlowSemiCondensed(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                        child: TextField(
                          enabled: false,
                          style: GoogleFonts.barlowSemiCondensed(
                            color: Colors.white,
                          ),
                          controller: _donorNameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            labelStyle: GoogleFonts.barlowSemiCondensed(
                              color: Colors.white,
                            ),
                            hintStyle: GoogleFonts.barlowSemiCondensed(
                              color: Colors.white,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: TextField(
                          enabled: false,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(
                                10), // Limit to 10 characters
                            FilteringTextInputFormatter
                                .digitsOnly, // Allow only digits
                          ],
                          style: GoogleFonts.barlowSemiCondensed(
                            color: Colors.white,
                          ),
                          controller: _donorNumberController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Phone number',
                            labelStyle: GoogleFonts.barlowSemiCondensed(
                              color: Colors.white,
                            ),
                            hintStyle: GoogleFonts.barlowSemiCondensed(
                              color: Colors.white,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 20),
                        child: TextField(
                          style: GoogleFonts.barlowSemiCondensed(
                            color: Colors.white,
                          ),
                          controller: _contributionController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Contribution Quantity',
                            labelStyle: GoogleFonts.barlowSemiCondensed(
                              color: Colors.white,
                            ),
                            hintStyle: GoogleFonts.barlowSemiCondensed(
                              color: Colors.white,
                            ),
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
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          // Check if any of the text fields are empty
                          if (_donorNameController.text.isEmpty ||
                              _donorNumberController.text.isEmpty ||
                              _contributionController.text.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Warning'),
                                  content:
                                      const Text('Please fill all the fields'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'OK',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                            return; // Don't proceed if any field is empty
                          }

                          // Check if the phone number has exactly 10 digits
                          if (_donorNumberController.text.length != 10 ||
                              !RegExp(r'^[0-9]+$')
                                  .hasMatch(_donorNumberController.text)) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Warning'),
                                  content: const Text(
                                      'Please enter a valid 10-digit phone number'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'OK',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                            return; // Don't proceed if phone number is not valid
                          }

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
                            await FirebaseFirestore.instance
                                .collection('required')
                                .doc(item['id'])
                                .update({'quantity': remainingQuantity});
                          } else {
                            // If remaining quantity is 0 or less, delete the item from the catalog
                            await FirebaseFirestore.instance
                                .collection('required')
                                .doc(item['id'])
                                .delete();
                          }

                          String userId = user!.uid;
                          String currentDate = DateTime.now().toIso8601String();

                          // Store donation information in Firestore with user ID as document ID
                          await FirebaseFirestore.instance
                              .collection('donations')
                              .doc(userId)
                              .collection('userdonations')
                              .add({
                            'userId': userId,
                            'distributorName': distributorName,
                            'donorName': _donorNameController.text,
                            'donorNumber': _donorNumberController.text,
                            'name': item['name'],
                            'contributedQuantity': contributedQuantity,
                            'location': item['location'],
                            'date': item['dates'],
                            'timestamp': FieldValue.serverTimestamp(),
                          });

                          _contributionController.clear();
                          _donorNameController.clear();
                          _donorNumberController.clear();

                          // Close the bottom sheet
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Contribute',
                          style: GoogleFonts.barlowSemiCondensed(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  var logger = Logger();

  Future<void> fetchUserName() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('donors')
          .doc(user!.uid)
          .get();

      setState(() {
        userName = userDoc['name'];
      });
    } catch (e) {
      logger.e('Error fetching user name: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    fetchUserName();
    distributorName = widget.distributorName;
  }

  void _handleTabSelection() {
    setState(() {});
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
            'Hi ${userName ?? ''} (Donor)',
            style: GoogleFonts.barlowSemiCondensed(
              color: const Color(0xffCDFF01),
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.black,
          bottom: TabBar(
            labelStyle: GoogleFonts.barlowSemiCondensed(
                color: const Color(0xffCDFF01), fontWeight: FontWeight.bold),
            controller: _tabController,
            tabs: const [
              Tab(text: 'Breakfast'),
              Tab(text: 'Lunch'),
              Tab(text: 'Dinner'),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const SizedBox(height: 10),
              Text(
                'Distributor: $distributorName',
                style: GoogleFonts.barlowSemiCondensed(color: Colors.white),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildItemList('Breakfast'),
                    _buildItemList('Lunch'),
                    _buildItemList('Dinner'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemList(String itemName) {
    return StreamBuilder(
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
            Map<String, dynamic> data = e.data() as Map<String, dynamic>;
            data['id'] = e.id; // Add the document ID to the data
            return data;
          }).toList();
          items = items.where((item) => item['name'] == itemName).toList();
          // Filter items based on the distributor name
          items = items.where((item) {
            return item['distributorName'] == widget.distributorName;
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

          // Filter items based on whether they are today, in the future, or have passed
          items = items.where((item) {
            List<Timestamp> dates = [];
            if (item['dates'] is List<Timestamp>) {
              dates = List<Timestamp>.from(item['dates']);
            } else if (item['dates'] is String) {
              dates.add(
                Timestamp.fromDate(
                  DateTime.parse(item['dates']),
                ),
              );
            }

            return dates
                .where(
                  (date) =>
                      date.toDate().isAfter(DateTime.now()) ||
                      date.toDate().day == DateTime.now().day,
                )
                .isNotEmpty;
          }).toList();

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> thisItem = items[index];
              List<Timestamp> dates = [];
              if (thisItem['dates'] is List<Timestamp>) {
                dates = List<Timestamp>.from(thisItem['dates']);
              } else if (thisItem['dates'] is String) {
                dates.add(
                  Timestamp.fromDate(
                    DateTime.parse(thisItem['dates']),
                  ),
                );
              }

              // Filter dates based on whether they are today, in the future, or have passed
              List<String> futureAndCurrentDates = dates
                  .where((date) =>
                      date.toDate().isAfter(DateTime.now()) ||
                      date.toDate().day == DateTime.now().day)
                  .map((date) => DateFormat('yyyy-MM-dd').format(date.toDate()))
                  .toList();

              if (futureAndCurrentDates.isNotEmpty) {
                // Display the item only if it has current or future dates
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      // Container with logo
                      Container(
                        width: 50,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          shape: BoxShape.rectangle,
                          color: const Color(0xffCDFF01),
                        ),
                        child:
                            const Icon(Icons.restaurant, color: Colors.black),
                      ),
                      const SizedBox(width: 10),
                      // List tile
                      Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width - 80,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white.withOpacity(0.25),
                            width: 1,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: Colors.black.withOpacity(0.07),
                        ),
                        child: ListTile(
                          horizontalTitleGap: 25,
                          titleTextStyle: GoogleFonts.barlowSemiCondensed(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          leadingAndTrailingTextStyle:
                              GoogleFonts.barlowSemiCondensed(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          title: Text(
                            'Name: ${thisItem['name']}\nNeeded quantity: ${thisItem['quantity']}',
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Color(0xffCDFF01),
                                  size: 12,
                                ),
                                const SizedBox(width: 5),
                                Text('${thisItem['location']}'),
                              ],
                            ),
                          ),
                          subtitleTextStyle: GoogleFonts.barlowSemiCondensed(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                          trailing:
                              Text('Date: ${futureAndCurrentDates.first}'),
                          onTap: () {
                            _showContributionBottomSheet(
                                context, thisItem, userName!);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                // If there are no current or future dates, delete the item
                // and don't display it
                _deleteItem(thisItem['id']);
                return Container();
              }
            },
          );
        }
        return Container();
      },
    );
  }

  void _deleteItem(String itemId) async {
    await FirebaseFirestore.instance
        .collection('required')
        .doc(itemId)
        .delete();
  }
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
          'No distributors are found on the selected location',
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
              Navigator.of(context).pop();
            },
            child: Text(
              'Ok',
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
