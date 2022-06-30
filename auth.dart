import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_project/pages/home.dart';
import 'package:chat_app_project/pages/login.dart';
import 'package:google_sign_in/google_sign_in.dart';

FutureOr<void> completeLogin(BuildContext context) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => const Home()));
}

Future<void> signIn(BuildContext context, {String? phone}) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _codeController = TextEditingController();
  if (phone != null) {
    try {
      // await firebaseAuth.signInWithEmailAndPassword(
      //     email: email, password: password);

      await auth.verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted: (PhoneAuthCredential cred) async {
            await auth.signInWithCredential(cred);
            completeLogin(context);
          },
          verificationFailed: (FirebaseAuthException authException) async {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(authException.toString())));
          },
          codeSent: (String verificationID, int? resendToken) {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text("Enter SMS Code"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextField(
                            controller: _codeController,
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          child: const Text("Done"),
                          onPressed: () {
                            final smsCode = _codeController.text.trim();
                            PhoneAuthCredential credential =
                                PhoneAuthProvider.credential(
                                    verificationId: verificationID,
                                    smsCode: smsCode);
                            auth.signInWithCredential(credential);
                            completeLogin(context);
                          },
                        )
                      ],
                    ));
          },
          codeAutoRetrievalTimeout: (String verificationID) {});
      //
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  } else {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Please enter something.")));
  }
}

Future<User?> googleSignIn(BuildContext context) async {
  final firebaseAuth = FirebaseAuth.instance;
  String? userName;

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
    userName = user?.displayName;
    completeLogin(context);
    return user;
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(e.toString())));
    print(e);
  }
}

void completeSignOut(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => Login()), (route) => false);
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

Future<void> createAccount(
    String email, String password, String username) async {
  try {
    FirebaseAuth auth = FirebaseAuth.instance;
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("users");
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User currentUser = auth.currentUser!;
    currentUser.updateDisplayName(username);
    String uid = userCredential.user!.uid.toString();
    collectionReference.add({
      'userName': username,
      'email': email,
      'uid': uid,
      'password': password,
    });
  } catch (e) {
    print(e.toString());
  }
}
