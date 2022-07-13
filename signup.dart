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
  late TextEditingController phoneOrEmailController = TextEditingController();

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
                      "Phone/Email", "Enter your phone number or email", phoneOrEmailController),
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
                           phoneOrEmailController.text.isNotEmpty
                        ? () async {
                      await signUp(context, phoneOrEmailController.text,
                          userNameController.text, pwdController.text);
                    }
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

