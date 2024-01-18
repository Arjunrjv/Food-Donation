import 'package:flutter/material.dart';

class MyDonation extends StatefulWidget {
  const MyDonation({super.key});

  @override
  State<MyDonation> createState() => _MyDonationState();
}

class _MyDonationState extends State<MyDonation> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('My Donations')),
    );
  }
}
