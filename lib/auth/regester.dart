import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/auth/authservice.dart';
import 'package:whatsapp/auth/login1screen.dart';
import 'package:whatsapp/screen/userScreen.dart';

class regesterscreen extends StatefulWidget {
  const regesterscreen({super.key});

  @override
  State<regesterscreen> createState() => _regesterscreenState();
}

class _regesterscreenState extends State<regesterscreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController firstnamecontroller = TextEditingController();
  TextEditingController groupnamecontroller = TextEditingController();

  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xff0A0E0F),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
              ),
              Text(
                "  Create an Account   ",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              Text(
                "    welocme to we-chat",
                style: TextStyle(
                    color: Color.fromARGB(255, 128, 122, 122), fontSize: 12),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Flexible(
                      child: textfeild(
                          controller: groupnamecontroller,
                          label: "Group Name")),
                  Flexible(
                      child: textfeild(
                          controller: firstnamecontroller,
                          label: "Your first name"))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              textfeild(
                controller: emailcontroller,
                label: "enter your email adress",
              ),
              textfeild(
                controller: passwordcontroller,
                label: "create a new password ",
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xff48A6C3),
                      borderRadius: BorderRadius.circular(13.0)),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xff48A6C3)),
                    onPressed: () async {
                      email = emailcontroller.text.toString();
                      password = emailcontroller.text.toString();
                      try {
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
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
                      FirebaseFirestore.instance.collection('user').add({
                        'groupname': groupnamecontroller.text.toString(),
                        'firstname': firstnamecontroller.text.toString(),
                        'email': emailcontroller.text.toString()
                      });
                    },
                    child: Text("register account"),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    " Already a we-chat user",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => loginScreen()));
                      },
                      child: Text(
                        'sign up',
                        style: TextStyle(color: Colors.green),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
