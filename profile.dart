import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app_project/firebase_services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import '../customs/user_model.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

final userRef = FirebaseFirestore.instance.collection("users");

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  late File? image;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Material(
      color: const Color(0xFF274CE0),
      child: Scaffold(
          backgroundColor: const Color(0xFF274CE0),
          body: SingleChildScrollView(
            child: Column(children: [
              Container(
                width: width,
                height: height*0.20,
                alignment: Alignment.center,
                color: const Color(0xFF274CE0),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: width / 10,
                      bottom: 23,
                      top: height / 15,
                      right: width / 10),
                  child: Center(
                    child: Row(
                      children: [
                        IconButton(
                            padding: const EdgeInsets.all(0),
                            alignment: Alignment.center,
                            color: Colors.white,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.arrow_back)),
                        const SizedBox(width: 30),
                        Text("My Profile",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: width / 11.5,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: width,
                height: height * 0.80,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: width / 10, right: width / 10, top: 23),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      renderProfile(context),
                    ],
                  ),
                ),
              ),
            ]),
          )),
    );
  }

  renderProfile(BuildContext context) {
    TextEditingController userNameController = TextEditingController();
    var phoneController = TextEditingController();
    var emailController = TextEditingController();
    String? userName, phone, email;
    return FutureBuilder(
      future: userRef.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Text("Data not found");
        } else {
          Map<String, dynamic> data = snapshot.data.data();
          MyUser user = MyUser.fromMap(data);
          userNameController.text = user.userName;
          phoneController.text = user.phone ?? "";
          emailController.text = user.email ?? "";
          String? url = user.photo;
          return Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => imageChanger(context),
                    child: profilePhoto == null ? url == null ? const CircleAvatar(
                      backgroundColor: Colors.teal,
                      radius: 50,
                    ) : CircleAvatar(
                      radius: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(url, width: 120,
                          height: 120,
                          fit: BoxFit.cover,),),
                    )
                        : CircleAvatar(
                      radius: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(profilePhoto!, width: 120,
                          height: 120,
                          fit: BoxFit.cover,),),
                  ),
                ),),
                Column(children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the username';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        userNameController.text = value;
                      });
                    },
                    initialValue: user.userName,
                    // controller: userNameController,
                    decoration: const InputDecoration(
                      labelText: "Username",
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  TextFormField(
                    validator: (value) {
                      if ((value == null || value.isEmpty) || (value.isEmpty && phoneController.text.isEmpty)) {
                        return 'Please enter proper details';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        emailController.text = value;
                      });
                    },
                    initialValue: emailController.text,
                    decoration: const InputDecoration(
                      labelText: "Email",
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  TextFormField(
                    onFieldSubmitted: (value) {setState((){phone = value;});},
                    validator: (value) {
                      if (value == null && emailController.text == null ) {
                        return 'Please save either phone or email';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        phoneController.text = value;
                      });
                    },
                    initialValue: phoneController.text,
                    decoration: const InputDecoration(
                      labelText: "Phone",
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MaterialButton(
                    height: 40,
                    minWidth: MediaQuery.of(context).size.width -
                        (2 * MediaQuery.of(context).size.width / 10),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data'), duration: Duration(milliseconds: 500),),
                        );
                        print("phone is: ");
                        print(phoneController.text);
                        print(phone);
                        await updateProfileData(userNameController.text, emailController.text, phone);
                      }
                    },
                    disabledColor: const Color(0xFF274CE0).withAlpha(10),
                    disabledTextColor: Colors.white,
                    color: const Color(0xFF274CE0),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text("Update profile"),
                  ),
                ])
              ],
            ),
          );
        }
      },
    );
  }

  imageChanger(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 100,
          // color: Colors.amber,
          child: Center(
            child: Row (
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(onPressed: () {
                  pickImageFromCamera();
                  // Navigator.of(context).pop();
                  }, icon: const Icon(Icons.camera_alt_outlined)),
                IconButton(onPressed: () {
                  pickImageFromGallery();
                  // Navigator.of(context).pop();
                  }, icon: const Icon(Icons.photo)),
              ],
            ),
          ),
        );
      },
    );
  }


  late File _imageFile;
  File? profilePhoto;
  final picker = ImagePicker();
  late String imageURL;

  Future pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        profilePhoto = _imageFile;
        imageURL = pickedFile.path;
      });
    }

    if (pickedFile != null) {
      uploadImageToFirebase(_imageFile.path, FirebaseAuth.instance.currentUser!.uid);
    }
  }

  Future pickImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        profilePhoto = _imageFile;
        imageURL = pickedFile.path;
      });
    }

    if (pickedFile != null) {
      uploadImageToFirebase(_imageFile.path, FirebaseAuth.instance.currentUser!.uid);
    }
  }

  Future uploadImageToFirebase(String path, String uid) async {
    String fileName = basename(path);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('uploads/$fileName');
    UploadTask uploadTask = ref.putFile(_imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;

    CollectionReference collectionReference = FirebaseFirestore.instance.collection("users");
    taskSnapshot.ref.getDownloadURL().then(
          (value) async => await collectionReference.doc(uid).update({'photo' : value})
    );
  }

}
