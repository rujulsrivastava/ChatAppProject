import 'package:flutter/material.dart';
import 'package:chat_app_project/pages/chat_screen.dart';
class GroupTile extends StatelessWidget {
  late String userName;
  late String groupName;

  GroupTile({required this.groupName
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen(
          // groupId: groupId, userName: userName, groupName: groupName,
        )));
      },
      child: ListTile(
        leading: CircleAvatar(
          radius: 20.0,
          backgroundColor: Colors.blueAccent,
          child: Text(groupName.substring(0, 1).toUpperCase(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
        ),
        title: Text(groupName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text("Join the conversation", style: TextStyle(fontSize: 10.0)),
      ),
    );
  }
}
