import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser{
  late String uid;
  late String? phone;
  late String userName;
  late String? password;
  late String? email;
  late Timestamp dateOfCreation;
  late List usergroups;

  MyUser({required this.userName, this.password, this.phone, this.email, required this.dateOfCreation});

  MyUser.fromMap(Map<String, dynamic> mapData) {
    uid = mapData["uid"];
    userName = mapData["userName"];
    email = mapData["email"];
    phone = mapData["phone"];
    dateOfCreation = mapData["dateOfCreation"];
    usergroups = mapData["usergroups"];
  }
}
