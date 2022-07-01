import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_project/pages/home.dart';
import 'package:chat_app_project/pages/login.dart';
import 'package:google_sign_in/google_sign_in.dart';

FutureOr<void> completeLogin(BuildContext context, String userName) {
  late String username=userName;
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home(username: username)));
}

loadData() {
  User user = Observable(_auth.onAuthStateChanged);

  profile = user.switchMap((FirebaseUser u) {
    if (u != null) {
      return _db
          .collection('users')
          .document(u.uid)
          .snapshots()
          .map((snap) => snap.data);
    } else {
      return Observable.just({});
    }
  });
}

Future<void> signUp(BuildContext context, String phone, String userName, String password) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _codeController = TextEditingController();
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
                            controller: _codeController,
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          child: const Text("Done"),
                          onPressed: () async {
                            if (_codeController.text.isNotEmpty) {
                              try {
                                final smsCode = _codeController.text.trim();
                                PhoneAuthCredential credential =
                                PhoneAuthProvider.credential(
                                    verificationId: verificationID,
                                    smsCode: smsCode);
                                await auth.signInWithCredential(credential);
                                completeLogin(context, userName);
                                addUser(phone, auth.currentUser!.uid, userName, password);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("Please enter the OTP properly")));
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
          .showSnackBar(SnackBar(content: Text(e.toString()+"error")));
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
    completeLogin(context, user!.displayName!);
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

// Future<void> createAccount(BuildContext context, String? phone,
//     String? password, String? username) async {
//   FirebaseAuth auth = FirebaseAuth.instance;
//   CollectionReference collectionReference =
//   FirebaseFirestore.instance.collection("users");
//   if (phone != null && password != null && username != null) {
//     try {
//       signUp(context, phone: phone);
//       collectionReference.add({
//         'userName': username,
//         'uid': auth.currentUser!.uid,
//         'password': password,
//         'phone': phone,
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(e.toString())));
//     }
//   }  else {
//     ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter proper details")));
//   }
// }

void addUser(String phone, String uid, String userName, String password){
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference collectionReference =
  FirebaseFirestore.instance.collection("users");
  collectionReference.add({
    'userName': userName,
    'uid': auth.currentUser!.uid,
    'password': password,
    'phone': phone,
  });
}
