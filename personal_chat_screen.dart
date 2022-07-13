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

class PersonalChatPage extends StatefulWidget {

  final String receiverName;
  final String senderID;
  final String receiverID;
  late String chatID;
  String? photoPath;

  PersonalChatPage({
    required this.receiverName,
    required this.senderID,
    required this.receiverID,
    required this.chatID,
    this.photoPath
  });

  @override
  _PersonalChatPageState createState() => _PersonalChatPageState();
}

class _PersonalChatPageState extends State<PersonalChatPage> {

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

      sendMessageInChat(widget.senderID, widget.receiverID, widget.chatID, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  _sendImage(String url) {
    if (_imageFile !=null) {
      Map<String, dynamic> chatMessageMap = {
        "path" : url,
        "sender": FirebaseAuth.instance.currentUser!.displayName,
        "time" : Timestamp.now(),
        "messageType" : 1
      };

      sendMessageInChat(widget.senderID, widget.receiverID, widget.chatID, chatMessageMap);
    }
  }

  @override
  void initState() {
    getUserPersonalMessages(widget.chatID).then((val) {
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
        leading: widget.photoPath == null ?
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 20.0,
            backgroundColor: Colors.white,
            child: Text(widget.receiverName.substring(0, 1).toUpperCase(), textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF043F4A),)),
          ),
        )
            : Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
          radius: 20.0,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(widget.photoPath!, width: 120,
                height: 120,
                fit: BoxFit.cover,),),
        ),
            ),
        title: Text(widget.receiverName, style: const TextStyle(color: Colors.white)),
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

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
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

  late File _imageFile;
  File? profilePhoto;
  final picker = ImagePicker();

  _attachImage(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 100,
          // color: Colors.amber,
          child: Center(
            child: Column (
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Pick image", style: TextStyle(fontSize: 15),),
                Row(
                  children: [
                    IconButton(onPressed: () {
                      pickImageFromCamera();
                      Navigator.of(context).pop();
                      }, icon: const Icon(Icons.camera_alt_outlined)),
                    const Text("From Camera"),
                  ],
                ),
                Row(
                  children: [
                    IconButton(onPressed: () {
                      pickImageFromGallery();
                      Navigator.of(context).pop();
                      }, icon: const Icon(Icons.photo)),
                    const Text("From Gallery"),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Future pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }

    if (pickedFile != null) {
      uploadImageToFirebase(_imageFile.path);
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
      uploadImageToFirebase(_imageFile.path);
    }
  }

  Future uploadImageToFirebase(String path) async {
    String fileName = basename(path);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('uploads/$fileName');
    UploadTask uploadTask = ref.putFile(_imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then(
            (value) => _sendImage(value)
    );
  }

}
