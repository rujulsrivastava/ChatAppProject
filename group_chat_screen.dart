import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app_project/firebase_services/database.dart';
import 'package:chat_app_project/customs/message_tile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../firebase_services/messaging.dart';
import '../utils/picking_images.dart';

class GroupChatPage extends StatefulWidget {

  final String groupId;
  final String groupName;

  GroupChatPage({
    required this.groupId,
    required this.groupName
  });

  @override
  _GroupChatPageState createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {

  late Stream<QuerySnapshot<Map<String, dynamic>>> _chats;
  TextEditingController messageEditingController = TextEditingController();

  Widget _chatMessages(){
    return StreamBuilder(
      stream: _chats,
      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
        return snapshot.hasData ?  ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index){
              return snapshot.data?.docs[index].data()["messageType"] == 0 ?
              MessageTile(
                message: snapshot.data?.docs[index].data()["message"],
                sender: snapshot.data?.docs[index].data()["sender"],
                sentByMe: FirebaseAuth.instance.currentUser!.displayName == snapshot.data?.docs[index].data()["sender"],
                time: snapshot.data?.docs[index].data()["time"],
                messageType: snapshot.data?.docs[index].data()["messageType"],
              ) : MessageTile(
                path: snapshot.data?.docs[index].data()["path"],
                sender: snapshot.data?.docs[index].data()["sender"],
                sentByMe: FirebaseAuth.instance.currentUser!.displayName == snapshot.data?.docs[index].data()["sender"],
                time: snapshot.data?.docs[index].data()["time"],
                messageType: snapshot.data?.docs[index].data()["messageType"],
              );
            }
        )
            :
        Container();
      },
    );
  }

  _sendMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageEditingController.text,
        "sender": FirebaseAuth.instance.currentUser!.displayName,
        "time" : Timestamp.now(),
        "messageType" : 0
      };

      sendMessageInGroup(widget.groupId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserGroupMessages(widget.groupId).then((val) {
      // print(val);
      setState(() {
        _chats = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF043F4A),
        elevation: 0.0,
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            _chatMessages(),
            // Container(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                color: Colors.grey[700],
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageEditingController,
                        style: const TextStyle(
                            color: Colors.white
                        ),
                        decoration: const InputDecoration(
                            hintText: "Send a message ...",
                            hintStyle: TextStyle(
                              color: Colors.white38,
                              fontSize: 16,
                            ),
                            border: InputBorder.none
                        ),
                      ),
                    ),

                    SizedBox(width: 12.0),

                    GestureDetector(
                      onTap: () {
                        _attachImage(context);
                      },
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                            color: const Color(0xFF043F4A),
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: const Center(child: Icon(Icons.attach_file, color: Colors.white)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _sendMessage();
                      },
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                            color: const Color(0xFF043F4A),
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: const Center(child: Icon(Icons.send, color: Colors.white)),
                      ),
                    ),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  _attachImage(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 100,
          // color: Colors.amber,
          child: Center(
            child: Row (
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(onPressed: () { Navigator.of(context).pop();}, icon: const Icon(Icons.camera_alt_outlined)),
                IconButton(onPressed: () { Navigator.of(context).pop();}, icon: const Icon(Icons.photo)),
              ],
            ),
          ),
        );
      },
    );
  }

  _sendImage(String url) {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "path" : url,
        "sender": FirebaseAuth.instance.currentUser!.displayName,
        "time" : Timestamp.now(),
        "messageType" : 1
      };

      sendMessageInGroup(widget.groupId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
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
