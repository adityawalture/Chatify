// import 'package:chatify/Pages/chatScreen.dart';
import 'package:chatify/Pages/chatpage.dart';
import 'package:chatify/Pages/loadingScreen.dart';
import 'package:chatify/Pages/paymentpage.dart';
import 'package:chatify/Pages/settingspage.dart';
import 'package:chatify/services/chat_service.dart';
import 'package:chatify/widgets/customnavigationbar.dart';
// import 'package:chatify/widgets/userslist.dart';
import 'package:chatify/widgets/usertile.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectIndex = 0;

  late List<Widget> listScreens;

  @override
  void initState() {
    super.initState();
    listScreens = [
      _buildUserList(),
      const Paymentpage(),
      const SettingsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onTertiary,
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
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.logout_rounded,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        child: const Icon(Icons.add),
      ),
      body: listScreens[_selectIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectIndex,
        onItemTapped: (int index) {
          setState(() {
            _selectIndex = index;
          });
        },
      ),
    );
  }

  //list of users except for the current logged in user
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUserStream(),
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
                  imageUrl: userData['profilePic'] ?? '',
                  receiverName: userData['username'],
                ),
              ));
        },
      );
    } else {
      return Container();
    }
  }
}
