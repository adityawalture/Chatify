import 'dart:io';

import 'package:chatify/Pages/homepage.dart';
import 'package:chatify/Pages/loginpg.dart';
import 'package:chatify/widgets/customsnackbar.dart';
import 'package:chatify/widgets/customtextfield.dart';
import 'package:chatify/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  File? _selectedImage;
  bool passwordVisible = false;
  bool isLoginButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;

    _emailController.addListener(toggleButtonState);
    _passwordController.addListener(toggleButtonState);
  }

  void toggleButtonState() {
    setState(() {
      isLoginButtonEnabled = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  void showLoadingDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _hideLoadingDialog() {
    Navigator.of(context).pop();
  }

  //signup
  Future<void> signup() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid || _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const CustomSnackBar(message: "Give the correct information").snackbar,
      );
      return;
    }
    try {
      showLoadingDialog();
      final userCredentials =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      final storeProfilePic = FirebaseStorage.instance
          .ref()
          .child('user_profilepic')
          .child('${userCredentials.user!.uid}.jpeg');

      await storeProfilePic.putFile(_selectedImage!);
      final imgurl = await storeProfilePic.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredentials.user!.uid)
          .set({
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'profilePic': imgurl,
      });
      if (mounted) {
        // Navigator.of(context).pop();
        _hideLoadingDialog();
        ScaffoldMessenger.of(context).showSnackBar(
          const CustomSnackBar(message: "Registered successfully").snackbar,
        );
        Navigator.pop(
          context,
          MaterialPageRoute(
            builder: (context) => const Homepage(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        _hideLoadingDialog();
        String message = 'Something went wrong';
        if (e.code == 'weak-password') {
          message = 'Weak password';
        } else if (e.code == 'email-already-in-use') {
          message = 'Account already exist';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(message: message).snackbar,
        );
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: screenHeight * 0.5,
              width: screenWidth * 0.5,
              child: Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      // "Chatify",
                      "च्याटify",
                      style: GoogleFonts.firaSans(
                        fontSize: screenHeight * 0.04,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Lottie.asset(
                      "assets/animation/animation_1.json",
                      width: screenWidth * 0.4,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            // bottom: screenHeight * 0.32,
            bottom: screenHeight * 0.099,
            left: screenWidth * 0.06,
            right: screenWidth * 0.06,
            child: SizedBox(
              width: screenWidth * 0.9,
              child: Card(
                elevation: 0.2,
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Sign Up",
                          style: GoogleFonts.firaSans(
                            fontSize: screenWidth * 0.07,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        UserImagePicker(onPickImage: (pickedImage) {
                          _selectedImage = pickedImage;
                        }),
                        SizedBox(height: screenHeight * 0.01),
                        CustomTextField(
                          hintText: "Enter Username",
                          controller: _usernameController,
                        ),
                        SizedBox(height: screenHeight / 50),
                        CustomTextField(
                          hintText: "E-mail",
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: screenHeight / 50),
                        CustomTextField(
                          hintText: "Password",
                          controller: _passwordController,
                          isObsecureText: passwordVisible,
                          suffixIcon: IconButton(
                            icon: Icon(
                              passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: screenHeight / 50),
                        GestureDetector(
                          onTap: signup,
                          child: Container(
                            height: screenHeight * 0.045,
                            width: screenWidth * 0.30,
                            decoration: BoxDecoration(
                              color: isLoginButtonEnabled
                                  ? Theme.of(context).colorScheme.inversePrimary
                                  : Colors.grey,
                              borderRadius: const BorderRadius.all(
                                Radius.elliptical(14.0, 14.0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "SignIn",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.04, //17
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight / 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(
                              width: 55,
                              child: Divider(
                                thickness: 1.0,
                                color: Color.fromARGB(144, 55, 55, 55),
                              ),
                            ),
                            Text(
                              " Or ",
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.035, //20.0
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              width: 55,
                              child: Divider(
                                thickness: 1.0,
                                color: Color.fromARGB(144, 55, 55, 55),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        GestureDetector(
                          onTap: () {
                            // AuthMethods().signInWithGoogle(context);
                            // _signIn();
                          },
                          child: Image.asset(
                            "assets/logos/google.png",
                            height: MediaQuery.of(context).size.height * 0.044,
                            width: MediaQuery.of(context).size.height * 0.044,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account ?",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.035, //16.0
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ));
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                        fontSize:
                            MediaQuery.of(context).size.width * 0.035, //16.0
                        fontWeight: FontWeight.bold
                        //color: const Color.fromARGB(217, 53, 161, 248),
                        ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
