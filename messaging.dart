import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app_project/customs/message_template.dart';

sendMessage(String groupId, chatMessageData) {
  FirebaseFirestore.instance.collection('chatgroups').doc(groupId).collection('messages').add(chatMessageData);
  FirebaseFirestore.instance.collection('chatgroups').doc(groupId).update({
    'recentMessage': chatMessageData['message'],
    'recentMessageSender': chatMessageData['sender'],
    'recentMessageTime': chatMessageData['time']
  });
}

// class Messaging {
//   FirebaseAuth auth = FirebaseAuth.instance;
//   final database = FirebaseFirestore.instance;
//   late CollectionReference reference;
//
//   Future sendMessage(String message) async {
//     final finalMessage = MessageTemplate(
//         userID: auth.currentUser!.uid,
//         userName: auth.currentUser!.displayName!,
//         roomID: "public",
//         messageType: MessageType.text,
//         message: message.trim(),
//         dateOfCreation: DateTime.now());
//     try {
//       reference = database.collection("chatgroups");
//       await reference.add(finalMessage.convertToJson());
//       print("Successfully sent");
//     } catch (e) {
//       print("Message not sent, ${e.toString()}");
//     }
//   }
//
//   Stream<QuerySnapshot> getMessage(){
//     return database.collection("chatgroups")
//         .orderBy('dateOfCreation')
//         .snapshots();
//   }
//
// }
