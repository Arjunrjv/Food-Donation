import 'package:flutter/material.dart';
import 'package:fooddon/donor/donation.dart';
import 'package:fooddon/donor/mainhome.dart';
import 'package:fooddon/donor/donorlogout.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const MainHome(),
    const MyDonation(),
    const DonorLogout(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.volunteer_activism), label: 'My Donation'),
          BottomNavigationBarItem(
              icon: Icon(Icons.logout_rounded), label: 'Logout'),
        ],
        selectedItemColor: const Color(0xffCDFF01),
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.black,
      ),
    );
  }
}
