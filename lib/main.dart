// import 'package:chatify/Pages/authPage.dart';
import 'package:chatify/Pages/authentication_pg.dart';
// import 'package:chatify/Pages/chatScreen.dart';
// import 'package:chatify/Pages/loadingScreen.dart';
import 'package:chatify/bloc/internetbloc/internet_bloc.dart';
// import 'package:firebase_app_check/firebase_app_check.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseAppCheck.instance.activate(
  //   webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
  //   androidProvider: AndroidProvider.playIntegrity,
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InternetBloc(),
      child: MaterialApp(
        title: 'ChatiFy',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 63, 17, 177),
          ),
          useMaterial3: true,
        ),
        home: const AuthenticationPg(),
        // home: const AuthScreen(),
      ),
    );
  }
}
