// // ignore_for_file: unused_local_variable, use_build_context_synchronously, duplicate_ignore

// import 'dart:io';

// // import 'package:chatify/Pages/loadingScreen.dart';
// import 'package:chatify/widgets/user_image_picker.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:lottie/lottie.dart';

// final _firebase = FirebaseAuth.instance;

// class AuthScreen extends StatefulWidget {
//   const AuthScreen({super.key});

//   @override
//   State<AuthScreen> createState() => _AuthScreenState();
// }

// class _AuthScreenState extends State<AuthScreen> {
//   //boolean for hide/unhide password
//   bool passwordVisible = false;

//   @override
//   void initState() {
//     super.initState();
//     passwordVisible = true;
//   }

//   var _isLogin = true;
//   var _enteredEmail = "";
//   var _enteredPassword = "";
//   File? _selectedImage;
//   var _isAuthenticating = false;
//   var _enteredUsername = "";

//   final _form = GlobalKey<FormState>();

//   void _submit() async {
//     final isValid = _form.currentState!.validate();
//     if (!isValid || !_isLogin && _selectedImage == null) {
//       return;
//     }

//     _form.currentState!.save();

//     try {
//       setState(() {
//         _isAuthenticating = true;
//       });
//       if (_isLogin) {
//         //login users
//         final loginCredentials = await _firebase.signInWithEmailAndPassword(
//           email: _enteredEmail,
//           password: _enteredPassword,
//         );
//       } else {
//         final userCredentials = await _firebase.createUserWithEmailAndPassword(
//           email: _enteredEmail,
//           password: _enteredPassword,
//         );
//         //it will store the profielImage on firebase
//         final storageImg = FirebaseStorage.instance
//             .ref()
//             .child('user_profileImages')
//             .child('${userCredentials.user!.uid}.jpeg');

//         await storageImg.putFile(_selectedImage!);
//         final imgUrl = await storageImg.getDownloadURL();

//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(userCredentials.user!.uid)
//             .set({
//           'username': _enteredUsername,
//           'email': _enteredEmail,
//           'image_ur': imgUrl,
//         });
//       }
//     } on FirebaseAuthException catch (error) {
//       if (error.code == 'user-already-in-use') {
//         //..
//       }
//       // ignore: use_build_context_synchronously
//       ScaffoldMessenger.of(context).clearSnackBars();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(error.message ?? "Authentication failed."),
//         ),
//       );
//       setState(() {
//         _isAuthenticating = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//       body: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(
//                     top: 30, bottom: 20, left: 20, right: 20),
//                 width: 250,
//                 child: Lottie.asset("assets/animation/animation_1.json"),
//               ),
//               Card(
//                 margin: const EdgeInsets.all(20),
//                 child: SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Form(
//                       key: _form,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           //textfield for entering email address
//                           if (!_isLogin)
//                             UserImagePicker(
//                               onPickImage: (pickedImage) {
//                                 _selectedImage = pickedImage;
//                               },
//                             ),
//                           if (!_isLogin)
//                             TextFormField(
//                               decoration:
//                                   const InputDecoration(labelText: "User Name"),
//                               enableSuggestions: false,
//                               validator: (value) {
//                                 if (value == null ||
//                                     value.isEmpty ||
//                                     value.trim().length < 4) {
//                                   return "Enter atleat four characters";
//                                 }
//                                 return null;
//                               },
//                               onSaved: (value) {
//                                 _enteredUsername = value!;
//                               },
//                             ),
//                           TextFormField(
//                             decoration: const InputDecoration(
//                               labelText: "Email",
//                             ),
//                             keyboardType: TextInputType.emailAddress,
//                             autocorrect: false,
//                             textCapitalization: TextCapitalization.none,
//                             validator: (value) {
//                               if (value == null ||
//                                   value.trim().isEmpty ||
//                                   !value.contains("@")) {
//                                 return "Enter valid email";
//                               }
//                               return null;
//                             },
//                             onSaved: (value) {
//                               _enteredEmail = value!;
//                             },
//                           ),
//                           //textfield for entering password
//                           TextFormField(
//                             decoration: InputDecoration(
//                               labelText: "Password",
//                               suffixIcon: IconButton(
//                                 icon: Icon(passwordVisible
//                                     ? Icons.visibility
//                                     : Icons.visibility_off),
//                                 onPressed: () {
//                                   setState(() {
//                                     passwordVisible = !passwordVisible;
//                                   });
//                                 },
//                               ),
//                             ),
//                             obscureText: passwordVisible,
//                             validator: (value) {
//                               if (value == null || value.trim().length < 6) {
//                                 return "Enter valid passwords";
//                               }
//                               return null;
//                             },
//                             onSaved: (value) {
//                               _enteredPassword = value!;
//                             },
//                           ),
//                           const SizedBox(height: 16),
//                           if (_isAuthenticating)
//                             const CircularProgressIndicator(),
//                           if (!_isAuthenticating)
//                             ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Theme.of(context)
//                                     .colorScheme
//                                     .primaryContainer,
//                               ),
//                               onPressed: _submit,
//                               child: Text(_isLogin ? "Login" : "Sign Up"),
//                             ),
//                           if (!_isAuthenticating)
//                             TextButton(
//                               onPressed: () {
//                                 setState(() {
//                                   _isLogin = !_isLogin;
//                                 });
//                               },
//                               child: Text(_isLogin
//                                   ? "Create a Account"
//                                   : "I already have an Account"),
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
