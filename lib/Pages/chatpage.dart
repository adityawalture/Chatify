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

  //for textfield focus
  // FocusNode myFocusNode = FocusNode();

  // @override
  // void initState() {
  //   super.initState();

  //   //listner to focus node
  //   myFocusNode.addListener(
  //     () {
  //       //delay so that keyboard has time to show up
  //       if (myFocusNode.hasFocus) {
  //         Future.delayed(
  //           const Duration(microseconds: 500),
  //           () => scrollDown(),
  //         );
  //       }
  //     },
  //   );

  //   //listview to be built, then scroll bottom
  //   Future.delayed(
  //     const Duration(milliseconds: 500),
  //     () => scrollDown(),
  //   );
  // }

  // @override
  // void dispose() {
  //   myFocusNode.dispose();
  //   _messageController.dispose();
  //   super.dispose();
  // }

  // //scroll controller
  // final ScrollController _scrollController = ScrollController();
  // void scrollDown() {
  //   _scrollController.animateTo(
  //     _scrollController.position.maxScrollExtent,
  //     duration: const Duration(seconds: 1),
  //     curve: Curves.fastOutSlowIn,
  //   );
  // }

  //send message
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        await _chatService.sendMessage(
          widget.receiverId,
          _messageController.text,
        );
        _messageController.clear();
        // scrollDown();
      } else {
        debugPrint('Current user is null');
      }
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
    //---------------------
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return const Center(child: Text('User not authenticated!'));
    }
    //--------------------------------
    String senderId = currentUser.uid;
    return StreamBuilder<QuerySnapshot>(
        stream: _chatService.getMessages(widget.receiverId, senderId),
        builder: (context, snapshot) {
          //error
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong!'));
          }
          //loading
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return const Center(child: Text('Loading....'));
          // }
          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No messages.'));
          }

          return ListView(
            // controller: _scrollController,
            children: snapshot.data!.docs
                .map((doc) => _buildMessageBubble(doc))
                .toList(),
          );
        });
  }

  Widget _buildMessageBubble(DocumentSnapshot doc) {
    //------------------------------
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      debugPrint('build message bubble error');
      return const SizedBox.shrink();
    }
    //-------------------------------
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser = data['senderId'] == currentUser.uid;

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
              messageId: doc.id,
              userId: data['senderId'],
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
                // focusNode: myFocusNode,
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
