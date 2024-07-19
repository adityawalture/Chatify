import 'package:chatify/services/chat_service.dart';
import 'package:chatify/widgets/customsnackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String messageId;
  final String userId;
  final DateTime timestamp;
  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.messageId,
    required this.userId, required this.timestamp,
  });

  String formatTimestamp(DateTime timestamp) {
    final DateFormat formatter = DateFormat('h:mm a');
    return formatter.format(timestamp);
  }


  //show options
  void _showOptions(BuildContext context, String messageId, String userId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
            child: Wrap(
          children: [
            //report button
            ListTile(
              leading: const Icon(Icons.flag),
              title: const Text('Report'),
              onTap: () {
                Navigator.pop(context);
                _reportContent(context, messageId, userId);
              },
            ),
            //blocking user
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text('Block'),
              onTap: () {
                Navigator.pop(context);
                _blockUser(context, userId);
              },
            ),

            //cancel button
            ListTile(
              leading: const Icon(Icons.cancel_rounded),
              title: const Text('Cancel'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ));
      },
    );
  }

  //report
  void _reportContent(BuildContext context, String messageId, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Message'),
        content: const Text('Are you sure ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ChatService().reportUser(messageId, userId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const CustomSnackBar(message: 'Message Reported').snackbar,
              );
            },
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }

  //blocking
  void _blockUser(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Block User'),
        content: const Text('Are you sure ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ChatService().blockUser(userId);
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const CustomSnackBar(message: 'Blocked').snackbar,
              );
            },
            child: const Text('Block'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onLongPress: () {
        //show options
        _showOptions(context, messageId, userId);
      },
      child: Column(
        children: [
          Container(
            // width: screenWidth * 0.4,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            decoration: BoxDecoration(
              color: isCurrentUser
                  ? Theme.of(context).colorScheme.inversePrimary
                  : Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.only(
                topLeft: isCurrentUser
                    ? const Radius.circular(24)
                    : const Radius.circular(0),
                bottomLeft: isCurrentUser
                    ? const Radius.circular(24)
                    : const Radius.circular(12),
                topRight: isCurrentUser
                    ? const Radius.circular(0)
                    : const Radius.circular(24),
                bottomRight: isCurrentUser
                    ? const Radius.circular(12)
                    : const Radius.circular(24),
              ),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: screenWidth * 0.7,
              ),
              child: Text(
                message,
                style: GoogleFonts.firaSans(
                  fontSize: screenHeight * 0.019,
                  fontWeight: FontWeight.w400,
                  // color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            
          ),
          Text(
            formatTimestamp(timestamp),
            style: TextStyle(
              fontSize: screenHeight * 0.015,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
