import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/Pages/loadingScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Userslist extends StatelessWidget {
  const Userslist({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: LoadingScreen(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No users found'),
          );
        }

        final users = snapshot.data!.docs;

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            var user = users[index].data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.all(7.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.08,
                decoration: const BoxDecoration(
                  // color: Theme.of(context).colorScheme.onInverseSurface,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: Center(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.07,
                      foregroundImage:
                          CachedNetworkImageProvider(user['profilePic'] ?? ''),
                      child: const Icon(Icons.person),
                    ),
                    title: Text(user['username'] ?? 'No Name'),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
