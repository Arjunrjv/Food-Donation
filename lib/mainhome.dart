import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fooddon/donor/catalog.dart';
import 'package:fooddon/welcome.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
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
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/homeimage.png',
                width: 550,
                height: 550,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 450, left: 20),
                child: Text(
                  'Share The Love, Share A Meal - \nMaking Hunger A Thing Of The Past.',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 200,
        child: FloatingActionButton(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          backgroundColor: Colors.black,
          elevation: 0,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const Catalog(),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  'Donate Food',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                height: 70,
                width: 80,
                decoration: const BoxDecoration(
                  color: Color(0xffCDFF01),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: const Icon(
                  Icons.add,
                  size: 48,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
