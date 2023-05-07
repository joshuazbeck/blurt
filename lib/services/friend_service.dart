import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/enums.dart';
import '../models/friend.dart';

class FriendService {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<User?> sendFriendRequest(String username, String toUsername) async {
    FirebaseFirestore _instance = FirebaseFirestore.instance;

    CollectionReference<Map<String, dynamic>> _userRef =
        _instance.collection("users");

    String? bUID = null;
    Map<String, dynamic>? bExistingFriends = null;
    //Add a reference on the new username that a friend request has been sent
    await _userRef.where('username', isEqualTo: toUsername).get().then((query) {
      if (query.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = query.docs.first;
        var data = docSnapshot.data();
        bUID = docSnapshot.id;
        bExistingFriends = (data as Map)['friends'];
      }
    });

    String? aUID = null;
    Map<String, dynamic>? aExistingFriends = null;
    await _userRef.where('username', isEqualTo: username).get().then((query) {
      if (query.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = query.docs.first;
        var data = docSnapshot.data();
        aUID = docSnapshot.id;
        aExistingFriends = (data as Map)['friends'];
      }
    });

    if (bUID == null || aUID == null) {
      print(
          "sendFriendRequest(): Either the username or toUsername docuemnts did not exists");
      return null;
    } else {
      //Send a friend request

      print(
          "sendFriendRequest(): sending the friend requests from ${aUID} to ${bUID}");

      Map<String, List<dynamic>> aFriends = {};
      Map<String, List<dynamic>> bFriends = {};

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

      await _userRef
          .doc(aUID)
          .set({'friends': aFriends}, SetOptions(merge: true));

      await _userRef
          .doc(bUID)
          .set({'friends': bFriends}, SetOptions(merge: true));
      ;
    }
    //Add a reference on the current username that a friend request was recieved
  }

  Future<Iterable<Friend>> getFriends(String username) async {
    FirebaseFirestore _instance = FirebaseFirestore.instance;

    Map<String, dynamic>? userFriends = {};

    //Current user friends
    await _instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get()
        .then((query) {
      if (query.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = query.docs.first;
        var data = docSnapshot.data();
        userFriends = (data as Map)['friends'];
      }
    });
    CollectionReference<Map<String, dynamic>> _userRef =
        _instance.collection("users");

    List<Friend> friends = [];

    await _userRef.get().then((value) {
      value.docs.forEach((element) {
        final data = element.data() as Map<String, dynamic>;
        if (element.exists) {
          if (data.containsKey('firstName') &&
              data.containsKey('lastName') &&
              data.containsKey('username')) {
            if (userFriends != null &&
                userFriends!.containsKey('requested') &&
                userFriends!['requested']!.contains(data['uid'])) {
              friends.add(Friend("http", data['firstName'], data['lastName'],
                  data['username'], FriendStatus.requested));
            } else if (userFriends != null &&
                userFriends!.containsKey('requests') &&
                userFriends!['requests']!.contains(data['uid'])) {
              friends.add(Friend("http", data['firstName'], data['lastName'],
                  data['username'], FriendStatus.pending));
            } else {
              friends.add(Friend("http", data['firstName'], data['lastName'],
                  data['username'], FriendStatus.inactive));
            }
          }
        }
      });
    });
    // DocumentSnapshot doc = await _userRef.get();
    return friends;
  }
}
