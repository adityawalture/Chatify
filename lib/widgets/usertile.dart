import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserTile extends StatelessWidget {
  final String name;
  final String imageUrl;
  final void Function()? onTap;

  const UserTile({
    super.key,
    required this.name,
    this.onTap,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          height: MediaQuery.of(context).size.height * 0.08,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.inversePrimary,
              // width: 0.3,
              style: BorderStyle.solid,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
            // color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              CircleAvatar(
                foregroundImage: NetworkImage(imageUrl),
                radius: MediaQuery.of(context).size.width * 0.07,
                child: const Icon(Icons.person),
              ),
              SizedBox(width: screenWidth * 0.02),
              Text(
                name,
                style: GoogleFonts.firaSans(
                  fontSize: screenHeight * 0.017,
                  fontWeight: FontWeight.w400,
                  // color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
