import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fooddon/home.dart';
import 'package:google_fonts/google_fonts.dart';

class Catalog extends StatefulWidget {
  const Catalog({Key? key}) : super(key: key);

  @override
  State<Catalog> createState() => _CatalogState();
}

class _CatalogState extends State<Catalog> {
  final CollectionReference item =
      FirebaseFirestore.instance.collection('required');

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
          child: StreamBuilder(
            stream: item.orderBy('timestamp', descending: true).snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: Text('Some error occurred ${snapshot.error}'));
              }
              if (snapshot.hasData) {
                QuerySnapshot querySnapshot = snapshot.data;
                List<QueryDocumentSnapshot> documents = querySnapshot.docs;

                List<Map> items =
                    documents.map((e) => e.data() as Map).toList();
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    Map thisItem = items[index];
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              color: Colors.black.withOpacity(0.07),
                            ),
                            child: ListTile(
                              horizontalTitleGap: 25,
                              // leading: Text('${thisItem['name']}'),
                              titleTextStyle: GoogleFonts.barlowSemiCondensed(
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
                              trailing:
                                  Text('Expiry time: ${thisItem['expiry']}'),
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
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
