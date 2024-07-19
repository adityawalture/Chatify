import 'package:chatify/Pages/chatpage.dart';
import 'package:chatify/services/chat_service.dart';
import 'package:chatify/widgets/usertile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildUserList extends StatefulWidget {
  const BuildUserList({super.key});

  @override
  State<BuildUserList> createState() => _BuildUserListState();
}

class _BuildUserListState extends State<BuildUserList> {
  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onInverseSurface,
        title: Text(
          'च्याटify',
          style: GoogleFonts.firaSans(
            fontSize: screenHeight * 0.03,
            fontWeight: FontWeight.w400,
            // color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        child: const Icon(Icons.add),
      ),
      body: _buildUserList(),
    );
  }

  //list of users except for the current logged in user
  final ChatService _chatService = ChatService();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStreamExceptBlocked(),
      builder: (context, snapshot) {
        // if error
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text("Loading...."),
          );
        }

        //return list
        return ListView(
          children: snapshot.data!
              .map<Widget>(
                (userData) => _buildUserListItem(userData, context),
              )
              .toList(),
        );
      },
    );
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData['email'] != getCurrentUser()!.email) {
      return UserTile(
        imageUrl: userData['profilePic'] ?? '',
        name: userData['username'],
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChaatPage(
                  // receiverId: userData['receiverId'] ?? '',
                  // imageUrl: userData['profilePic'] ?? '',
                  receiverName: userData['username'],
                  receiverEmail: userData['email'],
                  receiverId: userData['uid'],
                ),
              ));
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
