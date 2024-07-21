// import 'package:chatify/Pages/chatScreen.dart';
// import 'package:chatify/Pages/chatpage.dart';
import 'package:chatify/Pages/home.dart';
// import 'package:chatify/Pages/loadingScreen.dart';
import 'package:chatify/Pages/paymentpage.dart';
import 'package:chatify/Pages/settingspage.dart';
// import 'package:chatify/services/chat_service.dart';
import 'package:chatify/widgets/customnavigationbar.dart';
// import 'package:chatify/widgets/userslist.dart';
// import 'package:chatify/widgets/usertile.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectIndex = 0;

  late List<Widget> _listScreens;

  @override
  void initState() {
    super.initState();
    _listScreens = [
      const BuildUserList(),
      const Paymentpage(),
      const SettingsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onTertiary,
      body: _listScreens[_selectIndex],
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
}
