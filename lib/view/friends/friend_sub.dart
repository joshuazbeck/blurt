import 'package:blurt/controllers/auth_service.dart';
import 'package:blurt/controllers/friend_service.dart';
import 'package:blurt/main.dart';
import 'package:blurt/view/main/dashboard.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

import '../../model/api.dart';
import '../../model/items/enums.dart';
import '../../model/items/friend.dart';
import '../templates/template.dart';
import 'package:badges/badges.dart' as badges;

import 'friend_row.dart';

class FriendSub extends StatefulWidget {
  int i;
  FriendSub(
      {super.key,
      required this.i,
      required this.contacts,
      required this.updateFriendsParent});

  final Function() updateFriendsParent;
  Iterable<Friend> contacts = [];
  String? username;

  @override
  State<FriendSub> createState() => _FriendSubState();
}

class _FriendSubState extends State<FriendSub> {
  Future<void> _initAsync() async {
    AuthService authServ = AuthService();
    FullUser? fullUser = await authServ.getAuthenticatedUser();
    if (fullUser != null && fullUser.username != null) {
      if (this.mounted) {
        setState(() {
          widget.username = fullUser.username;
        });
      }
    } else {
      print("There is no user defined for a protected page");
      throw Error();
    }
  }

  @override
  Widget build(BuildContext context) {
    _initAsync();

    return Padding(
        padding: const EdgeInsets.all(30),
        child: Column(children: [
          widget.contacts != null
              //Build a list view of all contacts, displaying their avatar and
              // display name
              ? Flexible(

                  //TODO: Integrate a search bar
                  child: ListView.builder(
                  itemCount: widget.contacts?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    Friend friend = widget.contacts.elementAt(index);
                    return (widget.username != null)
                        ? FriendRow(
                            availableFriend: friend,
                            personalUsername: widget.username!,
                            updateFriendsParent: widget.updateFriendsParent,
                          )
                        : CircularProgressIndicator.adaptive();
                  },
                ))
              : const Center(
                  child: Text("No friends available.  Try adding some"))
        ]));
    ;
  }
}
