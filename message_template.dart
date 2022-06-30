import 'dart:core';

class MessageTemplate {
  final String userID;
  final String userName;
  final String roomID;
  final int messageType;
  final String message;
  final DateTime dateOfCreation;

  MessageTemplate({required this.userID, required this.userName, required this.roomID, required this.messageType, required this.message,
      required this.dateOfCreation});

  Map<String, dynamic> convertToJson() => {
    'userID' : userID,
    'userName' : userName,
    'roomID' : roomID,
    'messageType' : messageType,
    'message' : message,
    'dateOfCreation' : dateOfCreation.toUtc()
  };

  static MessageTemplate convertFromJson(Map<String, dynamic>json ) => MessageTemplate(
    userID: json['userID'],
    userName: json['userName'],
    roomID: json['roomID'],
    messageType: json['messageType'],
    message: json['message'],
    dateOfCreation: json['dateOfCreation'].toDate()
  );
}

class MessageType {
  static const int text = 0;
  static const int image = 1;
  static const int video = 2;
}