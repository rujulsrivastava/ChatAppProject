import 'package:chat_app_project/customs/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

getAllUsers() async {
  var snapshot = await FirebaseFirestore.instance.collection("users").snapshots();
  return snapshot;
}

getUserGroups(String uid) async {
  return FirebaseFirestore.instance.collection("users").doc(uid).snapshots();
}

Future<bool> checkIfCollectionExist(String uid) {
  return FirebaseFirestore.instance.collection("users")
      .doc(uid)
      .collection("userchats")
      .limit(1)
      .get()
      .then((value) {
    return value.docs.isNotEmpty;
  });
}

getUserChats(String uid) async {
  return FirebaseFirestore.instance.collection("users").doc(uid).snapshots();
}

getUserGroupMessages(String groupId) async {
  return FirebaseFirestore.instance.collection('chatgroups').doc(groupId).collection('messages').orderBy('time').snapshots();
}

getUserPersonalMessages(docID) async {
  return FirebaseFirestore.instance.collection('personalchats').doc(docID).collection('messages').orderBy('time').snapshots();
}

Future togglingGroupJoin(String groupId, String groupName, String userName) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(uid);
  DocumentSnapshot userDocSnapshot = await userDocRef.get();

  DocumentReference groupDocRef = FirebaseFirestore.instance.collection('chatgroups').doc(groupId);

  List<dynamic> groups = await userDocSnapshot.get("usergroups");

  if(groups.contains('${groupId}_$groupName')) {
    //print('hey');
    await userDocRef.update({
      'usergroups': FieldValue.arrayRemove(['${groupId}_$groupName'])
    });

    await groupDocRef.update({
      'groupmembers': FieldValue.arrayRemove(['${uid}_$userName'])
    });
  }
  else {
    //print('nay');
    await userDocRef.update({
      'usergroups': FieldValue.arrayUnion(['${groupId}_$groupName'])
    });

    await groupDocRef.update({
      'groupmembers': FieldValue.arrayUnion(['${uid}_$userName'])
    });
  }
}



Future createGroup(String groupName, String userName, String uid) async {
  DocumentReference groupDocRef = await FirebaseFirestore.instance.collection("chatgroups").add(
      {
        'groupName': groupName,
        'groupIcon': '',
        'createdBy' : userName,
        'members': [],
        //'messages': ,
        'groupId': '',
        'recentMessage': '',
        'recentMessageSender': ''
      });

  await groupDocRef.update({
    'members': FieldValue.arrayUnion(['${uid}_$userName']),
    'groupId': groupDocRef.id,
  });

  DocumentReference userDocRef = FirebaseFirestore.instance.collection("users").doc(uid);
  return await userDocRef.update({
    'usergroups': FieldValue.arrayUnion(['${groupDocRef.id}_$groupName'])
  });

}

Future<void> createUser(MyUser user) async {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  try {
    await firebaseFirestore.collection("users").doc(auth.currentUser!.uid).set(
        {
          "uid" : auth.currentUser!.uid,
          "userName" : user.userName,
          "phone" : user.phone,
          "password" : user.password,
          "email" : user.email,
          "dateOfCreation" : user.dateOfCreation,
          "userchats" :[],
          "usergroups":[],
          "photo" : "",
        }
    );
    // await firebaseFirestore.collection("users").doc(auth.currentUser!.uid).collection("userchats").
  } catch (e) {print(e.toString());}
}

updateProfileData(String userName, String? email, String? phone) async {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  try {
    await auth.currentUser!.updateDisplayName(userName);
    await firebaseFirestore.collection("users").doc(auth.currentUser!.uid).set(
        {
          "userName" : userName,
          "phone" : phone ?? "",
          "email" : email ?? "",
        }
    );
  } catch (e) {print(e.toString());}
}
