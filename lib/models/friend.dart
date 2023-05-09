import 'enums.dart';

/// Store a reference to a friend
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

// Store a reference to the user with the full information
class FullUser {
  String? uid;
  String? email;
  String? username;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? birthDate;
}
