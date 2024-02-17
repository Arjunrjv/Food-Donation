import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddRequire extends StatefulWidget {
  const AddRequire({super.key});

  @override
  State<AddRequire> createState() => _DistributorHomeState();
}

class _DistributorHomeState extends State<AddRequire> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerQuantity = TextEditingController();
  final TextEditingController _controllerExpiry = TextEditingController();
  final TextEditingController _controllerLocation = TextEditingController();

  GlobalKey<FormState> key = GlobalKey();

  CollectionReference required =
      FirebaseFirestore.instance.collection('required');

  String imageUrl = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: key,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: TextFormField(
                    controller: _controllerName,
                    decoration: const InputDecoration(
                      labelText: "Food Item Name",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _controllerQuantity,
                  decoration: const InputDecoration(
                    labelText: "Quantity",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _controllerExpiry,
                  decoration: const InputDecoration(
                    labelText: "Expiry time",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _controllerLocation,
                  decoration: const InputDecoration(
                    labelText: "Location",
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     Text(
                //       'Pick the image',
                //       style: TextStyle(
                //         color: Colors.grey.withOpacity(0.5),
                //       ),
                //     ),
                //     IconButton(
                //       onPressed: () async {
                //         ImagePicker imagePicker = ImagePicker();
                //         XFile? file = await imagePicker.pickImage(
                //             source: ImageSource.gallery);
                //         print('${file?.path}');

                //         if (file == null) return;

                //         String uniqueFileName =
                //             DateTime.now().millisecondsSinceEpoch.toString();

                //         Reference referenceRoot =
                //             FirebaseStorage.instance.ref();
                //         Reference referenceDirImages =
                //             referenceRoot.child('images');
                //         Reference referenceImageToUpload =
                //             referenceDirImages.child(uniqueFileName);

                //         try {
                //           await referenceImageToUpload.putFile(File(file.path));
                //           imageUrl =
                //               await referenceImageToUpload.getDownloadURL();
                //         } catch (error) {}
                //       },
                //       icon: const Icon(Icons.image_search),
                //     ),
                //   ],
                // ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 60,
                  width: 380,
                  child: FloatingActionButton.extended(
                    onPressed: () async {
                      // if (imageUrl.isEmpty) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //       const SnackBar(
                      //           content: Text('Please upload an image')));

                      //   return;
                      // }
                      if (key.currentState!.validate()) {
                        String itemName = _controllerName.text;
                        String itemQuantity = _controllerQuantity.text;
                        String itemExpiry = _controllerExpiry.text;
                        String itemLocation = _controllerLocation.text;

                        required.add({
                          'name': itemName,
                          'quantity': itemQuantity,
                          'expiry': itemExpiry,
                          'location': itemLocation,
                          // 'image': imageUrl,
                          'timestamp': FieldValue.serverTimestamp(),
                        });
                      }
                      Navigator.pop(context);
                    },
                    label: const Text(
                      'Upload',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                    backgroundColor: const Color(0xffCDFF01),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
