import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app_project/firebase_services/database.dart';
import 'package:chat_app_project/customs/message_tile.dart';

import '../firebase_services/messaging.dart';

class PersonalChatPage extends StatefulWidget {

  final String receiverName;
  // final String senderName;
  final String senderID;
  final String receiverID;
  late String chatID;

  PersonalChatPage({
    required this.receiverName,
    // required this.senderName,
    required this.senderID,
    required this.receiverID,
    required this.chatID,
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
              return MessageTile(
                  message: snapshot.data?.docs[index].data()["message"],
                  sender: snapshot.data?.docs[index].data()["sender"],
                  sentByMe: FirebaseAuth.instance.currentUser!.displayName == snapshot.data?.docs[index].data()["sender"],
                  time: snapshot.data?.docs[index].data()["time"]
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
        "time" : Timestamp.now()
      };

      sendMessageInChat(widget.chatID, widget.receiverID, widget.chatID, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserPersonalMessages(widget.chatID).then((val) {
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
}