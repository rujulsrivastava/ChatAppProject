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

class GroupChatPage extends StatefulWidget {

  final String groupId;
  final String groupName;
  String? groupIconPath;
  final bool isUserJoined;

  GroupChatPage({Key? key,
    required this.groupId,
    required this.groupName,
    this.groupIconPath,
    required this.isUserJoined,
  }) : super(key: key);

  @override
  _GroupChatPageState createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {

  File? _imageFile;
  File? _groupIcon;
  final picker = ImagePicker();

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
    getUserGroupMessages(widget.groupId).then((val) {
      // print(val);
      setState(() {
        _chats = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => groupIconChanger(context),
            child: _groupIcon == null ? widget.groupIconPath == null ?

            CircleAvatar(
              radius: 20.0,
              backgroundColor: Colors.white,
              child: Text(widget.groupName.substring(0, 1).toUpperCase(), textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF043F4A),)),
            )
          : CircleAvatar(
            radius: 20.0,
            backgroundColor: Colors.white,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(widget.groupIconPath!, width: 120,
                height: 120,
                fit: BoxFit.cover,),),) :
            CircleAvatar(
              radius: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.file(_groupIcon!, width: 120,
                  height: 120,
                  fit: BoxFit.cover,),),
            ),),
        ),
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
                        enabled: widget.isUserJoined,
                        style: const TextStyle(
                            color: Colors.white
                        ),
                        decoration: InputDecoration(
                            hintText: widget.isUserJoined ? "Send a message ..." : "You cannot send messages yet..",
                            hintStyle: const TextStyle(
                              color: Colors.white38,
                              fontSize: 16,
                            ),
                            border: InputBorder.none
                        ),
                      ),
                    ),

                    const SizedBox(width: 12.0),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          widget.isUserJoined == true ? imageAttacher(context) : null;
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
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.isUserJoined == true ? _sendMessage() : null;

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
  imageAttacher(BuildContext context) {
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

  groupIconChanger(BuildContext context) {
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
                  setImageFromCamera();
                  // Navigator.of(context).pop();
                }, icon: const Icon(Icons.camera_alt_outlined)),
                IconButton(onPressed: () {
                  setImageFromGallery();
                  // Navigator.of(context).pop();
                }, icon: const Icon(Icons.photo)),
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

  Future pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }

    if (pickedFile != null) {
      uploadImageToFirebase(_imageFile!.path);
    }
  }

  Future pickImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }

    if (pickedFile != null) {
      uploadImageToFirebase(_imageFile!.path);
    }
  }
  Future uploadImageToFirebase(String path) async {
    String fileName = basename(path);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('uploads/$fileName');
    UploadTask uploadTask = ref.putFile(_imageFile!);
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then(
            (value) => _sendImage(value)
    );
  }

  Future setImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _groupIcon = File(pickedFile.path);
      });
      uploadGroupIconToFirebase(pickedFile.path);
    }
  }

  Future setImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _groupIcon = File(pickedFile.path);
      });
      uploadGroupIconToFirebase(pickedFile.path);
    }
  }

  Future uploadGroupIconToFirebase(String path) async {
    String fileName = basename(path);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('groupIcons/${widget.groupId}/$fileName');
    UploadTask uploadTask = ref.putFile(_groupIcon!);
    TaskSnapshot taskSnapshot = await uploadTask;

    CollectionReference collectionReference = FirebaseFirestore.instance.collection("chatgroups");
    taskSnapshot.ref.getDownloadURL().then(
            (value) async => await collectionReference.doc(widget.groupId).update({'groupIcon' : value})
    );
  }


}
