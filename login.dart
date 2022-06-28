import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_project/pages/home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  void _completeLogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home()));
  }

  // FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signIn(BuildContext context,
      {String? phone, String? password}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (phone != null && password != null) {
      try {
        // await firebaseAuth.signInWithEmailAndPassword(
        //     email: email, password: password);

        await auth.verifyPhoneNumber(
            phoneNumber: phone,
            verificationCompleted: (PhoneAuthCredential cred) async {
              await auth.signInWithCredential(cred);
              _completeLogin();
            },
            verificationFailed: (FirebaseAuthException authException) async {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(authException.toString())));
            },
            codeSent: (String verificationID, int? resendToken) {},
            codeAutoRetrievalTimeout: (String verificationID) {});
        //
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter something.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Phone",
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1)),
              )),
          const TextField(
            obscureText: true,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1)),
              )),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.teal)),
              onPressed: () {
                // signIn(context);
                _completeLogin();
              },
              child: const Text(
                "Log in to your account",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
  }
}
