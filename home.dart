import 'package:flutter/material.dart';
import 'package:chat_app_project/groups/list_of_groups.dart' as group;

class Home extends StatefulWidget {
  const Home({Key? key, this.username}) : super(key: key);
  final String? username;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchContact = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context)
            => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () { Scaffold.of(context).openDrawer(); },
              // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            )
        ),
        title: Text("Hi $widget.username"),
        centerTitle: true,
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width/2,
        elevation: 2,
        child: Row(
          children: const [
            Text("My Groups", style: TextStyle(fontSize: 35)),
            Divider(height: 2, color: Colors.black87,),
            Text("My Collections", style: TextStyle(fontSize: 35)),
            Divider(height: 2, color: Colors.black87,),
          ],
        ),
      ),

      body: Column(
        children: [
          Container(
            color: Colors.teal,
            height: MediaQuery.of(context).size.height/6,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                TextField(
                  // style: const TextStyle(color: Colors.black, backgroundColor: Colors.white),
                  controller: searchContact,
                  decoration: const InputDecoration(
                      hintText: "Search for a group..",
                      hintStyle: TextStyle(color: Colors.black12),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black87, width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black87, width: 1))),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.chat_bubble)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.person)),

              ],
            ),
          ),
          ListView.builder(
              itemCount: group.groupsList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Title: ${group.groupsList[index]?.title}"),
                      Text("Title: ${group.groupsList[index]?.description}"),
                      const Divider(height: 2, color: Colors.black87,)
                    ],
                  ),
                );
              }
          ),
          searchBar(context, searchContact),
          renderChats(context),


        ],
      )

    );
  }
  Widget searchBar(BuildContext context, TextEditingController controller){
    return Container(
      color: Colors.teal,
      height: MediaQuery.of(context).size.height/8,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
          TextField(
            style: const TextStyle(color: Colors.black, backgroundColor: Colors.white),
            controller: controller,
            decoration: const InputDecoration(
                hintText: "Search for a group..",
                hintStyle: TextStyle(color: Colors.black12),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87, width: 1)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87, width: 1))),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.chat_bubble)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.person)),

        ],
      ),
    );
  }
  Widget renderChats(BuildContext context) {
    return ListView.builder(
        itemCount: group.groupsList.length,
        itemBuilder: (context, int index) {
          return SizedBox(
            height: MediaQuery.of(context).size.height/8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Title: ${group.groupsList[index]?.title}"),
                Text("Title: ${group.groupsList[index]?.description}"),
                const Divider(height: 2, color: Colors.black87,)
              ],
            ),
          );
        }
    );
  }
}





