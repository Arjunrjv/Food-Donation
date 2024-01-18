import 'package:flutter/material.dart';

class DonateIn extends StatefulWidget {
  const DonateIn({Key? key}) : super(key: key);

  @override
  State<DonateIn> createState() => _DonateInState();
}

class _DonateInState extends State<DonateIn> {
  int selectedValue = 1;
  bool isVegChecked = false;
  bool isNonVegChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Food Item Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                const TextField(
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    labelText: 'Expiry date/time',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                const TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Phone no',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: isVegChecked,
                      onChanged: (value) {
                        setState(() {
                          isVegChecked = value!;
                          if (isVegChecked) {
                            isNonVegChecked =
                                false; // Uncheck non-veg if veg is checked
                          }
                        });
                      },
                      activeColor: const Color.fromARGB(255, 128, 160, 0),
                    ),
                    const Text('Veg'),
                    Checkbox(
                      value: isNonVegChecked,
                      onChanged: (value) {
                        setState(() {
                          isNonVegChecked = value!;
                          if (isNonVegChecked) {
                            isVegChecked =
                                false; // Uncheck veg if non-veg is checked
                          }
                        });
                      },
                      activeColor: const Color.fromARGB(255, 160, 0, 0),
                    ),
                    const Text('Non-Veg'),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    height: 60,
                    width: 400,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          color: Color(0xffCDFF01),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
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
