// import 'package:chatify/widgets/chat_messages.dart';
// import 'package:chatify/widgets/new_messages.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   //pushnotification setup
//   void setupPushNotifications() async {
//     final fcm = FirebaseMessaging.instance;
//     await fcm.requestPermission();
//     //final token = await fcm.getToken();
//     fcm.subscribeToTopic('chats');
//   }

//   @override
//   void initState() {
//     super.initState();
//     setupPushNotifications();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("ChatiFy"),
//         actions: [
//           IconButton(
//             onPressed: () {
//               FirebaseAuth.instance.signOut();
//             },
//             icon: Icon(
//               Icons.logout_rounded,
//               color: Theme.of(context).colorScheme.primary,
//             ),
//           ),
//         ],
//       ),
//       body: const Column(
//         children: [
//           Expanded(
//             child: ChatMessages(),
//           ),
//           NewMessages(),
//         ],
//       ),
//     );
//   }
// }
