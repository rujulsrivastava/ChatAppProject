import 'package:chat_app_project/firebase_services/auth.dart';
import 'package:chat_app_project/pages/signup.dart';
import 'package:chat_app_project/pages/splash.dart';
import 'package:flutter/material.dart';
import '../customs/custom_text_field.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController emailController = TextEditingController();
  late TextEditingController pwdController = TextEditingController();
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
              padding: EdgeInsets.only(left: width / 10, bottom: 25),
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
                  const Text("Sign In",
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
              padding: EdgeInsets.only(left: width / 10, right: width/10, top: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome back",
                    style: TextStyle(
                      fontSize: 30,
                      color: Color(0xFF043F4A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    "Sign in to continue",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  customTextField("Email", "Enter your email ID", emailController),
                  const SizedBox(height: 26),
                  customTextField("Password", "Enter your password", pwdController),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: GestureDetector(
                      onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const Splash()));},
                      child: const Text("Forgot password?",
                        style: TextStyle(color: Color(0xFF274CE0), fontSize: 13, fontWeight: FontWeight.w800),),
                    ),
                  ),
              const SizedBox(height: 20,),
              MaterialButton(
                height: 40,
                minWidth: MediaQuery.of(context).size.width-(2*MediaQuery.of(context).size.width/10),
                onPressed: emailController.text.isNotEmpty && pwdController.text.isNotEmpty ? () async {

                  await signInWithEmail(context, emailController.text, pwdController.text);
                } : null,
                disabledColor: const Color(0xFF274CE0).withAlpha(60),
                disabledTextColor: Colors.white,
                color: const Color(0xFF274CE0),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: const Text("Sign In"),
              ),
                  const SizedBox(height: 40,),
                  GestureDetector(
                      onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUp()));},
                      child:
                      Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Don't have an account? ",
                        style: TextStyle(color: Color(0xFF274CE0), fontSize: 12, fontWeight: FontWeight.w400),),
                      Text("Sign up",
                          style: TextStyle(color: Color(0xFF274CE0), fontSize: 12, fontWeight: FontWeight.w800),),
                    ],
                  )
                  )
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
