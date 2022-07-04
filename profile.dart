
import 'package:chat_app_project/firebase_services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../customs/user_model.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}
final userRef = FirebaseFirestore.instance.collection("users");
class _ProfileState extends State<Profile> {

  var userNameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Material(
      color: const Color(0xFF274CE0),
      child: Scaffold(
          backgroundColor: const Color(0xFF274CE0),
          body :
          SingleChildScrollView(
            child: Column(
                children: [
                  Container(
                    width: width,
                    height: height / 6,
                    alignment: Alignment.center,
                    color: const Color(0xFF274CE0),
                    child: Padding(
                      padding: EdgeInsets.only(left: width / 10, bottom: 23, top: height/15, right: width/10),
                      child: Center(
                        child: Row(
                          children: [
                            IconButton(
                                padding: const EdgeInsets.all(0),
                                alignment: Alignment.center,
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.arrow_back)),
                            SizedBox(width: 30),
                            Text("My Profile",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: width/11.5,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: width,
                    height: height * 0.7,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Padding(
                      padding:
                      EdgeInsets.only(left: width / 10, right: width / 10, top: 23),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          renderProfile(context),

                        ],
                      ),
                    ),
                  ),]),
          )
      ),
    );
  }

  renderProfile(BuildContext context) {
    return FutureBuilder(
      future: userRef.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Text("Data not found");
        }
        else {
          Map<String, dynamic> data = snapshot.data.data();
          MyUser user = MyUser.fromMap(data);
          userNameController.text = user.userName;
          phoneController.text = user.phone ?? "";
          emailController.text = user.email ?? "";
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: CircleAvatar(
                  backgroundColor: Colors.teal,
                  radius: 50,
                ),
              ),

              Column(
                  children: [
                    TextField(
                      controller: userNameController,
                      decoration: const InputDecoration(
                        labelText: "Username",
                      ),
                    ),
                    const SizedBox(height: 35,),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                      ),
                    ),
                    const SizedBox(height: 35,),

                    TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        labelText: "Phone",
                      ),
                    ),
                    const SizedBox(height: 30,),
                    MaterialButton(
                      height: 40,
                      minWidth: MediaQuery.of(context).size.width -
                          (2 * MediaQuery.of(context).size.width / 10),
                      onPressed: userNameController.text.isNotEmpty &&
                          (phoneController.text.isNotEmpty ||
                              emailController.text.isNotEmpty)
                          ? () => updateProfileData(userNameController.text,
                          phoneController.text,
                          emailController.text)
                          : null,
                      disabledColor: const Color(0xFF274CE0).withAlpha(60),
                      disabledTextColor: Colors.white,
                      color: const Color(0xFF274CE0),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: const Text("Update profile"),
                    ),])
            ],
          );
        }
      },
    );
  }

// renderAppBar(BuildContext context) {
//   double height = MediaQuery.of(context).size.height;
//   double width = MediaQuery.of(context).size.width;
//   return PreferredSize(
//     preferredSize: Size.fromHeight(height/7),
//     child: Center(
//       child: AppBar(
//         elevation: 0,
//         leadingWidth: 200,
//         // centerTitle: true,
//         backgroundColor: const Color(0xFF274CE0),
//         title: Padding(
//           padding: EdgeInsets.only(top: height/14),
//           child: Text("My Profile", style: TextStyle(fontSize: 33)),
//         ),
//       ),
//     ),
//   );
// }
}
