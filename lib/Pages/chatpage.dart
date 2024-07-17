import 'package:chatify/services/chat_service.dart';
import 'package:chatify/widgets/customtextfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChaatPage extends StatelessWidget {
  final String receiverName;
  final String imageUrl;
  ChaatPage({super.key, required this.receiverName, required this.imageUrl});

  final _messageController = TextEditingController();
  final _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //send message
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        _auth.currentUser!.uid,
        _messageController.text,
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onTertiary,
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.onInverseSurface,
        backgroundColor: Theme.of(context).colorScheme.primary,
        // leading: CircleAvatar(
        //   foregroundImage: NetworkImage(imageUrl),
        //   radius: MediaQuery.of(context).size.width * 0.07,
        //   child: const Icon(Icons.person),
        // ),
        title: Text(receiverName,
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
          __userInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderId = _auth.currentUser!.uid;
    return StreamBuilder(
        stream: _chatService.getMessages(receiverName, senderId),
        builder: (context, snapshot) {
          //error
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong!'));
          }
          //loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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

    return Text(data['message']);
  }

  Widget __userInput() {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            hintText: 'Type a message',
            controller: _messageController,
          ),
        ),
        IconButton(icon: const Icon(Icons.send_rounded), onPressed: sendMessage,),
      ],
    );
  }
}
