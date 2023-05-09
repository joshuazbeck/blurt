import 'package:blurt/services/auth_service.dart';
import 'package:blurt/services/friend_service.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

import '../../data/api.dart';
import '../../models/enums.dart';
import '../../models/friend.dart';
import '../templates/template.dart';

/// Friend managment page
class ManageFriends extends StatefulWidget {
  const ManageFriends({super.key});

  @override
  State<ManageFriends> createState() => _ManageFriendsState();
}

/// Friend managment page
class _ManageFriendsState extends State<ManageFriends> {
  var _i = 1;

  /// Store the indexes of the different friend pages
  static const int _currentI = 0;
  static const int _addI = 1;
  static const int _requestsI = 2;

  @override
  Widget build(BuildContext context) {
    return Template(
        bottomButton: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Theme.of(context).primaryColor)),
          child: const Text("done"),
        ),
        child: Row(children: [
          // Return the correct friend sub page
          Expanded(child: getFriendPage(_i)),
          Column(
            children: [
              const Spacer(),
              RotatedBox(
                  quarterTurns: 5,
                  child: Row(children: [
                    // Hold links to the different pages
                    TextButton(
                      child: Text("CURRENT",
                          style: (_i == _currentI)
                              ? TextStyle(
                                  height: 1.5,
                                  shadows: [
                                    //Hack to move the underlines away from the text
                                    Shadow(
                                        color: Theme.of(context).primaryColor,
                                        offset: const Offset(0, -3))
                                  ],
                                  color: Colors.transparent,
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Theme.of(context).primaryColor,
                                )
                              : TextStyle(
                                  color: Theme.of(context).primaryColor,
                                )),
                      onPressed: () {
                        //Open the "CURRENT" friend page
                        _openCurrent();
                      },
                    ),
                    TextButton(
                      child: Text("ADD",
                          style: (_i == _addI)
                              ? TextStyle(
                                  height: 1.5,
                                  shadows: [
                                    // Hack to move the underlines away from the text
                                    Shadow(
                                        color: Theme.of(context).primaryColor,
                                        offset: const Offset(0, -3))
                                  ],
                                  color: Colors.transparent,
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Theme.of(context).primaryColor,
                                )
                              : TextStyle(
                                  color: Theme.of(context).primaryColor,
                                )),
                      onPressed: () {
                        _openAdd();
                      },
                    ),
                    TextButton(
                      child: Text("REQUESTS",
                          style: (_i == _requestsI)
                              ? TextStyle(
                                  height: 1.5,
                                  // Hack to move the underlines away from the text
                                  shadows: [
                                    Shadow(
                                        color: Theme.of(context).primaryColor,
                                        offset: const Offset(0, -3))
                                  ],
                                  color: Colors.transparent,
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Theme.of(context).primaryColor,
                                )
                              : TextStyle(
                                  color: Theme.of(context).primaryColor,
                                )),
                      onPressed: () {
                        _openRequests();
                      },
                    )
                  ])),
              const Spacer()
            ],
          )
        ]));
  }

  void _openAdd() {
    setState(() {
      _i = _addI;
    });
  }

  void _openCurrent() {
    setState(() {
      _i = _currentI;
    });
  }

  void _openRequests() {
    setState(() {
      _i = _requestsI;
    });
  }

  /// Return the correct friend sub page
  Widget getFriendPage(final int i) {
    switch (i) {
      case _addI:
        return const AddFriend();
      case _currentI:
        return const CurrentFriend();
      default:
        return const RequestFriend();
    }
  }
}

/// Add a friend page
class AddFriend extends StatefulWidget {
  const AddFriend({super.key});

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  Iterable<Friend> _contacts = [];
  String? username;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getContacts();
      setState(() {});
    });

    _initAsync();
    super.initState();
  }

  Future<void> _initAsync() async {
    AuthService authServ = AuthService();
    FullUser? fullUser = await authServ.getAuthenticatedUser();
    if (fullUser != null && fullUser.username != null) {
      username = fullUser.username!;
    } else {
      print("There is no user defined for a protected page");
      throw Error();
    }
  }

  Future<void> getContacts() async {
    //Make sure we already have permissions for contacts when we get to this
    //page, so we can just retrieve it
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    if (contacts.isNotEmpty) {
      // Initialize the API
      API api = API();

      // Initialize the authentication service
      AuthService authService = AuthService();

      // Get the user
      authService.getAuthenticatedUser().then((value) {
        if (value != null && value.username != null) {
          api.getFriendsMatchingContact(value.username!).then((value) {
            setState(() {
              _contacts = value;
            });
          });
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            duration: Duration(seconds: 4),
            content: Text(
                'Please check the Settings app to allow access to contacts')),
      );
    }
  }

  /// ************ BUILD THE WIDGET *********
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text("Friends", style: Theme.of(context).textTheme.headlineSmall),
      _contacts != null
          //Build a list view of all contacts, displaying their avatar and
          // display name
          ? Flexible(
              child: Padding(
                  padding: const EdgeInsets.all(30),
                  //TODO: Integrate a search bar
                  child: ListView.builder(
                    itemCount: _contacts?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      Friend friends = _contacts.elementAt(index);
                      return FriendRow(
                          imageUrl: friends.imageUrl,
                          name: friends.getName(),
                          username: friends.username,
                          friendStatus: friends.friendStatus,
                          personalUsername: username!);
                    },
                  )))
          : const Center(child: CircularProgressIndicator())
    ]);
    ;
  }
}

class CurrentFriend extends StatefulWidget {
  const CurrentFriend({super.key});

  @override
  State<CurrentFriend> createState() => _CurrentFriendState();
}

class _CurrentFriendState extends State<CurrentFriend> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("CURRENT"));
  }
}

class RequestFriend extends StatefulWidget {
  const RequestFriend({super.key});

  @override
  State<RequestFriend> createState() => _RequestFriendState();
}

class _RequestFriendState extends State<RequestFriend> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("REQUEST"));
  }
}

/// Build a friend row widget
class FriendRow extends StatefulWidget {
  // Hold the data for the widget
  final String personalUsername;
  final String imageUrl;
  final String name;
  final String username;
  final FriendStatus friendStatus;

  // Friend constructor
  const FriendRow(
      {super.key,
      required this.imageUrl,
      required this.name,
      required this.username,
      required this.friendStatus,
      required this.personalUsername});

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
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        CircleAvatar(
          radius: 25.0,
          backgroundImage: NetworkImage(widget.imageUrl),
        ),
        const Spacer(),
        Column(children: [
          Text(widget.name, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(
            height: 10,
          ),
          Text(widget.username, style: Theme.of(context).textTheme.bodySmall),
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
                        ?.copyWith(color: Colors.white))))
      ]),
      const SizedBox(
        height: 20,
      ),
    ]);
  }

  /// Get the appropriate friend text
  String _friendText() {
    if (widget.friendStatus == FriendStatus.inactive) {
      return 'add';
    } else if (widget.friendStatus == FriendStatus.active) {
      return 'remove';
    } else if (widget.friendStatus == FriendStatus.pending) {
      return "accept";
    } else if (widget.friendStatus == FriendStatus.requested) {
      return "pending";
    } else {
      return "accept";
    }
  }

  /// Send friend requests
  void _manageFriend() {
    if (widget.friendStatus == FriendStatus.inactive) {
      //Send a friend
      FriendService fs = FriendService();

      fs.sendFriendRequest(widget.personalUsername, widget.username);
    } else if (widget.friendStatus == FriendStatus.active) {
      //Remove a friend
    } else if (widget.friendStatus == FriendStatus.pending) {
      //Display a pending alert
    } else {
      //Accept a friend request
    }
  }
}
