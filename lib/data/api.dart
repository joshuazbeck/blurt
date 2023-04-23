import '../models/enums.dart';
import '../models/blurt.dart';
import '../models/friend.dart';

class API {
  /**
   * Get all available friends from contacts
   * 
   * TODO: Actually connect to API and look by contacts
   */
  Future<Iterable<Friend>> getFriendsMatchingContact() async {
    return _getFriends();
  }

  /**
   * Get all the blurts available for the current user
   * 
   * TODO: Link to the API
   */
  Future<Iterable<Blurt>> getBlurts() async {
    Iterable<Friend> friends = await _getFriends();

    String audioFile =
        "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3";

    //Create a Blurt for each friend
    Blurt b1 = new Blurt(friends.elementAt(0), audioFile,
        "Remember that time that I did that crazy thing?", 12.2);
    Blurt b2 = new Blurt(
        friends.elementAt(1), audioFile, "This carpet is so soft", 13.2);
    Blurt b3 = new Blurt(
        friends.elementAt(2), audioFile, "I went to the hair styleist…", 5.5);
    Blurt b4 = new Blurt(friends.elementAt(3), audioFile, "It is time", 12.1);
    Blurt b5 = new Blurt(friends.elementAt(4), audioFile,
        "Well it’s gonna get kinda antsy", 12.2);
    Iterable<Blurt> blurts = [b1, b2, b3, b4, b5];
    return blurts;
  }

  /** 
   * An internal method for getting friends 
   * */
  Future<Iterable<Friend>> _getFriends() async {
    //Create hardcoded list of friends
    String ranProfImg = "https://picsum.photos/200";
    Friend f1 = new Friend(
        ranProfImg, "Josh Beck", "@joshzbeck", FriendStatus.inactive);
    Friend f2 = new Friend(
        ranProfImg, "Joe Ewing", "@sillystring77", FriendStatus.inactive);
    Friend f3 = new Friend(
        ranProfImg, "Reagan Scott", "@reagan.scott.122", FriendStatus.inactive);
    Friend f4 = new Friend(
        ranProfImg, "Caden Bolk", "@caden.bolk", FriendStatus.inactive);
    Friend f5 = new Friend(
        ranProfImg, "Isabel Mendoza", "@isabelmendoza", FriendStatus.inactive);
    Iterable<Friend> friends = [f1, f2, f3, f4, f5];
    return friends;
  }
}
