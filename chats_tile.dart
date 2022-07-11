import 'package:flutter/material.dart';
import 'package:chat_app_project/pages/group_chat_screen.dart';

import '../pages/personal_chat_screen.dart';
class GroupChatTile extends StatelessWidget {
  late String groupName;
  final String groupId;

  GroupChatTile({Key? key, required this.groupName, required this.groupId
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => GroupChatPage(
          groupId: groupId, groupName: groupName,
        )));
      },
      child: SizedBox (
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            tileColor: const Color(0xFF832136),
            leading: CircleAvatar(
              radius: 20.0,
              backgroundColor: Colors.white,
              child: Text(groupName.substring(0, 1).toUpperCase(), textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF043F4A),)),
            ),


            title: Text(groupName, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            subtitle: const Text("Join the conversation", style: TextStyle(fontSize: 10.0, color: Colors.white)),
          ),
        ),
      ),
    );
  }
}

class PersonalChatTile extends StatefulWidget {
  late String userName;
  late String receiverName;
  final String senderID;
  final String receiverID;
  // late final chatID;

  PersonalChatTile({Key? key, required this.receiverName, required this.userName, required this.senderID, required this.receiverID
  }) : super(key: key);

  @override
  State<PersonalChatTile> createState() => _PersonalChatTileState();
}

class _PersonalChatTileState extends State<PersonalChatTile> {
  var chatID;
  setChatID() {
    if (widget.senderID.hashCode <= widget.receiverID.hashCode) {
      chatID = '${widget.senderID}-${widget.receiverID}-${widget.userName}-${widget.receiverName}';
    } else if (widget.senderID == widget.receiverID){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something is fishy..")));
    } else {
    chatID = '${widget.receiverID}-${widget.senderID}-${widget.receiverName}-${widget.userName}';
    }
  }

  @override
  void initState(){
    super.initState();
    if (widget.senderID.hashCode <= widget.receiverID.hashCode) {
      chatID = '${widget.senderID}-${widget.receiverID}-${widget.userName}-${widget.receiverName}';
    } else if (widget.senderID == widget.receiverID){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something is fishy..")));
    } else {
      chatID = '${widget.receiverID}-${widget.senderID}-${widget.receiverName}-${widget.userName}';
    }
  }

  @override
  Widget build(BuildContext context) {
    print("receiver id " + widget.receiverID);
    print("sender id " + widget.senderID);
    print("chat id " + chatID);
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalChatPage(senderID: widget.senderID,
          receiverID: widget.receiverID,
          receiverName: widget.receiverName, chatID: chatID,
        )));
      },
      child: SizedBox (
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            tileColor: const Color(0xFF832136),
            leading: CircleAvatar(
              radius: 20.0,
              backgroundColor: Colors.white,
              child: Text(widget.receiverName.substring(0, 1).toUpperCase(), textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF043F4A),)),
            ),


            title: Text(widget.receiverName, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
