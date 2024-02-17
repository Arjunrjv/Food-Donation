import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fooddon/welcome.dart';

class MyNotification extends StatefulWidget {
  const MyNotification({super.key});

  @override
  State<MyNotification> createState() => _MyNotificationState();
}

class _MyNotificationState extends State<MyNotification> {
  void _signOut(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Log out',
          style: TextStyle(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const Welcome(),
                ),
              );
            },
            child: const Text(
              'Log out',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(top: 500, left: 30),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _signOut(context),
              child: Container(
                alignment: Alignment.center,
                height: 100,
                width: 350,
                decoration: const BoxDecoration(
                  color: Color(0xffCDFF01),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: const Text(
                  'Log Out',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
