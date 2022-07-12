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

sendMessageInChat(String senderID, String receiverID, String docID, chatMessageData) async {
  CollectionReference personalchats = FirebaseFirestore.instance.collection('personalchats');

  DocumentReference senderDocRef = FirebaseFirestore.instance.collection('users').doc(senderID);
  DocumentSnapshot senderDocSnapshot = await senderDocRef.get();
  List<dynamic> senderChats= await senderDocSnapshot.get("userchats");

  DocumentReference receiverDocRef = FirebaseFirestore.instance.collection('users').doc(receiverID);
  DocumentSnapshot receiverDocSnapshot = await receiverDocRef.get();
  List<dynamic> receiverChats= await receiverDocSnapshot.get("userchats");

  if (senderChats.contains(docID) != true) {
    await senderDocRef.update({
      'userchats': FieldValue.arrayUnion([docID])
    });
  }
  if (receiverChats.contains(docID) != true) {
    await receiverDocRef.update({
      'userchats': FieldValue.arrayUnion([docID])
    });
  }

  personalchats.doc(docID)
      .collection('messages')
      .add(chatMessageData);

  personalchats.doc(docID)
      .update({
    'recentMessage': chatMessageData['message'] ?? chatMessageData['path'],
    'recentMessageSender': chatMessageData['sender'],
    'recentMessageTime': chatMessageData['time']
  });
  // DocumentSnapshot d = await personalchats.doc(docID).get();
  // if (d["peer1"] == null) {
  //   await senderDocRef.update({
  //     'peer1': senderDocSnapshot["userName"]
  //   });
  // }
  // if (d["peer2"] == null) {
  //   await senderDocRef.update({
  //     'peer2': receiverDocSnapshot["userName"]
  //   });
  // }


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
