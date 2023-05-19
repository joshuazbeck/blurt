import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../model/items/enums.dart';
import '../model/items/friend.dart';

/// A service to handle friend managment actions
class FriendService {
  //TODO: Add any existing blurt
  Future<User?> acceptFriendRequest(String username, String toUsername) async {
    // Get an instance of the database
    FirebaseFirestore instance = FirebaseFirestore.instance;

    // Get the user collection
    CollectionReference<Map<String, dynamic>> userRef =
        instance.collection("users");

    // Get the friends of the recieving user
    String? bUID;
    Map<String, dynamic>? bExistingFriends;
    await userRef.where('username', isEqualTo: toUsername).get().then((query) {
      if (query.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = query.docs.first;
        var data = docSnapshot.data();
        bUID = docSnapshot.id;
        bExistingFriends = (data as Map)['friends'];
      }
    });

    // Get the friends of the sending user
    String? aUID;
    Map<String, dynamic>? aExistingFriends;
    await userRef.where('username', isEqualTo: username).get().then((query) {
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
          !aExistingFriends!.containsKey("accepted")) {
        aFriends = {
          "accepted": [bUID!],
        };
      } else {
        aFriends = {
          "accepted": aExistingFriends!["accepted"] + [bUID!]
        };
      }

      // If there are no existing friends or requests freinds
      if (bExistingFriends == null ||
          !bExistingFriends!.containsKey("accepted")) {
        bFriends = {
          "accepted": [aUID!],
        };
      } else {
        bFriends = {
          "accepted": bExistingFriends!["accepted"] + [aUID!]
        };
      }

      // Set the sending and recieiving user's friends
      await userRef
          .doc(aUID)
          .set({'friends': aFriends}, SetOptions(merge: true));
      await userRef
          .doc(bUID)
          .set({'friends': bFriends}, SetOptions(merge: true));
    }
    return null;
  }

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

  // TODO: Remove blurt
  Future<User?> removeFriendRequest(String username, String toUsername) async {
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

      // REQUESTED
      if (aExistingFriends != null &&
          aExistingFriends!.containsKey("requested") &&
          aExistingFriends!["requested"] != null) {
        aExistingFriends!["requested"].removeWhere((item) => item == bUID);
        aFriends = {"requested": aExistingFriends!["requested"]};
      }

      // ACCEPTED
      if (aExistingFriends != null &&
          aExistingFriends!.containsKey("accepted") &&
          aExistingFriends!["accepted"] != null) {
        aExistingFriends!["accepted"].removeWhere((item) => item == bUID);
        aFriends = {"accepted": aExistingFriends!["accepted"]};
      }

      if (aExistingFriends != null &&
          aExistingFriends!.containsKey("requests") &&
          aExistingFriends!["requests"] != null) {
        aExistingFriends!["requests"].removeWhere((item) => item == bUID);
        aFriends = {"requests": aExistingFriends!["requests"]};
      }

      // REQUESTS
      if (bExistingFriends != null &&
          !bExistingFriends!.containsKey("requests") &&
          bExistingFriends!["requests"] != null) {
        bExistingFriends!["requests"].removeWhere((item) => item == aUID);
        bFriends = {"requests": bExistingFriends!["requests"]};
      }

      // REQUESTED
      if (bExistingFriends != null &&
          !bExistingFriends!.containsKey("requested") &&
          bExistingFriends!["requested"] != null) {
        bExistingFriends!["requested"].removeWhere((item) => item == aUID);
        bFriends = {"requested": bExistingFriends!["requested"]};
      }

      // ACCEPTED
      if (bExistingFriends != null &&
          !bExistingFriends!.containsKey("accepted") &&
          bExistingFriends!["accepted"] != null) {
        bExistingFriends!["accepted"].removeWhere((item) => item == aUID);
        bFriends = {"accepted": bExistingFriends!["accepted"]};
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

  Future<Iterable<Friend>> getAcceptedFriends(Iterable<Friend> friends) async {
    // Get an instance of the database
    List<Friend> activeFriends = [];
    for (Friend friend in friends) {
      if (friend.friendStatus == FriendStatus.active) {
        print(friend.friendStatus.name);
        activeFriends.add(friend);
      }
    }
    return activeFriends;
  }

  Future<Iterable<Friend>> getPossibleFriends(Iterable<Friend> friends) async {
    // Get an instance of the database
    List<Friend> possibleFriends = [];
    for (Friend friend in friends) {
      if (friend.friendStatus == FriendStatus.inactive ||
          friend.friendStatus == FriendStatus.declined ||
          friend.friendStatus == FriendStatus.requested) {
        possibleFriends.add(friend);
      }
    }
    return possibleFriends;
  }

  Future<Iterable<Friend>> getRequestedFriends(Iterable<Friend> friends) async {
    // Get an instance of the database
    List<Friend> requestedFriends = [];
    for (Friend friend in friends) {
      if (friend.friendStatus == FriendStatus.pending) {
        requestedFriends.add(friend);
      }
    }
    return requestedFriends;
  }

  /// Get available friends for a username
  Future<Iterable<Friend>> getAvailableFriends(String username) async {
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
                userFriends!.containsKey('accepted') &&
                userFriends!['accepted']!.contains(data['uid'])) {
              // Add the friend with the appropriate status [REQUESTS]
              friends.add(Friend(
                  "https://fastly.picsum.photos/id/825/200/300.jpg?hmac=02AaqBOvx8gwrGt7a3HWzJHnZXrMzYoXbAYwjJWH40E",
                  data['firstName'],
                  data['lastName'],
                  data['username'],
                  FriendStatus.active));
            } else if (userFriends != null &&
                userFriends!.containsKey('requests') &&
                userFriends!['requests']!.contains(data['uid'])) {
              // Add the friend with the appropriate status [REQUESTS]
              friends.add(Friend(
                  "https://fastly.picsum.photos/id/825/200/300.jpg?hmac=02AaqBOvx8gwrGt7a3HWzJHnZXrMzYoXbAYwjJWH40E",
                  data['firstName'],
                  data['lastName'],
                  data['username'],
                  FriendStatus.pending));
            } else if (userFriends != null &&
                userFriends!.containsKey('requested') &&
                userFriends!['requested']!.contains(data['uid'])) {
              // Add the friend with the appropriate status [REQUESTED]
              friends.add(Friend(
                  "https://fastly.picsum.photos/id/825/200/300.jpg?hmac=02AaqBOvx8gwrGt7a3HWzJHnZXrMzYoXbAYwjJWH40E",
                  data['firstName'],
                  data['lastName'],
                  data['username'],
                  FriendStatus.requested));
            } else {
              // Add the friend with the appropriate status [INACTIVE]
              friends.add(Friend(
                  "https://fastly.picsum.photos/id/825/200/300.jpg?hmac=02AaqBOvx8gwrGt7a3HWzJHnZXrMzYoXbAYwjJWH40E",
                  data['firstName'],
                  data['lastName'],
                  data['username'],
                  FriendStatus.inactive));
            }
          }
        }
      });
    });
    return friends;
  }

  Future<Friend?> getFriend(String withUsername, String baseUsername) async {
    FirebaseFirestore instance = FirebaseFirestore.instance;

    Map userFriends = {};
    // Get the user object
    await instance
        .collection('users')
        .where('username', isEqualTo: baseUsername)
        .get()
        .then((query) {
      if (query.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = query.docs.first;
        var data = docSnapshot.data();
        // Get the user's friends
        userFriends = (data as Map)['friends'];
      }
    });

    QuerySnapshot<Map<String, dynamic>> friends = await instance
        .collection('users')
        .where('username', isEqualTo: withUsername)
        .get();

    final data = friends.docs.first.data();
    if (data.isNotEmpty) {
      if (data.containsKey('firstName') &&
          data.containsKey('lastName') &&
          data.containsKey('username')) {
        if (userFriends != null &&
            userFriends!.containsKey('accepted') &&
            userFriends!['accepted']!.contains(data['uid'])) {
          // Add the friend with the appropriate status [REQUESTS]
          return Friend(
              "https://fastly.picsum.photos/id/825/200/300.jpg?hmac=02AaqBOvx8gwrGt7a3HWzJHnZXrMzYoXbAYwjJWH40E",
              data['firstName'],
              data['lastName'],
              data['username'],
              FriendStatus.active);
        } else if (userFriends != null &&
            userFriends!.containsKey('requested') &&
            userFriends!['requested']!.contains(data['uid'])) {
          // Add the friend with the appropriate status [REQUESTED]
          return Friend(
              "https://fastly.picsum.photos/id/825/200/300.jpg?hmac=02AaqBOvx8gwrGt7a3HWzJHnZXrMzYoXbAYwjJWH40E",
              data['firstName'],
              data['lastName'],
              data['username'],
              FriendStatus.requested);
        } else if (userFriends != null &&
            userFriends!.containsKey('requests') &&
            userFriends!['requests']!.contains(data['uid'])) {
          // Add the friend with the appropriate status [REQUESTS]
          return Friend(
              "https://fastly.picsum.photos/id/825/200/300.jpg?hmac=02AaqBOvx8gwrGt7a3HWzJHnZXrMzYoXbAYwjJWH40E",
              data['firstName'],
              data['lastName'],
              data['username'],
              FriendStatus.pending);
        } else {
          // Add the friend with the appropriate status [INACTIVE]
          return Friend(
              "https://fastly.picsum.photos/id/825/200/300.jpg?hmac=02AaqBOvx8gwrGt7a3HWzJHnZXrMzYoXbAYwjJWH40E",
              data['firstName'],
              data['lastName'],
              data['username'],
              FriendStatus.inactive);
        }
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> getFriendMap(String username) async {
    FirebaseFirestore instance = FirebaseFirestore.instance;

    Map<String, dynamic> userFriend = {};
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
        userFriend = (data as Map<String, dynamic>);
      }
    });

    return userFriend;
  }
}
