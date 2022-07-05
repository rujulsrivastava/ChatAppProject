import 'package:chat_app_project/firebase_services/auth.dart';
import 'package:chat_app_project/firebase_services/database.dart';
import 'package:chat_app_project/pages/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_project/customs/group_tile.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.userName}) : super(key: key);
  final String userName;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TextEditingController searchContact = TextEditingController();
  late final TabController _tabController = TabController(vsync: this, length: 2,);
  static FirebaseAuth auth = FirebaseAuth.instance;
  late Stream _groups;

  @override
  void initState() {
    super.initState();
    _getUserJoinedGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF274CE0),
        leading: Builder(
            builder: (context) =>
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                )),
        title: Text("Hi ${widget.userName}"),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Theme(
            data: Theme.of(context).copyWith(focusColor: Colors.white),
            child: Container(
              height: 48.0,
              alignment: Alignment.center,
              child: TabPageSelector(controller: _tabController),
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                signOut(context);
              },
              icon: const Icon(Icons.logout)),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Profile()));
              },
              icon: const Icon(Icons.person)),
        ],
      ),
      drawer: Drawer(
        width: MediaQuery
            .of(context)
            .size
            .width / 2,
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
        child: Column(

            children: [
              Container(child: SingleChildScrollView(scrollDirection: Axis.vertical, child: renderUserGroups())),
              const Divider(thickness: 1,),
              Container(child: SingleChildScrollView(scrollDirection: Axis.vertical, child: renderAllGroups())),
              // height: MediaQuery.of(context).size.height / 4,
            ]),
      ),

      floatingActionButton: FloatingActionButton(
          onPressed: () {
            createGroupDialog();
          },
          child: const Icon(Icons.add)),
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
            onPressed: () {
              createGroup(controller.text, auth.currentUser!.displayName!,
                  auth.currentUser!.uid);
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.check)),
      ],
    );
    showDialog(context: context, builder: (context) => alert);
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
              return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data['usergroups'].length,
                shrinkWrap: true,
                  itemBuilder: (context, index) {
                    int reqIndex =
                        snapshot.data['usergroups'].length - index - 1;
                    return GroupTile(
                        userName: auth.currentUser!.displayName!,
                        groupId: _destructureId(
                            snapshot.data['usergroups'][reqIndex]),
                        groupName: _destructureName(
                            snapshot.data['usergroups'][reqIndex]));

                  }

                  );
            } else {
              return const Center(
                  child: Text(
                      "You haven't joined any groups. Join or create onee!"));
            }
          } else {
            return const Center(
                child:
                Text(
                    "You haven't joined any groups. Join or create one now!"));
          }
        } else {
          return const Center(child: Text("unable to fetch data"));
        }
      },
    );
  }

  String _destructureId(String res) {
    // print(res.substring(0, res.indexOf('_')));
    return res.substring(0, res.indexOf('_'));
  }

  String _destructureName(String res) {
    // print(res.substring(res.indexOf('_') + 1));
    return res.substring(res.indexOf('_') + 1);
  }

  _getUserJoinedGroups() async {
    getUserGroups(auth.currentUser!.uid).then((snapshots) {
      // print(snapshots);
      setState(() {
        _groups = snapshots;
      });
    });
  }

  Widget renderAllGroups() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chatgroups').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
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
                    return GroupTile(
                      groupName: ds["groupName"],
                      groupId: ds.id,
                      userName: ds["createdBy"],
                    );
                  });
            }
          else {
            return const Text("No groups to be found");
          }

      } else {
        return const Center(
        child: CircularProgressIndicator()
        );
        }
      },
    );
  }
}
