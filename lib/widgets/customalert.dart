import 'package:chatify/Pages/loginpg.dart';
import 'package:chatify/widgets/customsnackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomAlertBox extends StatefulWidget {
  const CustomAlertBox({super.key});

  @override
  State<CustomAlertBox> createState() => _CustomAlertBoxState();
}

class _CustomAlertBoxState extends State<CustomAlertBox> {
  bool _isSigningOut = false;
  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> _signOut() async {
    Navigator.of(context).pop();
    // final GoogleSignIn googleSignIn = GoogleSignIn();

    setState(() {
      _isSigningOut = true;
    });
    try {
      await FirebaseAuth.instance.signOut();
      // if (await googleSignIn.isSignedIn()) {
      //   await googleSignIn.signOut();
      // }

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const CustomSnackBar(message: 'Error signing out. Please try again')
              .snackbar,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSigningOut = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 2.0,
      title: const Text("Are you sure ?"),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
            MaterialButton(
              onPressed: _isSigningOut ? null : _signOut,
              child: const Text("Yes"),
            ),
          ],
        ),
      ],
    );
  }
}
