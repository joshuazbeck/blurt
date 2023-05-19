import 'package:blurt/controllers/friend_service.dart';
import 'package:flutter/material.dart';
import '../../assets/style/theme.dart';
import '../../model/items/enums.dart';
import '../../model/items/friend.dart';

/// Build a friend row widget
class FriendRow extends StatefulWidget {
  // Hold the data for the widget
  final String personalUsername;
  Friend? availableFriend;
  final Function() updateFriendsParent;
  // Friend constructor
  FriendRow(
      {super.key,
      required this.personalUsername,
      required this.availableFriend,
      required this.updateFriendsParent});

  @override
  State<FriendRow> createState() => _FriendRowState();
}

class _FriendRowState extends State<FriendRow> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.availableFriend == null)
        ? const Center(child: CircularProgressIndicator.adaptive())
        : Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(widget.availableFriend!.imageUrl),
              ),
              const Spacer(),
              Column(children: [
                Text(widget.availableFriend!.getName(),
                    style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(
                  height: 10,
                ),
                Text(widget.availableFriend!.username,
                    style: Theme.of(context).textTheme.bodySmall),
              ]),
              const Spacer(),
              SizedBox(
                  width: 100,
                  height: 40,
                  child: ElevatedButton(
                      onPressed: () {
                        _manageFriend();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor),
                      child: Text(_friendText(),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: BlurtTheme.white))))
            ]),
            const SizedBox(
              height: 20,
            ),
          ]);
  }

  /// Get the appropriate friend text
  String _friendText() {
    if (widget.availableFriend == null) {
      return 'loading...';
    }
    if (widget.availableFriend!.friendStatus == FriendStatus.inactive) {
      return 'add';
    } else if (widget.availableFriend!.friendStatus == FriendStatus.active) {
      return 'remove';
    } else if (widget.availableFriend!.friendStatus == FriendStatus.pending) {
      return "accept";
    } else if (widget.availableFriend!.friendStatus == FriendStatus.requested) {
      return "pending";
    } else {
      return "accept";
    }
  }

  /// Send friend requests
  void _manageFriend() async {
    if (widget.availableFriend == null) {
      return;
    }
    FriendService fs = FriendService();
    if (widget.availableFriend!.friendStatus == FriendStatus.inactive) {
      //Send a friend
      await fs.sendFriendRequest(
          widget.personalUsername, widget.availableFriend!.username);
    } else if (widget.availableFriend!.friendStatus == FriendStatus.active) {
      //Remove a friend
      await fs.removeFriendRequest(
          widget.personalUsername, widget.availableFriend!.username);
    } else if (widget.availableFriend!.friendStatus == FriendStatus.pending) {
      //Display a pending alert
      await fs.acceptFriendRequest(
          widget.personalUsername, widget.availableFriend!.username);
    } else {
      //Accept a friend request
    }

    Friend? f = await fs.getFriend(
        widget.availableFriend!.username, widget.personalUsername);

    widget.updateFriendsParent();
  }
}
