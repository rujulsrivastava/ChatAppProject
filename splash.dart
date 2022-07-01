import 'package:chat_app_project/firebase_services/auth.dart';
import 'package:chat_app_project/pages/login.dart';
import 'package:chat_app_project/pages/signup.dart';
import 'package:flutter/material.dart';
class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Material(
      color: const Color(0xFF274CE0),
      child: Padding(
        padding: EdgeInsets.all(width/10),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Welcome", style: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.w600),),
                SizedBox(height: 50,),
                Text("Manage whatever whatever", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w300),),
                SizedBox(height: 15,),
                Text("Some more long, big text", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),),
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialButton(
                      height: 40,
                      minWidth: MediaQuery.of(context).size.width-(2*MediaQuery.of(context).size.width/10),
                      onPressed: () {googleSignIn(context);},
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),

                      textColor: const Color(0xFF274CE0),
                      child: const Text("Sign in with Google"),
                    ),
                    const SizedBox(height: 5,),
                    MaterialButton(
                      height: 40,
                      minWidth: MediaQuery.of(context).size.width-(2*MediaQuery.of(context).size.width/10),
                      onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUp()));},
                      color: const Color(0xFF274CE0),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.white70, width: 1), borderRadius: BorderRadius.circular(7)),
                      child: const Text("Create an account"),
                    ),
                    const SizedBox(height: 14,),
                    GestureDetector(
                      onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));},
                      child: const Text("Already have an account? Sign in",
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),),
                    )
                  ],
                ),
              ),
            )
        ]),
      ),
    );
  }
}
