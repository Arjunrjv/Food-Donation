import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fooddon/distributor/distributorhome.dart';
import 'package:fooddon/distributor/editrequiremts.dart';
import 'package:google_fonts/google_fonts.dart';

class RequireEdit extends StatefulWidget {
  const RequireEdit({Key? key}) : super(key: key);

  @override
  State<RequireEdit> createState() => _RequireEditState();
}

class _RequireEditState extends State<RequireEdit>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final CollectionReference item =
      FirebaseFirestore.instance.collection('required');

  final TextEditingController _searchController = TextEditingController();

  String _searchLocation = "";
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    fetchUserName();
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
                  builder: (context) => const DistributorHome(),
                ),
              );
            },
          ),
          elevation: 0,
          title: Text(
            'Hi ${userName ?? ''} (Distributor)',
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

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> thisItem = items[index];
              String documentId = thisItem['id'];
              // List<String> dates = List<String>.from(thisItem['dates'] ?? []);
              List<String> dates = (thisItem['dates'] as String).split(',');

              // Filter only future-dated items
              dates = dates.where((date) {
                DateTime itemDate = DateTime.parse(date);
                return itemDate.isAfter(DateTime.now());
              }).toList();

              if (dates.isEmpty) {
                // If there are no future-dated items, return an empty container
                return Container();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: dates.map((date) {
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
                                    color: const Color(0xffCDFF01),
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
                            trailing: Text('Date: $date'),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditRequirements(
                                          documentId: documentId)));
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          );
        }
        return Container();
      },
    );
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
              // // Navigate to the charity contribution page
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => CharityContributionPage(),
              //   ),
              // );
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
