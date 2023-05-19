import 'package:blurt/controllers/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../model/api.dart';
import '../../model/items/friend.dart';
import '../templates/template.dart';

import 'friend_sub.dart';

/// Friend managment page
class Friends extends StatefulWidget {
  const Friends({super.key});

  @override
  State<Friends> createState() => _FriendsState();
}

/// Friend managment page
class _FriendsState extends State<Friends> {
  var _i = 1;
  var title = "";
  var subtitle = "";

  /// Store the indexes of the different friend pages
  static const int _currentI = 0;
  static const int _addI = 1;
  static const int _requestsI = 2;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setTitle();
  }

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
        child: Column(children: [
          SizedBox(
              height: 250,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                  child: Column(children: [
                    Spacer(flex: 3),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(title,
                            style: Theme.of(context).textTheme.headlineSmall)),
                    SizedBox(height: 17),
                    Opacity(
                        opacity: 0.5,
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              subtitle,
                              style: Theme.of(context).textTheme.labelLarge,
                              textAlign: TextAlign.left,
                            ))),
                    Spacer(),
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                          hintText: "search...",
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: Icon(Icons.search_rounded),
                          suffixIconColor: Theme.of(context).primaryColor),
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: GoogleFonts.josefinSlab().fontFamily),
                      onChanged: (value) {
                        // Perform search functionality here
                      },
                    ),
                  ]))),
          Flexible(
              child: Row(children: [
            // Return the correct friend sub page
            Expanded(
                child: FutureBuilder<Widget>(
              future: getPage(_i),
              builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.hasData) {
                  return snapshot
                      .data!; // use the Widget returned by the Future
                } else {
                  return Center(
                      child:
                          CircularProgressIndicator()); // show a loading indicator until the Future completes
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
          ]))
        ]));
  }

  Iterable<Friend>? contacts;
  void setTitle() {
    setState(() {
      switch (_i) {
        case _addI:
          title = "add friends";
          subtitle = "they gotta confirm before it’s official";
          break;
        case _currentI:
          title = "current friends";
          subtitle = "take a gander at your homies";
          break;
        default:
          title = "requests";
          subtitle = "well, aren't you popular!!";
      }
    });
  }

  Future<Widget> getPage(_i) async {
    contacts = await getContacts(_i);

    if (contacts != null) {
      return FriendSub(
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

    // Initialize the API
    API api = API();

    // Initialize the authentication service
    AuthService authService = AuthService();

    var value = await authService.getAuthenticatedUser();
    // Get the user

    if (value != null && value.username != null) {
      if (i == _FriendsState._addI) {
        return await api.getPossibleFriends(value.username!);
      } else if (i == _FriendsState._currentI) {
        return await api.getAcceptedFriends(value.username!);
      } else {
        return await api.getRequestedFriends(value.username!);
      }
    }
  }

  void _openAdd() {
    setState(() {
      _i = _addI;
    });
    setTitle();
  }

  void _openCurrent() {
    setState(() {
      _i = _currentI;
    });
    setTitle();
  }

  void _openRequests() {
    setState(() {
      _i = _requestsI;
    });
    setTitle();
  }
}
