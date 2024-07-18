import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
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
      child: Text(
        message,
        style: GoogleFonts.firaSans(
          fontSize: screenHeight * 0.019,
          fontWeight: FontWeight.w400,
          // color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
