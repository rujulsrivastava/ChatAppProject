import 'package:chat_app_project/firebase_services/auth.dart';
import 'package:chat_app_project/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';


class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final auth = FirebaseAuth.instance;
  late String phone;
  late String email;
  late String pwd;
  late String username;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: blueColor,
        // appBar: AppBar(title: const Text("Sign Up For Capital"),),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              // TextField(decoration: const InputDecoration(hintText: "Phone"), keyboardType: TextInputType.phone, onChanged: (value) {phone=value;},),
              TextField(decoration: const InputDecoration(hintText: "Email ID"), keyboardType: TextInputType.emailAddress, onChanged: (value) {email=value;},),
              TextField(decoration: const InputDecoration(hintText: "Username"), onChanged: (value) {username=value;}),
              TextField(decoration: const InputDecoration(hintText: "Password"), obscureText: true, onChanged: (value) {pwd = value;},),
              ElevatedButton(
                  // style: ButtonStyle(backgroundColor: blueColorMaterial, foregroundColor: whiteColorMaterial),
                  child: const Text("Register"),
                  onPressed: () async {
                    await createAccount(email, pwd, username).whenComplete(() =>
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home())));

                    // try {
                    //   await auth.verifyPhoneNumber(phoneNumber: phone,
                    //       verificationCompleted: (PhoneAuthCredential cred) async {
                    //     await auth.signInWithCredential(cred);
                    //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(userName: username,)));},
                    //       verificationFailed: (FirebaseAuthException authException) async {
                    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authException.toString())));},
                    //       codeSent: (String verificationID, int? resendToken) {},
                    //   codeAutoRetrievalTimeout: (String verificationID) {});
                    // } catch (e) {
                    //   print(e);
                  }
              ),
            ]
        )
    );
  }
}
