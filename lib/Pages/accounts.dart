import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user;
  Map<String, dynamic>? userData;

  Future<void> fetchUserData() async {
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user!.uid).get();
      setState(() {
        userData = userDoc.data() as Map<String, dynamic>?;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final minRadius = screenWidth * 0.02; // 10% of screen width
    final maxRadius = screenHeight * 0.036; // 10% of screen height
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onInverseSurface,
        title: Text(
          'Profile',
          style: GoogleFonts.firaSans(
            fontSize: screenHeight * 0.03,
            fontWeight: FontWeight.w400,
            // color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            firstContainer(
                screenWidth, screenHeight, context, minRadius, maxRadius),
            secondContainer(screenWidth, screenHeight, context),
          ],
        ),
      ),
    );
  }

  Padding secondContainer(
      double screenWidth, double screenHeight, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: screenWidth * 0.02,
          horizontal: screenWidth * 0.02,
        ),
        height: screenHeight * 0.4,
        width: screenWidth,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          // color: Colors.black54,
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'General',
                style: GoogleFonts.firaSans(
                  fontSize: screenHeight * 0.021,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[500],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    option_1(screenHeight, screenWidth, context),
                    SizedBox(height: screenHeight * 0.02),
                    option_2(screenHeight, screenWidth, context),
                    SizedBox(height: screenHeight * 0.02),
                    option_3(screenHeight, screenWidth, context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox option_1(
      double screenHeight, double screenWidth, BuildContext context) {
    return SizedBox(
      height: screenHeight * 0.05,
      width: screenWidth,
      child: Row(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //logo
                Container(
                  height: screenHeight * 0.035,
                  width: screenHeight * 0.035,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Edit Profile",
                      style: GoogleFonts.firaSans(
                        fontSize: screenHeight * 0.020,
                        fontWeight: FontWeight.w400,
                        // color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      "Edit your profile information",
                      style: GoogleFonts.firaSans(
                        fontSize: screenHeight * 0.011,
                        fontWeight: FontWeight.w300,
                        // color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_forward_ios_rounded),
          ),
        ],
      ),
    );
  }

  SizedBox option_2(
      double screenHeight, double screenWidth, BuildContext context) {
    return SizedBox(
      height: screenHeight * 0.05,
      width: screenWidth,
      child: Row(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //logo
                Container(
                  height: screenHeight * 0.035,
                  width: screenHeight * 0.035,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_open_rounded,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Change Password",
                      style: GoogleFonts.firaSans(
                        fontSize: screenHeight * 0.020,
                        fontWeight: FontWeight.w400,
                        // color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      "Update your password",
                      style: GoogleFonts.firaSans(
                        fontSize: screenHeight * 0.011,
                        fontWeight: FontWeight.w300,
                        // color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_forward_ios_rounded),
          ),
        ],
      ),
    );
  }

  SizedBox option_3(
      double screenHeight, double screenWidth, BuildContext context) {
    return SizedBox(
      height: screenHeight * 0.05,
      width: screenWidth,
      child: Row(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //logo
                Container(
                  height: screenHeight * 0.035,
                  width: screenHeight * 0.035,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notifications,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Notifications",
                      style: GoogleFonts.firaSans(
                        fontSize: screenHeight * 0.020,
                        fontWeight: FontWeight.w400,
                        // color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      "Change notification prefernce",
                      style: GoogleFonts.firaSans(
                        fontSize: screenHeight * 0.011,
                        fontWeight: FontWeight.w300,
                        // color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_forward_ios_rounded),
          ),
        ],
      ),
    );
  }

  Padding firstContainer(double screenWidth, double screenHeight,
      BuildContext context, double minRadius, double maxRadius) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: screenWidth * 0.02,
          horizontal: screenWidth * 0.02,
        ),
        height: screenHeight * 0.1,
        width: screenWidth,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          // color: Colors.black54,
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                minRadius: minRadius,
                maxRadius: maxRadius,
                backgroundImage: userData?['profilePic'] != null
                    ? NetworkImage(userData!['profilePic'])
                    : null,
                child: userData?['profilePic'] == null
                    ? const Icon(Icons.person)
                    : null,
              ),
              SizedBox(width: screenWidth * 0.03),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userData?['username'] ?? "Name not availabe",
                    style: GoogleFonts.firaSans(
                      fontSize: screenHeight * 0.022,
                      fontWeight: FontWeight.w500,
                      // color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    userData?['email'] ?? "Email not availabe",
                    style: GoogleFonts.firaSans(
                      fontSize: screenHeight * 0.011,
                      fontWeight: FontWeight.w300,
                      // color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
