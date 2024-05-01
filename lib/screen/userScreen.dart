import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/screen/chatscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: userScreen(),
    );
  }
}

class userScreen extends StatefulWidget {
  const userScreen({Key? key}) : super(key: key);

  @override
  State<userScreen> createState() => _userScreenState();
}

class _userScreenState extends State<userScreen> {
  late String? currentUserEmail;

  @override
  void initState() {
    super.initState();
    getCurrentUserEmail();
  }

  void getCurrentUserEmail() async {
    // Get current user's email from FirebaseAuth
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserEmail = user.email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF171B1D),
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            'All User Groups',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xff0A0E0F)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('user').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final messages = snapshot.data?.docs;

                return ListView.builder(
                  itemCount: messages?.length ?? 0,
                  itemBuilder: (context, index) {
                    final firstname = messages![index]['firstname'];
                    final email = messages[index]['email'];
                    final groupname = messages[index]['groupname'];

                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Chatscreen(
                              usergroup: groupname ?? "No Group Name",
                              userEmail: email ?? "No Email",
                            ),
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('images/1.jpg'),
                      ),
                      title: Text(
                        groupname ?? "No Group Name",
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        "Admin:: ${email ?? "No Email"}",
                        style: const TextStyle(
                            color: Color.fromARGB(255, 128, 122, 122),
                            fontSize: 10),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
