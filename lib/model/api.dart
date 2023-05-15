import 'package:blurt/controllers/friend_service.dart';

import 'items/enums.dart';
import 'items/blurt.dart';
import 'items/friend.dart';

class API {
  /// Get all the friends
  Future<Iterable<Friend>> getAcceptedFriends(String username) async {
    FriendService friendService = FriendService();
    Iterable<Friend> getAllFriends =
        await friendService.getAvailableFriends(username);
    return friendService.getAcceptedFriends(getAllFriends);
  }

  Future<Iterable<Friend>> getRequestedFriends(String username) async {
    FriendService friendService = FriendService();
    Iterable<Friend> getAllFriends =
        await friendService.getAvailableFriends(username);
    return friendService.getRequestedFriends(getAllFriends);
  }

  Future<Iterable<Friend>> getPossibleFriends(String username) async {
    FriendService friendService = FriendService();
    Iterable<Friend> getAllFriends =
        await friendService.getAvailableFriends(username);

    Iterable<Friend> friends =
        await friendService.getPossibleFriends(getAllFriends);
    return friends;
  }

  /// Get all the available friends
  Future<Iterable<Blurt>> getBlurts(String username) async {
    FriendService friendService = FriendService();
    Iterable<Friend> getAllFriends =
        await friendService.getAvailableFriends(username);
    Iterable<Friend> friends =
        await friendService.getAcceptedFriends(getAllFriends);

    String audioFile =
        "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3";

    List<Blurt> blurts = [];

    friends.forEach((friend) {
      Blurt blurt = new Blurt(friend, audioFile,
          "Remember that time that I did that crazy thing?", 12.2);
      blurts.add(blurt);
    });

    return blurts;
  }
}
