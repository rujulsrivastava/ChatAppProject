import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app_project/customs/message_template.dart';

sendMessageInGroup(String groupId, chatMessageData) {
  FirebaseFirestore.instance.collection('chatgroups').doc(groupId).collection('messages').add(chatMessageData);
  FirebaseFirestore.instance.collection('chatgroups').doc(groupId).update({
    'recentMessage': chatMessageData['message'],
    'recentMessageSender': chatMessageData['sender'],
    'recentMessageTime': chatMessageData['time']
  });
}

sendMessageInChat(String senderID, String receiverID, String docID, chatMessageData) {
  CollectionReference personalchats = FirebaseFirestore.instance.collection('personalchats');
  CollectionReference users = FirebaseFirestore.instance.collection('personalchats');

  

  personalchats.doc(docID)
      .collection('messages')
      .add(chatMessageData);
  personalchats.doc(docID)
      .update({
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
