// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chatify/widgets/messagebubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:chatify/services/chat_service.dart';
import 'package:chatify/widgets/customtextfield.dart';

class ChaatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;
  // final String imageUrl;
  final String receiverName;
  const ChaatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverId,
    required this.receiverName,
    // required this.imageUrl,
  });

  @override
  State<ChaatPage> createState() => _ChaatPageState();
}

class _ChaatPageState extends State<ChaatPage> {
  final _messageController = TextEditingController();

  final _chatService = ChatService();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //send message
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverId, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.onInverseSurface,
        backgroundColor: Theme.of(context).colorScheme.primary,
        // leading: CircleAvatar(
        //   foregroundImage: NetworkImage(imageUrl),
        //   radius: MediaQuery.of(context).size.width * 0.07,
        //   child: const Icon(Icons.person),
        // ),
        title: Text(widget.receiverName,
            style: GoogleFonts.firaSans(
              fontSize: screenHeight * 0.03,
              fontWeight: FontWeight.w400,
            )),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _userInput(context),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderId = _auth.currentUser!.uid;
    return StreamBuilder(
        stream: _chatService.getMessages(widget.receiverId, senderId),
        builder: (context, snapshot) {
          //error
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong!'));
          }
          //loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text('Loading....'));
          }

          return ListView(
            children: snapshot.data!.docs
                .map((doc) => _buildMessageBubble(doc))
                .toList(),
          );
        });
  }

  Widget _buildMessageBubble(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser = data['senderId'] == _auth.currentUser!.uid;

    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ChatBubble(
              isCurrentUser: isCurrentUser,
              message: data['message'],
            )
          ],
        ));
  }

  Widget _userInput(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(9.0),
        child: Row(
          children: [
            Expanded(
              child: CustomTextField(
                keyboardType: TextInputType.multiline,
                hintText: 'Type a message',
                controller: _messageController,
              ),
            ),
            SizedBox(width: screenWidth * 0.02),
            Container(
              margin: EdgeInsets.only(right: screenWidth * 0.005),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle),
              child: IconButton(
                icon: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                ),
                onPressed: sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
