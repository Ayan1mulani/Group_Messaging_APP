import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/auth/authservice.dart';
import 'package:whatsapp/screen/userScreen.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xff0A0E0F),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100),
              Text("  Sign up",
                  style: TextStyle(color: Colors.white, fontSize: 25)),
              Text(
                "    Nice to see you again",
                style: TextStyle(
                    color: Color.fromARGB(255, 128, 122, 122), fontSize: 12),
              ),
              textfeild(controller: emailcontroller, label: "enter your email"),
              textfeild(
                  controller: passwordcontroller,
                  label: "enter your password "),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff48A6C3),
                            foregroundColor: Colors.white),
                        onPressed: () async {
                          email = emailcontroller.text.toString();
                          password = emailcontroller.text.toString();
                          try {
                            UserCredential userCredential = await FirebaseAuth
                                .instance
                                .signInWithEmailAndPassword(
                                    email: email, password: password);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => userScreen()));
                            FirebaseAuth auth = FirebaseAuth.instance;
                            if (auth.currentUser != null) {
                              print(auth.currentUser?.email);
                            }
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Text("login")),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
