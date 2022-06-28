// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:chat_app/pages/home.dart';
// import 'package:chat_app/pages/login.dart';
import 'package:chat_app_project/pages/splash.dart';

class ChatApp extends StatelessWidget {
  ChatApp({Key? key}) : super(key: key);
  // final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Splash(),
        routes: {
          '/splash': (context) => Splash(),
          // '/login': (context) => Login(),
          // '/signup' : (context) => SignUp(),
          // '/home': (context) => Home(),
        }

    );
  }
}