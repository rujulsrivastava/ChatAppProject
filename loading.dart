import 'dart:async';

import 'package:chat_app_project/pages/splash.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'login.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    Timer(
        const Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => const Splash())));

    return Container(
     color: const Color(0xFF274CE0),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height/2,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage('assets/bird.png'),
              ),
            ),
            // child: const Text("SPLASH", style: TextStyle(fontSize: 50, fontWeight: FontWeight.w300, color: Colors.white),),

          )),
      ),
    );
  }
}
