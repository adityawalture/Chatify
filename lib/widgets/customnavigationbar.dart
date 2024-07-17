import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  const CustomBottomNavigationBar(
      {super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
      child: GNav(
        selectedIndex: selectedIndex,
        onTabChange: onItemTapped,
        backgroundColor: Theme.of(context).colorScheme.onTertiary,
        color: Colors.black,
        activeColor: Colors.black,
        tabBackgroundColor: Theme.of(context).colorScheme.inversePrimary,
        gap: 8,
        padding: const EdgeInsets.all(16),
        tabs: const [
          GButton(
            icon: Icons.chat_rounded,
            text: 'Chats',
            style: GnavStyle.google,
          ),
          GButton(
            icon: Icons.payments_rounded,
            text: 'Payments',
            style: GnavStyle.google,
          ),
          GButton(
            icon: Icons.settings,
            text: 'Settings',
            style: GnavStyle.google,
          ),
        ],
      ),
    );
  }
}
