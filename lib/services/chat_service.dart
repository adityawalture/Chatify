import 'package:chatify/widgets/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //get all user stream
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .where((doc) => doc.data()['email'] != _auth.currentUser!.email)
          .map((doc) => doc.data())
          .toList();
    });
  }

  //get all users stream except blocked users
  Stream<List<Map<String, dynamic>>> getUsersStreamExceptBlocked() {
    final currentUser = _auth.currentUser;
    return _firestore
        .collection('usres')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap(
      (snapshot) async {
        final blockedUsersId = snapshot.docs.map((doc) => doc.id).toList();

        //get all usres, excluding current and blocked users
        final usersSnapshot = await _firestore.collection('users').get();

        return usersSnapshot.docs
            .where((doc) =>
                doc.data()['email'] != currentUser.email &&
                !blockedUsersId.contains(doc.id))
            .map((doc) => doc.data())
            .toList();
      },
    );
  }

  Future<void> sendMessage(String receiverId, message) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;

    final Timestamp timeStamp = Timestamp.now();

    //create a new message
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timeStamp,
    );

    //chat room uniqueId for any two users
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');

    //add new message to database
    await _firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  //get messages
  Stream<QuerySnapshot> getMessages(String userId, otherUsersId) {
    List<String> ids = [userId, otherUsersId];
    ids.sort();

    String chatRoomId = ids.join('_');

    return _firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  //report users
  Future<void> reportUser(String messageId, String userId) async {
    final currentUser = _auth.currentUser;
    final report = {
      'reportedBy': currentUser!.uid,
      'messageId': messageId,
      'messageOwnerId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    };
    await _firestore.collection('Reports').add(report);
  }

  //block users
  Future<void> blockUser(String userId) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(userId)
        .set({});
    notifyListeners();
  }

  //unblock users
  Future<void> unblockUser(String blockedUserId) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(blockedUserId)
        .delete();
  }

  //get blocked users
  Stream<List<Map<String, dynamic>>> getBlockedUsers(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
      final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();

      final userDocs = await Future.wait(
        blockedUserIds
            .map((id) => _firestore.collection('users').doc(id).get()),
      );

      return userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }
}
