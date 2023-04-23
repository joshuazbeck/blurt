import 'enums.dart';

/**
 * A model to hold references to a friend
 */
class Friend {
  final String imageUrl;
  final String name;
  final String username;
  final FriendStatus friendStatus;

  Friend(this.imageUrl, this.name, this.username, this.friendStatus);
}
