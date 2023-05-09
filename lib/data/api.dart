import 'package:blurt/services/friend_service.dart';

import '../models/enums.dart';
import '../models/blurt.dart';
import '../models/friend.dart';

class API {
  /// Get all the friends
  Future<Iterable<Friend>> getFriendsMatchingContact(String username) async {
    FriendService friendService = FriendService();
    return friendService.getFriends(username);
  }

  /// Get all the available friends
  Future<Iterable<Blurt>> getBlurts(String username) async {
    FriendService friendService = FriendService();
    Iterable<Friend> friends = await friendService.getFriends(username);

    String audioFile =
        "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3";

    List<Blurt> blurts = [];
    print(friends.length);
    friends.forEach((friend) {
      Blurt blurt = new Blurt(friend, audioFile,
          "Remember that time that I did that crazy thing?", 12.2);
      blurts.add(blurt);
    });

    return blurts;
  }
}
