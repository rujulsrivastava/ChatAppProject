import 'dart:async';
import 'package:chat_app_project/firebase_services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_project/pages/home.dart';
import 'package:chat_app_project/pages/login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../customs/user_model.dart';

FutureOr<void> completeLogin(BuildContext context, String userName) {
  late String username=userName;
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home(username: username)));
}

Future<void> signIn(BuildContext context, String userName, String password) async {

}

Future<void> signUp(BuildContext context, String phone, String userName, String password) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController codeController = TextEditingController();
  if (phone != null) {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted: (PhoneAuthCredential cred) async {
            await auth.signInWithCredential(cred);
            completeLogin(context, userName);
          },
          verificationFailed: (FirebaseAuthException authException) async {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(authException.toString())));
          },
          codeSent: (String verificationID, int? resendToken) {
            showDialog(
                context: context,
                builder: (context) =>
                    AlertDialog(
                      title: const Text("Enter SMS Code"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextField(
                            controller: codeController,
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          child: const Text("Done"),
                          onPressed: () async {
                            if (codeController.text.isNotEmpty) {
                              try {
                                final smsCode = codeController.text.trim();
                                PhoneAuthCredential credential =
                                PhoneAuthProvider.credential(
                                    verificationId: verificationID,
                                    smsCode: smsCode);
                                UserCredential user = await auth.signInWithCredential(credential);
                                if (user != null) {
                                  User? updateUser = FirebaseAuth.instance.currentUser;
                                  await updateUser!.updateDisplayName(userName);
                                  createUser(MyUser(userName: user.user!.displayName!, password: password, phone: user.user!.phoneNumber!, dateOfCreation: Timestamp.now(), email: ""));
                                  // userSetup(user.user!.displayName!, password, user.user!.phoneNumber!, user.user!);
                                  completeLogin(context, user.user!.displayName!);
                                }

                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter the OTP properly")));
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter the OTP")));
                            }
                          },
                        )
                      ],
                    ));
          },
          codeAutoRetrievalTimeout: (String verificationID) {});
      //
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${e}error")));
    }
  } else {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Please enter something.")));
  }
}

Future<User?> googleSignIn(BuildContext context) async {
  final firebaseAuth = FirebaseAuth.instance;
  try {
    UserCredential userCred;
    if (kIsWeb) {
      final auth = GoogleAuthProvider();
      userCred = await firebaseAuth.signInWithPopup(auth);
    } else {
      final GoogleSignInAccount account = (await GoogleSignIn().signIn())!;
      final GoogleSignInAuthentication auth = await account.authentication;
      final cred = GoogleAuthProvider.credential(
          accessToken: auth.accessToken, idToken: auth.idToken);
      userCred = await firebaseAuth.signInWithCredential(cred);
    }
    var user = userCred.user;
    await createUser(MyUser(userName: user!.displayName!, dateOfCreation: Timestamp.now(), phone: user.phoneNumber, password: "", email: user.email));
    completeLogin(context, user.displayName!);
    return user;
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(e.toString())));
    print(e);
  }
  return null;
}

void completeSignOut(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const Login()), (route) => false);
}

Future<void> signOut(BuildContext context) async {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  await firebaseAuth.signOut();
  completeSignOut(context);
}

Future<void> googleSignOut(BuildContext context) async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  try {
    if (!kIsWeb) {
      await googleSignIn.signOut();
    }
    await FirebaseAuth.instance.signOut();
    completeSignOut(context);
  } catch (e) {
    print(e);
  }
}
