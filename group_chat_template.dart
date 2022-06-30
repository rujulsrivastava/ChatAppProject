import 'package:chat_app_project/customs/message_template.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class GroupChatMessage extends StatelessWidget {
  GroupChatMessage({Key? key, required this.message}) : super(key: key);
  final MessageTemplate message;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {


    return Container(
      child: getGroupChatMessage(),
    );
  }

  getGroupChatMessage() {
    return message.userID != auth.currentUser!.uid ?
    Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // CustomImage(
        //   this.message.userId.toString(),
        //   width: 40,
        //   height: 40,
        // ),
        const SizedBox(width: 5,),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.lightGreen.shade50,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20) ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message.userName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),),
              const SizedBox(height: 5,),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: message.message, style: const TextStyle(fontSize: 14, color: Colors.black),),
                    const TextSpan(text: "   "),
                    TextSpan(text: message.dateOfCreation.toString(), style: const TextStyle(fontSize: 12, color: Colors.grey),),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    )

        :

    Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(20) ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: message.message, style: const TextStyle(fontSize: 15, color: Colors.black),),
                    const TextSpan(text: "   "),
                    TextSpan(text: message.dateOfCreation.toString(), style: const TextStyle(fontSize: 13, color: Colors.grey),),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

}

