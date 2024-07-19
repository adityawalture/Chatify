import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                'A c c o u n t',
                style: GoogleFonts.firaSans(
                  fontSize: screenHeight * 0.02,
                  fontWeight: FontWeight.w400,
                  // color: Theme.of(context).colorScheme.primary,
                ),
              ),
              trailing: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.person_2_rounded,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    'L o g o u t',
                    style: GoogleFonts.firaSans(
                      fontSize: screenHeight * 0.02,
                      fontWeight: FontWeight.w400,
                      // color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    icon: Icon(
                      Icons.logout_rounded,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
