import 'package:chatify/Pages/chatScreen.dart';
import 'package:chatify/Pages/homepage.dart';
import 'package:chatify/Pages/signuppg.dart';
import 'package:chatify/widgets/customsnackbar.dart';
import 'package:chatify/widgets/customtextfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool passwordVisible = false;
  bool isLoginButtonEnabled = false;
  @override
  void initState() {
    super.initState();
    passwordVisible = true;

    _emailController.addListener(toggleButtonState);
    _passwordController.addListener(toggleButtonState);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void toggleButtonState() {
    setState(() {
      isLoginButtonEnabled = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  Future<void> userLogin() async {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.length >= 7 &&
        _passwordController.text.isNotEmpty) {
      try {
        //loading circle
        showLoadingDialog();

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (mounted) {
          // Navigator.of(context).pop();

          Navigator.pop(
            context,
            MaterialPageRoute(
              builder: (context) => const Homepage(),
            ),
          );
          _hideLoadingDialog;
        }
      } on FirebaseAuthException catch (e) {
        handleLoginError(e);
        _hideLoadingDialog();
      }
    }
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

  void handleLoginError(FirebaseAuthException e) {
    // Remove loading dialog
    if (e.code == 'user-not-found') {
      ScaffoldMessenger.of(context).showSnackBar(
          const CustomSnackBar(message: "User not found").snackbar);
    } else if (e.code == 'wrong-password') {
      ScaffoldMessenger.of(context).showSnackBar(
          const CustomSnackBar(message: "Wrong password").snackbar);
    }
    _hideLoadingDialog;
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
                        fontSize: screenHeight * 0.045,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Lottie.asset("assets/animation/animation_1.json",
                        width: screenWidth * 0.55),
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
                          "Login",
                          style: GoogleFonts.firaSans(
                            fontSize: screenWidth * 0.07,
                            fontWeight: FontWeight.w600,
                          ),
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
                        Padding(
                          padding:
                              EdgeInsets.only(right: screenWidth * 0.03), //39.0
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Forgot Password",
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035, //16.0
                                    color:
                                        const Color.fromARGB(217, 53, 161, 248),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: userLogin,
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
                                "Login",
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
                  "Dont't have an account ?",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.035, //16.0
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SignUp(),
                    ));
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize:
                          MediaQuery.of(context).size.width * 0.035, //16.0
                      // color: const Color.fromARGB(217, 53, 161, 248),
                      fontWeight: FontWeight.bold,
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
