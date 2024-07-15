import 'package:chatify/Pages/authPage.dart';
import 'package:chatify/Pages/chatScreen.dart';
import 'package:chatify/Pages/loadingScreen.dart';
import 'package:chatify/Pages/loginpg.dart';
import 'package:chatify/bloc/internetbloc/internet_bloc.dart';
import 'package:chatify/bloc/internetbloc/internetstate.dart';
import 'package:chatify/widgets/customsnackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationPg extends StatelessWidget {
  const AuthenticationPg({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<InternetBloc, InternetState>(
      listener: (context, state) {
        if (state is InternetConnectedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const CustomSnackBar(message: "Internet Connected").snackbar,
          );
        } else if (state is InternetLossState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const CustomSnackBar(message: "Internet Disconnected").snackbar,
          );
        }
      },
      child: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }
          if (snapshot.hasData) {
            return const ChatScreen();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
