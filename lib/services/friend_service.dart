import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/enums.dart';
import '../models/friend.dart';

/// A service to handle friend managment actions
class FriendService {
  /// Send a friend request from a username to a username
  Future<User?> sendFriendRequest(String username, String toUsername) async {
    // Get an instance of the database
    FirebaseFirestore instance = FirebaseFirestore.instance;

    // Get the user collection
    CollectionReference<Map<String, dynamic>> _userRef =
        instance.collection("users");

    // Get the friends of the recieving user
    String? bUID;
    Map<String, dynamic>? bExistingFriends = null;
    await _userRef.where('username', isEqualTo: toUsername).get().then((query) {
      if (query.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = query.docs.first;
        var data = docSnapshot.data();
        bUID = docSnapshot.id;
        bExistingFriends = (data as Map)['friends'];
      }
    });

    // Get the friends of the sending user
    String? aUID;
    Map<String, dynamic>? aExistingFriends = null;
    await _userRef.where('username', isEqualTo: username).get().then((query) {
      if (query.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = query.docs.first;
        var data = docSnapshot.data();
        aUID = docSnapshot.id;
        aExistingFriends = (data as Map)['friends'];
      }
    });

    // Ensure both sending and recieving user
    if (bUID == null || aUID == null) {
      print(
          "sendFriendRequest(): Either the username or toUsername docuemnts did not exists");
      return null;
    } else {
      //Send a friend request

      Map<String, List<dynamic>> aFriends = {};
      Map<String, List<dynamic>> bFriends = {};

      // If there are no existing friends or requested friends
      if (aExistingFriends == null ||
          !aExistingFriends!.containsKey("requested")) {
        aFriends = {
          "requested": [bUID!],
        };
      } else {
        aFriends = {
          "requested": aExistingFriends!["requested"] + [bUID!]
        };
      }

      // If there are no existing friends or requests freinds
      if (bExistingFriends == null ||
          !bExistingFriends!.containsKey("requests")) {
        print(
            "sendFriendRequest(): existing requests ${bExistingFriends!["requests"]}");
        bFriends = {
          "requests": [aUID!],
        };
      } else {
        bFriends = {
          "requests": bExistingFriends!["requests"] + [aUID!]
        };
      }

      // Set the sending and recieiving user's friends
      await _userRef
          .doc(aUID)
          .set({'friends': aFriends}, SetOptions(merge: true));
      await _userRef
          .doc(bUID)
          .set({'friends': bFriends}, SetOptions(merge: true));
    }
    return null;
  }

  /// Get available friends for a username
  Future<Iterable<Friend>> getFriends(String username) async {
    // Get an instance of the database
    FirebaseFirestore instance = FirebaseFirestore.instance;

    Map<String, dynamic>? userFriends = {};

    // Get the user object
    await instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get()
        .then((query) {
      if (query.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = query.docs.first;
        var data = docSnapshot.data();
        // Get the user's friends
        userFriends = (data as Map)['friends'];
      }
    });

    // Get all users
    CollectionReference<Map<String, dynamic>> _userRef =
        instance.collection("users");

    List<Friend> friends = [];

    // If the user has all the necessary fields, add them to the list
    await _userRef.get().then((value) {
      value.docs.forEach((element) {
        final data = element.data();
        if (element.exists) {
          if (data.containsKey('firstName') &&
              data.containsKey('lastName') &&
              data.containsKey('username')) {
            if (userFriends != null &&
                userFriends!.containsKey('requested') &&
                userFriends!['requested']!.contains(data['uid'])) {
              // Add the friend with the appropriate status [REQUESTED]
              friends.add(Friend("http", data['firstName'], data['lastName'],
                  data['username'], FriendStatus.requested));
            } else if (userFriends != null &&
                userFriends!.containsKey('requests') &&
                userFriends!['requests']!.contains(data['uid'])) {
              // Add the friend with the appropriate status [REQUESTS]
              friends.add(Friend("http", data['firstName'], data['lastName'],
                  data['username'], FriendStatus.pending));
            } else {
              // Add the friend with the appropriate status [INACTIVE]
              friends.add(Friend("http", data['firstName'], data['lastName'],
                  data['username'], FriendStatus.inactive));
            }
          }
        }
      });
    });
    return friends;
  }
}
