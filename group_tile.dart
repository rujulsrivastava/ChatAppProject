import 'package:flutter/material.dart';
import 'package:chat_app_project/pages/chat_screen.dart';
class GroupTile extends StatelessWidget {
  late String userName;
  late String groupName;
  final String groupId;

  GroupTile({required this.groupName, required this.userName, required this.groupId
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(
          groupId: groupId, userName: userName, groupName: groupName,
        )));
      },
      child: SizedBox (
        height: MediaQuery.of(context).size.height/4,
        width: MediaQuery.of(context).size.height/4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            tileColor: const Color(0xFF832136),
            // leading: Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     CircleAvatar(
            //       radius: 20.0,
            //       backgroundColor: Colors.white,
            //       child: Text(groupName.substring(0, 1).toUpperCase(), textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF043F4A),)),
            //     ),
            //   ],
            // ),
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
