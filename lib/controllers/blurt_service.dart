import 'package:blurt/model/items/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../model/items/blurt.dart';
import '../model/items/friend.dart';
import 'auth_service.dart';
import 'friend_service.dart';

/// A service to handle friend managment actions
class BlurtService {
  Future<Blurt?> getPersonalBlurt(String username) async {
    // Get an instance of the database
    FirebaseFirestore instance = FirebaseFirestore.instance;

    // Get the user collection
    CollectionReference<Map<String, dynamic>> userRef =
        instance.collection("users");

    // Get the friends of the recieving user
    String? bUID;
    Map<String, dynamic>? bExistingFriends;
    Blurt? myBlurt = null;
    QuerySnapshot<Map<String, dynamic>> query =
        await userRef.where('username', isEqualTo: username).get();
    if (query.docs.isNotEmpty) {
      DocumentSnapshot docSnapshot = query.docs.first;
      var data = docSnapshot.data();
      var myBlurtD = (data as Map)['myBlurt'];

      if (myBlurtD != null) {
        myBlurt = await getBlurtFromMap(myBlurtD);
      }
    }
    print("GOT MY BLURT $myBlurt");
    return myBlurt;
  }

  Future<List<Blurt>?> getBlurts(String username) async {
    // Get an instance of the database
    FirebaseFirestore instance = FirebaseFirestore.instance;

    // Get the user collection
    CollectionReference<Map<String, dynamic>> userRef =
        instance.collection("users");

    // Get the friends of the recieving user
    String? bUID;
    Map<String, dynamic>? bExistingFriends;
    List<Blurt> blurtArray = [];
    QuerySnapshot<Map<String, dynamic>> query =
        await userRef.where('username', isEqualTo: username).get();
    if (query.docs.isNotEmpty) {
      DocumentSnapshot docSnapshot = query.docs.first;
      var data = docSnapshot.data();
      var blurts = (data as Map)['blurts'] as List?;
      if (blurts != null) {
        for (var blurt in blurts) {
          var b = await getBlurtFromMap(blurt);
          if (b != null) blurtArray.add(b);
        }
      }
    }
    return blurtArray;
  }

  Future<void> addBlurt(String username, Blurt blurt) async {
    FriendService fS = FriendService();
    AuthService authService = AuthService();
    var fU = await authService.getAuthenticatedUser();
    var friends = await fS.getAvailableFriends(fU?.username ?? "");
    Iterable<Friend> acceptedFriends = await fS.getAcceptedFriends(friends);
    //Get accepted friends
    acceptedFriends.forEach((element) async {
      await addBlurtTo(element.username, username, blurt);
    });
    await addPersonalBlurt(username, blurt);
  }

  Future<void> addPersonalBlurt(String toUsername, Blurt blurt) async {
    // Get an instance of the database
    FirebaseFirestore instance = FirebaseFirestore.instance;

    CollectionReference<Map<String, dynamic>> userRef =
        instance.collection("users");
    await userRef.where('username', isEqualTo: toUsername).get().then((query) {
      if (query.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = query.docs.first;
        String id = docSnapshot.id;
        docSnapshot.reference
            .update({'myBlurt': buildBlurtMap(blurt, toUsername)});
      }
    });
    //Add blurt from username to username
  }

  Future<Blurt?> getBlurtFromMap(map) async {
    var username = map["username"];
    var length = map["blurt_length"];
    var audio_path = map["blurt_audio_path"];
    var title = map["blurt_title"];
    const audioPath = "";
    FriendService fS = new FriendService();
    Map<String, dynamic>? friendMap = await fS.getFriendMap(username);
    if (friendMap != null) {
      Friend f = Friend("", friendMap["firstName"], friendMap["lastName"],
          username, FriendStatus.active);

      Blurt b = Blurt(f, audioPath, title, length);
      return b;
    } else {
      Blurt b = Blurt(null, audioPath, title, length);
    }
  }

  Map buildBlurtMap(blurt, username) {
    return {
      "username": username,
      "blurt_length": blurt.length,
      "blurt_audio_path": blurt.audioPath,
      "blurt_title": blurt.title,
    };
  }

  Future<void> addBlurtTo(
      String toUsername, String fromUsername, Blurt blurt) async {
    // Get an instance of the database
    FirebaseFirestore instance = FirebaseFirestore.instance;

    String blurtMapRef = "blurts";
    if (toUsername == fromUsername) blurtMapRef = "myBlurt";
    CollectionReference<Map<String, dynamic>> userRef =
        instance.collection("users");
    await userRef.where('username', isEqualTo: toUsername).get().then((query) {
      if (query.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = query.docs.first;
        String id = docSnapshot.id;
        var data = docSnapshot.data();
        var blurts = (data as Map)['blurts'] as List?;
        if (blurts == null) {
          docSnapshot.reference.set({
            'blurts': {buildBlurtMap(blurt, fromUsername)}
          }, SetOptions(merge: true));
        } else {
          docSnapshot.reference.set({
            'blurts': blurts + [buildBlurtMap(blurt, fromUsername)]
          }, SetOptions(merge: true));
        }
      }
    });
    //Add blurt from username to username
  }
}
