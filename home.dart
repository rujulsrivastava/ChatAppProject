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
  late Stream _groups;
  late Stream _allGroups;
  Stream? _chats;
  late Stream _users;
  String? recName;
  List<DocumentSnapshot> _foundUsers = [];

  @override
  void initState() {
    super.initState();
    _getUserJoinedGroups();
    _getAllUsers();
    _getUserChats();
    _getAllGroups();
    // _foundUsers= _allGroups;
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
        leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            )),
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
      body: TabBarView(controller: tabController, children: [
        SingleChildScrollView(
            scrollDirection: Axis.vertical, child: renderUserChats()),
        SingleChildScrollView(
            scrollDirection: Axis.vertical, child: renderUserGroups()),
        // height: MediaQuery.of(context).size.height / 4,
      ]),
      floatingActionButton: bottomButtons(),
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

  findUsersDialog() {
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
                  print("length is");
                  return Container(
                    height: 400,
                    width: 200,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data?.docs.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = snapshot.data?.docs[index]
                          as DocumentSnapshot<Object?>;
                          return PersonalChatTile(
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
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.check)),
      ],
    );
    showDialog(context: context, builder: (context) => alert);
  }

  findGroupsDialog() {
    TextEditingController controller = TextEditingController();
    String searchText = '';
    AlertDialog alert = AlertDialog(
      title: const Text("Available groups"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                  // if (searchText.isNotEmpty) {
                  //   documents = documents.where((element) {
                  //     return element
                  //         .get('groupName')
                  //         .toString()
                  //         .contains(searchText);
                  //   }).toList();
                  // }

                  print("length issss");
                  print(documents.length);
                  print(documents.first.data());

                  return Container(
                    height: 400,
                    width: 200,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: documents.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = documents[index];
                          return GroupChatTile(
                            groupName: ds["groupName"],
                            groupId: ds.id,
                            groupIcon: ds["groupIcon"] ?? "",
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

  Widget renderUserChats() {
    return StreamBuilder(
      stream: _chats,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          print("Hi");
          if (snapshot.data['userchats'] != null) {
            print("length is");
            print(snapshot.data['userchats'].length);
            if (snapshot.data['userchats'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data['userchats'].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    int reqIndex =
                        snapshot.data['userchats'].length - index - 1;
                    return PersonalChatTile(
                        senderID: auth.currentUser!.uid,
                        userName: auth.currentUser!.displayName!,
                        receiverID: _destructureChatReceiverId(
                            snapshot.data['userchats'][reqIndex]),
                        receiverName: _destructureChatReceiverName(
                            snapshot.data['userchats'][reqIndex]));
                  });
            } else {
              return const Center(child: Text("You haven't talked to anyone."));
            }
          } else {
            return const Center(child: Text("Talk to someone!"));
          }
        } else {
          return const Center(child: Text("unable to fetch data"));
        }
      },
    );
  }

  Widget renderAllUsers() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          // print(snapshot.data!['chatgroups'].length);
          if (snapshot.data?.size != 0) {
            return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data?.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds =
                  snapshot.data?.docs[index] as DocumentSnapshot<Object?>;
                  return PersonalChatTile(
                    senderID: auth.currentUser!.uid,
                    receiverID: ds.id,
                    receiverName: ds["userName"],
                    userName: auth.currentUser!.displayName!,
                  );
                });
          } else {
            return const Text("No users to be found");
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget renderUserGroups() {
    return StreamBuilder(
      stream: _groups,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['usergroups'] != null) {
            print("length is");
            print(snapshot.data['usergroups'].length);
            if (snapshot.data['usergroups'].length != 0) {
              print("Reached here as well");
              return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data['usergroups'].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    int reqIndex =
                        snapshot.data['usergroups'].length - index - 1;
                    print(reqIndex);
                    return GroupChatTile(
                        groupId: _destructureGroupId(
                            snapshot.data['usergroups'][reqIndex]),
                        groupName: _destructureGroupName(
                            snapshot.data['usergroups'][reqIndex]));
                  });
            } else {
              return const Center(
                  child: Text(
                      "You haven't joined any groups. Join or create onee!"));
            }
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
  }

  bottomButtons() {
    return tabController.index == 0
        ? FloatingActionButton(
        shape: const StadiumBorder(),
        onPressed: findUsersDialog,
        backgroundColor: Colors.redAccent,
        child: const Icon(
          Icons.edit,
          size: 20.0,
        ))
        : Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
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
        const SizedBox(width: 8,),

        FloatingActionButton(
          shape: const StadiumBorder(),
          onPressed: () {
            findGroupsDialog();
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

  _getUserJoinedGroups() async {
    getUserGroups(auth.currentUser!.uid).then((snapshots) {
      // print(snapshots);
      setState(() {
        _groups = snapshots;
      });
    });
  }

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
        _chats = snapshots;
      });
    });
  }

  _getAllGroups() async {
    getAllGroups().then((snapshots) {
      // print(snapshots);
      setState(() {
        _allGroups = snapshots;
      });
    });
  }

  String _destructureGroupId(String res) {
    // print(res.substring(0, res.indexOf('_')));
    return res.substring(0, res.indexOf('_'));
  }

  String _destructureGroupName(String res) {
    // print(res.substring(res.indexOf('_') + 1));
    return res.substring(res.indexOf('_') + 1);
  }

  String _destructureChatReceiverId(String res) {
    List<String> s = res.split("-");
    if (auth.currentUser!.uid == s[0]) {
      return s[1];
    } else {
      return s[0];
    }
  }

  String _destructureChatReceiverName(res) {
    List<String> s = res.split("-");
    if (auth.currentUser!.displayName! == s[2]) {
      return s[3];
    } else {
      return s[2];
    }
  }
}
