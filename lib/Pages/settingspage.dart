import 'package:chatify/Pages/accounts.dart';
import 'package:chatify/Pages/blockeduserspage.dart';
import 'package:chatify/widgets/customalert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // void _showDialog() {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (context) => const CustomAlertBox(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onInverseSurface,
        title: Text(
          'Settings',
          style: GoogleFonts.firaSans(
            fontSize: screenHeight * 0.03,
            fontWeight: FontWeight.w400,
            // color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              tileColor: Theme.of(context).colorScheme.primaryContainer,
              title: Text(
                'A c c o u n t',
                style: GoogleFonts.firaSans(
                  fontSize: screenHeight * 0.02,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.person_2_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              tileColor: Theme.of(context).colorScheme.primaryContainer,
              title: Text(
                'B l o c k e d U s e r s',
                style: GoogleFonts.firaSans(
                  fontSize: screenHeight * 0.02,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              trailing: IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlockedUsersPage(),
                  ),
                ),
                icon: Icon(
                  Icons.arrow_forward_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              tileColor: Theme.of(context).colorScheme.primaryContainer,
              title: Text(
                'L o g o u t',
                style: GoogleFonts.firaSans(
                  fontSize: screenHeight * 0.02,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  // _showDialog;
                },
                icon: Icon(
                  Icons.logout_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
