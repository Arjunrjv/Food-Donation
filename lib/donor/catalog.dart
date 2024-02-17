import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
        appBar: AppBar(
          toolbarHeight: 80,
          leading: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          elevation: 0,
          title: Text(
            'FoodDon',
            // style: TextStyle(
            //   color: Color(0xffCDFF01),
            //   fontSize: 27,
            //   fontWeight: FontWeight.bold,
            // ),
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
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          color: Colors.black.withOpacity(0.07),
                        ),
                        child: ListTile(
                          title: Text('${thisItem['name']}'),
                          subtitle:
                              Text('Needed quantity: ${thisItem['quantity']}'),
                          trailing: Text('Expiry time: ${thisItem['expiry']}'),
                          leading: Text('${thisItem['location']}'),
                          // leading: const SizedBox(
                          //   height: 100,
                          //   width: 100,
                          // child: thisItem.containsKey('image')
                          //     ? Image.network('${thisItem['image']}')
                          //     : Container(),
                          // ),
                          // onTap: () {
                          //   Navigator.of(context).push(
                          //     MaterialPageRoute(
                          //       builder: (context) => Description(
                          //         name: thisItem['name'],
                          //         category: thisItem['category'],
                          //         price: thisItem['price'],
                          //         image: thisItem['image'],
                          //         description: thisItem['description'],
                          //       ),
                          //     ),
                          //   );
                          // },
                        ),
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
