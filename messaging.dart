import 'package:cloud_firestore/cloud_firestore.dart';

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
      'userchats': FieldValue.arrayUnion([receiverID])
    });
  }
  if (receiverChats.contains(docID) != true) {
    await receiverDocRef.update({
      'userchats': FieldValue.arrayUnion([senderID])
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



}

