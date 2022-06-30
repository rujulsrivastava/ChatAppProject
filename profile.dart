import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
      ),
      body: renderProfile(),
    );
  }

  renderProfile() {
    TextEditingController userNameController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    return Center(
      child: Column(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.teal,
            radius: 30,
          ),
          TextFormField(
            initialValue: FirebaseAuth.instance.currentUser!.displayName,
            controller: userNameController,
            decoration: const InputDecoration(
              labelText: "Username",
            ),
          ),
          TextFormField(
            initialValue: FirebaseAuth.instance.currentUser!.email,
            decoration: const InputDecoration(
              labelText: "Email",
            ),
            readOnly: true,
          ),
          TextFormField(
            // initialValue: FirebaseAuth.instance.currentUser!.phoneNumber == null ?
            controller: phoneController,
            decoration: const InputDecoration(
              labelText: "Phone",
            ),
          ),
        ],
      ),
    );
  }

  updateData() {}
}
