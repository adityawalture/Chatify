import 'package:chatify/services/chat_service.dart';
import 'package:chatify/widgets/customsnackbar.dart';
import 'package:chatify/widgets/usertile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BlockedUsersPage extends StatelessWidget {
  BlockedUsersPage({super.key});

  final ChatService chatService = ChatService();
  final authService = FirebaseAuth.instance;

  //unblock box
  void _showUnblockBox(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Unblock User"),
        content: const Text("Are you sure you ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              chatService.unblockUser(userId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  const CustomSnackBar(message: 'User Unblocked').snackbar);
            },
            child: const Text("Unblock"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    String userId = authService.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onInverseSurface,
        title: Text(
          'Blocked Users',
          style: GoogleFonts.firaSans(
            fontSize: screenHeight * 0.03,
            fontWeight: FontWeight.w400,
            // color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: StreamBuilder(
          stream: chatService.getBlockedUsers(userId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong!'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final blockedUsers = snapshot.data ?? [];

            //no users
            if (blockedUsers.isEmpty) {
              return const Center(
                child: Text('No blocked users'),
              );
            }

            return ListView.builder(
                itemCount: blockedUsers.length,
                itemBuilder: (context, index) {
                  final user = blockedUsers[index];
                  return UserTile(
                    name: user['username'],
                    imageUrl: user['profilePic'],
                    onTap: () => _showUnblockBox(context, user['uid']),
                  );
                });
          }),
    );
  }
}
