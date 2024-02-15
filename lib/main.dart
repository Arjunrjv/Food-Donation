import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fooddon/home.dart';
import 'package:fooddon/welcome.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey:
          "AIzaSyC6Gzz6om77djFkwwj4vOmBsDy9OdMS-_k", // paste your api key here
      appId:
          "1:435837202458:android:573ca7471d6a6089fea1a3", //paste your app id here
      messagingSenderId: "435837202458", //paste your messagingSenderId here
      projectId: "fooddon-c925f", //paste your project id here
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // Check the current user's authentication status
    User? currentUser = _auth.currentUser;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: const Color(0xffCDFF01),
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xffCDFF01),
            primary: const Color(0xffCDFF01)),
        useMaterial3: true,
      ),
      home: currentUser != null ? const HomeScreen() : const Welcome(),
    );
  }
}
