import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chatscreen extends StatefulWidget {
  final String userEmail;
  final String usergroup;

  const Chatscreen({Key? key, required this.usergroup, required this.userEmail})
      : super(key: key);

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0A0E0F),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0XFF171B1D),
        title: Text(
          widget.usergroup,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .where('group', isEqualTo: widget.usergroup)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                List<Widget> messageWidgets = [];
                final messages = snapshot.data?.docs.reversed;

                if (messages != null) {
                  User? user = FirebaseAuth.instance.currentUser;
                  final currentuser = user?.email;
                  for (var message in messages) {
                    final messageText = message['text'];
                    final messageEmail = message['email'];
                    bool isCurrentUser = currentuser == messageEmail;

                    final messageWidget = Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: isCurrentUser
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: isCurrentUser
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isCurrentUser
                                          ? Color(0xff48A6C3)
                                          : Colors.grey,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      messageText ?? '',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!isCurrentUser &&
                              messageEmail !=
                                  null) // Display sender's email for messages sent by other user
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                "Message from: $messageEmail",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 128, 122, 122),
                                    fontSize: 10),
                              ),
                            ),
                        ],
                      ),
                    );

                    if (messageText != null && messageText.isNotEmpty) {
                      messageWidgets.add(messageWidget);
                    }
                  }
                }

                return ListView(
                  children: messageWidgets,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff383A40),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        controller: textEditingController,
                        decoration: InputDecoration(
                          hintText: 'Enter your message here',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      final auth = FirebaseAuth.instance;
                      if (auth.currentUser != null) {
                        final useremail = auth.currentUser?.email;

                        FirebaseFirestore.instance.collection('messages').add({
                          'text': textEditingController.text.toString(),
                          'email': useremail,
                          'group': widget.usergroup,
                        });

                        textEditingController.clear();
                      }
                    },
                    icon: Icon(
                      Icons.send,
                      color: const Color.fromARGB(255, 11, 255, 19),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
