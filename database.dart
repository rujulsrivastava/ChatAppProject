import 'package:cloud_firestore/cloud_firestore.dart';
getGroupList() async {
  // return snapshots();
  var snapshot = await FirebaseFirestore.instance.collection("users").get();
  return snapshot.docs;
}

void createGroup(String groupName, String userName) async {
  // final String groupName;
  // final String userName;
  FirebaseFirestore.instance.collection("chatgroups").add(
      {
        "groupName"    : groupName,
        "createdBy" : userName,
      }).then((value){
    print(value.parent);
  });
}

void createUser(String email, String userName, String password) {
  FirebaseFirestore.instance.collection("users").add(
    {
      "userName" : userName,
      "email" : email,
      "password" : password,
    }
  );
}

// getUserData()
//
// Future updateProfile({String? userName, String? email, String? phone}) async {
//   var collection = FirebaseFirestore.instance.collection('users');
//   collection
//   .doc()
// }