import 'package:blurt/controllers/auth_service.dart';
import 'package:blurt/controllers/friend_service.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

import '../../model/api.dart';
import '../../model/items/enums.dart';
import '../../model/items/friend.dart';
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
          Expanded(
              child: FutureBuilder<Widget>(
            future: getPage(_i),
            builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!; // use the Widget returned by the Future
              } else {
                return CircularProgressIndicator(); // show a loading indicator until the Future completes
              }
            },
          )),
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

  Iterable<Friend>? contacts;
  Future<Widget> getPage(_i) async {
    // setState(() {});
    print("TEST");
    getContacts(_i).then((value) => {
          print("GOT CONTACTS " + value.toString()),
        });
    contacts = await getContacts(_i);

    if (contacts != null) {
      return FriendPage(
          i: _i, contacts: contacts!, updateFriendsParent: updateContacts);
    } else {
      //TODO: Loading
      return Text("Loading");
    }
  }

  void updateContacts() async {
    this.contacts = await getContacts(_i);
    setState(() {});
  }

  Future<Iterable<Friend>?> getContacts(int i) async {
    //Make sure we already have permissions for contacts when we get to this
    //page, so we can just retrieve it
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    if (contacts.isNotEmpty) {
      // Initialize the API
      API api = API();

      // Initialize the authentication service
      AuthService authService = AuthService();

      var value = await authService.getAuthenticatedUser();
      // Get the user

      if (value != null && value.username != null) {
        if (i == _ManageFriendsState._addI) {
          return await api.getPossibleFriends(value.username!);
        } else if (i == _ManageFriendsState._currentI) {
          return await api.getAcceptedFriends(value.username!);
        } else {
          return await api.getRequestedFriends(value.username!);
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            duration: Duration(seconds: 4),
            content: Text(
                'Please check the Settings app to allow access to contacts')),
      );
    }
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
}

class FriendPage extends StatefulWidget {
  int i;
  FriendPage(
      {super.key,
      required this.i,
      required this.contacts,
      required this.updateFriendsParent});

  final Function() updateFriendsParent;
  Iterable<Friend> contacts = [];
  String? username;

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
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

    return Column(children: [
      widget.contacts != null
          //Build a list view of all contacts, displaying their avatar and
          // display name
          ? Flexible(
              child: Padding(
                  padding: const EdgeInsets.all(30),
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
                  )))
          : const Center(child: Text("No friends available.  Try adding some"))
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
                              ?.copyWith(color: Colors.white))))
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
