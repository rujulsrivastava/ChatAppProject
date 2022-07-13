import 'dart:async';

import 'package:chat_app_project/firebase_services/auth.dart';
import 'package:chat_app_project/firebase_services/database.dart';
import 'package:chat_app_project/pages/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_project/customs/chats_tile.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.userName}) : super(key: key);
  final String userName;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TextEditingController searchContact = TextEditingController();
  late final TabController tabController = TabController(
    vsync: this,
    length: 2,
  );
  static FirebaseAuth auth = FirebaseAuth.instance;

  Stream? _users;
  String? recName;

  @override
  void initState() {
    super.initState();
    _getAllUsers();
    _getUserChats();
    tabController.addListener(_handleTabIndex);
  }

  @override
  void dispose() {
    tabController.removeListener(_handleTabIndex);
    tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF274CE0),
        // leading: Builder(
        //     builder: (context) => IconButton(
        //       icon: const Icon(Icons.menu),
        //       onPressed: () {
        //         Scaffold.of(context).openDrawer();
        //       },
        //       // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        //     )),
        title: Text("Hi ${widget.userName}"),
        centerTitle: true,
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(icon: Icon(Icons.person)),
            Tab(icon: Icon(Icons.people)),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                signOut(context);
              },
              icon: const Icon(Icons.logout)),
          IconButton(
              onPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Profile()));
                });
              },
              icon: const Icon(Icons.person)),
        ],
      ),
      body: TabBarView(controller: tabController, children: [
        SingleChildScrollView(
            scrollDirection: Axis.vertical, child: renderUserChats()),
        SingleChildScrollView(
            scrollDirection: Axis.vertical, child: renderUserGroups()),
        // height: MediaQuery.of(context).size.height / 4,
      ]),
      floatingActionButton: bottomButtons(context),
    );
  }

  bottomButtons(BuildContext context) {
    return tabController.index == 0
        ? FloatingActionButton(
        heroTag: 'btn0',
        shape: const StadiumBorder(),
        onPressed: (){findUsersDialog(context);},
        elevation: 0,
        backgroundColor: Colors.redAccent,
        child: const Icon(
          Icons.edit,
          size: 20.0,
        ))
        : Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton(
          elevation: 0,
          heroTag: 'btn1',
          shape: const StadiumBorder(),
          onPressed: () {
            createGroupDialog();
          },
          backgroundColor: Colors.redAccent,
          child: const Icon(
            Icons.add,
            size: 20.0,
          ),
        ),
        const SizedBox(height: 8,),

        FloatingActionButton(
          elevation: 0,
          heroTag: 'btn2',
          shape: const StadiumBorder(),
          onPressed: () {
            findGroupsDialog(context);
          },
          backgroundColor: Colors.redAccent,
          child: const Icon(
            Icons.search,
            size: 20.0,
          ),
        ),
      ],
    );
  }

  createGroupDialog() {
    TextEditingController controller = TextEditingController();
    AlertDialog alert = AlertDialog(
      title: const Text("Create a group chat!"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Add a group name"),
          ),
        ],
      ),
      actions: [
        IconButton(
            onPressed: controller.text == null
                ? null
                : () {
              createGroup(controller.text, auth.currentUser!.displayName!,
                  auth.currentUser!.uid);
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.check)),
      ],
    );
    showDialog(context: context, builder: (context) => alert);
  }

  findUsersDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();
    AlertDialog alert = AlertDialog(
      title: const Text("New conversation"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // TextField(
          //   controller: controller,
          //   decoration: const InputDecoration(hintText: "Search now!"),
          // ),
          StreamBuilder(
            stream: _users,
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  // print("length is");
                  return SizedBox(
                    height: 400,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data?.docs.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = snapshot.data?.docs[index]
                          as DocumentSnapshot<Object?>;
                          // print(ds['photo']);
                          return PersonalChatTile(
                            photoPath: ds['photo'] ?? "",
                              senderID: auth.currentUser!.uid,
                              userName: auth.currentUser!.displayName!,
                              receiverID: ds.id,
                              receiverName: ds["userName"]);
                        }),
                  );
                } else {
                  return const Center(child: Text("Talk to someone!"));
                }
              } else {
                return const Center(child: Text("unable to fetch data"));
              }
            },
          ),
        ],
      ),
      actions: [
        IconButton(
            onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) { Navigator.of(context).pop();});
            },
            icon: const Icon(Icons.check)),
      ],
    );
    showDialog(context: context, builder: (context) => alert);
  }

  findGroupsDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();
    String searchText = '';
    AlertDialog alert = AlertDialog(
      title: const Text("Available groups"),
      content: SingleChildScrollView(
        child: Column(

          children: [
            // TextField(
            //   controller: controller,
            //   decoration: const InputDecoration(hintText: "Group name.."),
            //   onChanged: (value) {
            //     setState(() {
            //       searchText = value;
            //     });
            //   },
            // ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("chatgroups").snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List<DocumentSnapshot> documents = snapshot.data.docs;
                  return SizedBox(
                    height: 400,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: documents.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = documents[index];
                          List<dynamic> members = ds["members"];
                          print(members);
                          print(members.contains(auth.currentUser!.uid),);
                          return GroupChatTile(
                            groupName: ds["groupName"],
                            groupId: ds.id,
                            groupIcon: ds["groupIcon"] ?? "",
                            isUserJoined: members.contains(auth.currentUser!.uid),
                          );
                        }),
                  );


                } else {
                  return const Center(child: Text("unable to fetch data"));
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close)),
      ],
    );
    showDialog(context: context, builder: (context) => alert);
  }

  //first tab
  Widget renderUserChats() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("users").where("userchats", arrayContains: auth.currentUser!.uid).snapshots(),
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          // print("Hi");
          if (snapshot.data != null) {
            // print("length is");
            // print(snapshot.data['userchats'].length);
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    int reqIndex =
                        snapshot.data.docs.length - index - 1;
                    return PersonalChatTile(
                        senderID: auth.currentUser!.uid,
                        userName: auth.currentUser!.displayName!,
                        receiverID: snapshot.data.docs[reqIndex].id,
                        receiverName: snapshot.data.docs[reqIndex]["userName"],
                    photoPath: snapshot.data.docs[reqIndex]["photo"],);
                  });

          } else {
            return const Center(child: Text("Talk to someone!"));
          }
        } else {
          return const Center(child: Text("unable to fetch data"));
        }
      },
    );
  } //first tab

  //second tab
  Widget renderUserGroups() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.
      collection('chatgroups')
        .where('members', arrayContains: auth.currentUser!.uid)
        .snapshots(),
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
              return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    int reqIndex =
                        snapshot.data.docs.length - index - 1;
                    print(reqIndex);
                    return GroupChatTile(
                      isUserJoined: true,
                      groupIcon: snapshot.data.docs[reqIndex]['groupIcon'],
                        groupId:
                            snapshot.data.docs[reqIndex]['groupId'],
                        groupName:
                            snapshot.data.docs[reqIndex]['groupName']);
                  });

          } else {
            return const Center(
                child: Text(
                    "You haven't joined any groups. Join or create one now!"));
          }
        } else {
          return const Center(child: Text("unable to fetch data"));
        }
      },
    );
  } //second tab

  _getAllUsers() async {
    getAllUsers().then((snapshots) {
      // print(snapshots);
      setState(() {
        _users = snapshots;
      });
    });
  }

  _getUserChats() async {
    getUserChats(auth.currentUser!.uid).then((snapshots) {
      // print(snapshots);
      setState(() {
      });
    });
  }

}
