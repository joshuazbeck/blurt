import 'package:blurt/services/auth_service.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../data/api.dart';
import '../../models/enums.dart';
import '../../models/friend.dart';

class FriendsAdd extends StatefulWidget {
  const FriendsAdd({super.key});

  @override
  State<FriendsAdd> createState() => _FriendsAddState();
}

class _FriendsAddState extends State<FriendsAdd> {
  Iterable<Friend> _contacts = [];

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      AuthService authService = new AuthService();
      authService.getAuthenticatedUser().then((value) {
        if (value != null && value.username != null) {
          getContacts(value.username!);
        }
      });

      setState(() {});
    });
    super.initState();
  }

  Future<void> getContacts(String username) async {
    //Make sure we already have permissions for contacts when we get to this
    //page, so we can just retrieve it
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    if (contacts.isNotEmpty) {
      API api = API();
      api.getFriendsMatchingContact(username).then((value) {
        setState(() {
          _contacts = value;
        });
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

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text("Friends", style: Theme.of(context).textTheme.headlineSmall),
      _contacts != null
          //Build a list view of all contacts, displaying their avatar and
          // display name
          ? Flexible(
              child: ListView.builder(
              itemCount: _contacts?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                Friend friends = _contacts.elementAt(index);
                return FriendRow(
                    imageUrl: friends.imageUrl,
                    name: friends.getName(),
                    username: friends.username,
                    friendStatus: friends.friendStatus);
              },
            ))
          : Center(child: const ImportContacts())
    ]);
    ;
  }
}

class ImportContacts extends StatefulWidget {
  const ImportContacts({super.key});

  @override
  State<ImportContacts> createState() => _ImportContactsState();
}

class _ImportContactsState extends State<ImportContacts> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          final PermissionStatus permissionStatus = await _getPermission();
          if (permissionStatus == PermissionStatus.granted) {
            //TODO: Find the friends here
            _importingContacts();
          }
        },
        child: Container(child: Text("Import Contacts")));
  }

  void _importingContacts() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          duration: Duration(seconds: 4), content: Text('Importing contacts')),
    );
  }

//Check contacts permission
  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;

    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      await ContactsService.getContacts();
      return permissionStatus[Permission.contacts] ?? PermissionStatus.limited;
    } else {
      return permission;
    }
  }
}

class FriendRow extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String username;
  final FriendStatus friendStatus;
  const FriendRow(
      {super.key,
      required this.imageUrl,
      required this.name,
      required this.username,
      required this.friendStatus});

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
    return Row(children: [
      CircleAvatar(
        radius: 50.0,
        backgroundImage: NetworkImage(widget.imageUrl),
      ),
      Spacer(),
      Column(children: [
        Text(widget.name),
        Text(widget.username),
      ]),
      Spacer(),
      ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  duration: Duration(seconds: 4),
                  content: Text('Adding friend')),
            );
          },
          child: (widget.friendStatus == FriendStatus.inactive)
              ? Text('Add Friend')
              : Text('Remove Friend'))
    ]);
  }
}
