import 'package:chat_app_project/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_project/pages/home.dart';
import 'package:chat_app_project/firebase_services/auth.dart' as authServices;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: phoneController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Phone",
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1)),
              )),
          TextField(),
          const SizedBox(height: 20,),
          // const TextField(
          //   obscureText: true,
          //     style: TextStyle(color: Colors.white),
          //     decoration: InputDecoration(
          //       labelText: "Password",
          //       labelStyle: TextStyle(color: Colors.white),
          //       enabledBorder: OutlineInputBorder(
          //           borderSide: BorderSide(color: Colors.white, width: 1)),
          //       focusedBorder: OutlineInputBorder(
          //           borderSide: BorderSide(color: Colors.white, width: 1)),
          //     )),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.teal)),
              onPressed: () {
                authServices.signIn(context, phone: phoneController.text);
                // authServices.googleSignIn(context);
              },
              child: const Text(
                "Log in to your account",
                style: TextStyle(color: Colors.white),
              )),

          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.teal)),
              onPressed: () {
                // authServices.signIn(context);
                authServices.googleSignIn(context);
              },
              child: const Text(
                "Sign in with Google",
                style: TextStyle(color: Colors.white),
              )),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.teal)),
              onPressed: () {
                // authServices.signIn(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUp()));
              },
              child: const Text(
                "Create an account",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
  }
}

