import 'enums.dart';

/**
 * A model to hold references to a friend
 */
class Friend {
  final String imageUrl;
  final String firstname;
  final String lastname;
  String getName() {
    return firstname + " " + lastname;
  }

  final String username;
  final FriendStatus friendStatus;

  Friend(this.imageUrl, this.firstname, this.lastname, this.username,
      this.friendStatus);
}
