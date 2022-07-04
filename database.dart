import 'package:chat_app_project/customs/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
getGroupList() async {
  var snapshot = await FirebaseFirestore.instance.collection("users").get();
  return snapshot.docs;
}

void createGroup(String groupName, String userName) async {
  FirebaseFirestore.instance.collection("chatgroups").add(
      {
        "groupName"    : groupName,
        "createdBy" : userName,
      }).then((value){
    print(value.parent);
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
      }
    );
  } catch (e) {print(e.toString());}
}

updateData(String userName, String? email, String phone) async {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  try {
    await auth.currentUser!.updateDisplayName(userName);
    await firebaseFirestore.collection("users").doc(auth.currentUser!.uid).set(
        {
          "userName" : userName,
          "phone" : phone,
          "email" : email,
        }
    );
  } catch (e) {print(e.toString());}
}

Future<Map<String, dynamic>?> getUserData(String uid) async  {
  var snapshot = await FirebaseFirestore.instance.collection("users").doc(uid).get();
  return snapshot.data();
}
