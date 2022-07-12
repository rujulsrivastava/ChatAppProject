import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageTile extends StatelessWidget {

  final String? message;
  final String? path;
  final String sender;
  final bool sentByMe;
  final Timestamp time;
  final int messageType; //0 for text, 1 for image
  // String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(time);

  MessageTile({this.message, required this.sender, required this.sentByMe, required this.time, required this.messageType, this.path});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: sentByMe ? 0 : 24,
          right: sentByMe ? 24 : 0),
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: messageType == 0 ? Container(
        margin: sentByMe ? const EdgeInsets.only(left: 30) : const EdgeInsets.only(right: 30),
        padding: const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: sentByMe ? const BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomLeft: Radius.circular(23)
          )
              :
          const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20)
          ),
          color: sentByMe ? const Color(0xFF043F4A) : Colors.grey[700],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(sender.toUpperCase(), textAlign: TextAlign.start, style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.orange, letterSpacing: -0.5,)),
            const SizedBox(height: 7.0),
            Text(message!, textAlign: TextAlign.start, style: const TextStyle(fontSize: 15.0, color: Colors.white)),
            Text(DateFormat('yyyy-MM-dd – kk:mm').format(time.toDate()).toString(), textAlign: TextAlign.start, style: const TextStyle(fontSize: 12.0, color: Colors.white))
          ],
        ),
      ) :
          Container(
            margin: sentByMe ? const EdgeInsets.only(left: 30) : const EdgeInsets.only(right: 30),
            padding: const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: sentByMe ? const BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23)
              )
                  :
              const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20)
              ),
              color: sentByMe ? const Color(0xFF043F4A) : Colors.grey[700],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(sender.toUpperCase(), textAlign: TextAlign.start, style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.orange, letterSpacing: -0.5,)),
                const SizedBox(height: 7.0),
                Container(child: ClipRRect(
                  // borderRadius: BorderRadius.circular(50),
                  child: Image.network(path!, width: 120,
                    height: 120,
                    fit: BoxFit.cover,),)),
                // Text(message, textAlign: TextAlign.start, style: const TextStyle(fontSize: 15.0, color: Colors.white)),
                Text(DateFormat('yyyy-MM-dd – kk:mm').format(time.toDate()).toString(), textAlign: TextAlign.start, style: const TextStyle(fontSize: 12.0, color: Colors.white))
              ],
            ),
          )
    );
  }
}
