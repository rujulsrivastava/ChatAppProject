import 'package:chat_app_project/firebase_services/auth.dart';
import 'package:chat_app_project/firebase_services/database.dart';
import 'package:chat_app_project/pages/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_project/firebase_services/messaging.dart';
import 'package:chat_app_project/customs/group_tile.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.username}) : super(key: key);
  final String username;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchContact = TextEditingController();
  Messaging messaging = Messaging();
  static FirebaseAuth auth = FirebaseAuth.instance;
  // String userName = auth.currentUser!.displayName!=null ? auth.currentUser!.displayName : "randomusername";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
            builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                )),
        title: Text("Hi ${widget.username}"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                googleSignOut(context);
              },
              icon: const Icon(Icons.logout)),
          IconButton(
              onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile()));
            },
              icon: const Icon(Icons.person)),
        ],
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width / 2,
        elevation: 2,
        child: Column(
          children: const [
            Text("My Groups", style: TextStyle(fontSize: 20)),
            Divider(
              height: 2,
              color: Colors.black87,
            ),
            Text("My Collections", style: TextStyle(fontSize: 20)),
            Divider(
              height: 2,
              color: Colors.black87,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: renderGroups(),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () { createGroupDialog(); },
      child: const Icon(Icons.add)),
    );
  }

  createGroupDialog() {
    TextEditingController controller = TextEditingController();
    AlertDialog alert = AlertDialog(
      title: const Text("Create a group chat!"),
      content: Column(
        children: [
          TextField(controller: controller, decoration: const InputDecoration(hintText: "Add a group name"),),
        ],
      ),
      actions: [
        IconButton(onPressed: () {
          createGroup(controller.text, auth.currentUser!.displayName!);
          Navigator.of(context).pop();

          },
            icon: const Icon(Icons.check)),
      ],
    );
    showDialog(context: context, builder: (context) => alert) ;
  }

  Widget renderGroups() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chatgroups').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Text("No groups");
          // if(snapshot.data!['chatgroups'] != null) {
          // print(snapshot.data['groups'].length);
          // if(snapshot.data['groups'].length != 0) {
        } else {
          return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                DocumentSnapshot ds =
                    snapshot.data?.docs[index] as DocumentSnapshot<Object?>;
                return GroupTile(
                  groupName: ds["groupName"],
                  // userName: auth.currentUser!.displayName!,
                );
              });
        }
        //   else {
        //     return Text("No groups");
        //   }
        // }
        // else {
        //   return Text("No groups");
        // }
        // }
        // else {
        //   return const Center(
        //       child: CircularProgressIndicator()
        //   );
        // }
      },
    );
  }
}
