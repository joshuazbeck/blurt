import 'package:blurt/services/friend_service.dart';

import '../models/enums.dart';
import '../models/blurt.dart';
import '../models/friend.dart';

class API {
  /**
   * Get all available friends from contacts
   * 
   * TODO: Actually connect to API and look by contacts
   */
  Future<Iterable<Friend>> getFriendsMatchingContact(String username) async {
    FriendService friendService = FriendService();
    return friendService.getFriends(username);
  }

  /**
   * Get all the blurts available for the current user
   * 
   * TODO: Link to the API
   */
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

  // /**
  //  * An internal method for getting friends
  //  * */
  // Future<Iterable<Friend>> _getFriends() async {
  //   //Create hardcoded list of friends
  //   String ranProfImg = "https://picsum.photos/200";
  //   Friend f1 = new Friend(
  //       ranProfImg, "Josh Beck", "@joshzbeck", FriendStatus.inactive);
  //   Friend f2 = new Friend(
  //       ranProfImg, "Joe Ewing", "@sillystring77", FriendStatus.inactive);
  //   Friend f3 = new Friend(
  //       ranProfImg, "Reagan Scott", "@reagan.scott.122", FriendStatus.inactive);
  //   Friend f4 = new Friend(
  //       ranProfImg, "Caden Bolk", "@caden.bolk", FriendStatus.inactive);
  //   Friend f5 = new Friend(
  //       ranProfImg, "Isabel Mendoza", "@isabelmendoza", FriendStatus.inactive);
  //   Iterable<Friend> friends = [f1, f2, f3, f4, f5];
  //   return friends;
  // }
}
