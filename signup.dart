import 'package:chat_app_project/firebase_services/auth.dart';
import 'package:chat_app_project/pages/login.dart';
import 'package:flutter/material.dart';
import '../customs/custom_text_field.dart';


class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late TextEditingController userNameController = TextEditingController();
  late TextEditingController pwdController = TextEditingController();
  late TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Material(
      color: const Color(0xFF274CE0),
      child: Column(
        children: [
          Container(
            width: width,
            height: height * 0.25,
            alignment: Alignment.topLeft,
            color: const Color(0xFF274CE0),
            child: Padding(
              padding: EdgeInsets.only(left: width / 10, bottom: 23),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      padding: const EdgeInsets.all(0),
                      alignment: Alignment.topLeft,
                      color: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back)),
                  const Text("Sign Up",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            width: width,
            height: height * 0.75,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Padding(
              padding:
                  EdgeInsets.only(left: width / 10, right: width / 10, top: 23),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome",
                    style: TextStyle(
                      fontSize: 30,
                      color: Color(0xFF043F4A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  customTextField(
                      "Phone", "Enter your phone number", phoneController),
                  const SizedBox(height: 26),
                  customTextField(
                      "Username", "Enter your username", userNameController),
                  const SizedBox(height: 26),
                  customTextField(
                      "Password", "Enter your password", pwdController),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    height: 40,
                    minWidth: MediaQuery.of(context).size.width -
                        (2 * MediaQuery.of(context).size.width / 10),
                    onPressed: userNameController.text.isNotEmpty &&
                            pwdController.text.isNotEmpty &&
                            pwdController.text.isNotEmpty
                        ? () => signUp(context, phoneController.text,
                            userNameController.text, pwdController.text)
                        : null,
                    disabledColor: const Color(0xFF274CE0).withAlpha(60),
                    disabledTextColor: Colors.white,
                    color: const Color(0xFF274CE0),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text("Create my account"),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()));
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Already have an account account? ",
                            style: TextStyle(
                                color: Color(0xFF274CE0),
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "Sign in",
                            style: TextStyle(
                                color: Color(0xFF274CE0),
                                fontSize: 12,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class SignUp extends StatefulWidget {
//   const SignUp({Key? key}) : super(key: key);
//
//   @override
//   State<SignUp> createState() => _SignUpState();
// }
//
// class _SignUpState extends State<SignUp> {
//
//   final auth = FirebaseAuth.instance;
//
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController pwdController = TextEditingController();
//   TextEditingController userNameController = TextEditingController();
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         // backgroundColor: blueColor,
//         // appBar: AppBar(title: const Text("Sign Up For Capital"),),
//         body: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget> [
//               // TextField(controller: emailController, decoration: const InputDecoration(hintText: "Email ID"), keyboardType: TextInputType.emailAddress,),
//               TextField(controller: phoneController, decoration: const InputDecoration(hintText: "Phone"), keyboardType: TextInputType.phone, ),
//               TextField(controller: userNameController, decoration: const InputDecoration(hintText: "Username"), ),
//               TextField(controller: pwdController, decoration: const InputDecoration(hintText: "Password"), obscureText: true,),
//               ElevatedButton(
//                   // style: ButtonStyle(backgroundColor: blueColorMaterial, foregroundColor: whiteColorMaterial),
//                   child: const Text("Register"),
//                   onPressed: () async {
//                     await createAccount(context, phoneController.text, pwdController.text, userNameController.text);
//
//                     // try {
//                     //   await auth.verifyPhoneNumber(phoneNumber: phone,
//                     //       verificationCompleted: (PhoneAuthCredential cred) async {
//                     //     await auth.signInWithCredential(cred);
//                     //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(userName: username,)));},
//                     //       verificationFailed: (FirebaseAuthException authException) async {
//                     //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authException.toString())));},
//                     //       codeSent: (String verificationID, int? resendToken) {},
//                     //   codeAutoRetrievalTimeout: (String verificationID) {});
//                     // } catch (e) {
//                     //   print(e);
//                   }
//               ),
//             ]
//         )
//     );
//   }
// }
