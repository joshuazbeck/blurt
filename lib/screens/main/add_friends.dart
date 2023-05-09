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
      //Initialize the authentication service
      AuthService authService = new AuthService();
      authService.getAuthenticatedUser().then((value) {
        if (value != null && value.username != null) {
          //Get the contacts if the user is logged in
          getContacts(value.username!);
        }
      });

      //Refresh state
      setState(() {});
    });

    //Call the parent method
    super.initState();
  }

  /// Get the contacts
  Future<void> getContacts(String username) async {
    //Make sure we already have permissions for contacts when we get to this
    //page, so we can just retrieve it
    final Iterable<Contact> contacts = await ContactsService.getContacts();

    // If contacts exist
    if (contacts.isNotEmpty) {
      // Get available friends from the database based on contacts
      API api = API();
      api.getFriendsMatchingContact(username).then((value) {
        setState(() {
          _contacts = value;
        });
      });
    } else {
      // If there are no contacts, most likely this is a permission issue requiring settings remedy
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            duration: Duration(seconds: 4),
            content: Text(
                'Please check the Settings app to allow access to contacts')),
      );
    }
  }

  /// *********** BUILD THE FORM *************
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text("Friends", style: Theme.of(context).textTheme.headlineSmall),
      _contacts != null
          //Build a list view of all contacts, displaying their avatar and
          // display name
          ? Flexible(
              child: ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (BuildContext context, int index) {
                Friend friends = _contacts.elementAt(index);
                return FriendRow(
                    imageUrl: friends.imageUrl,
                    name: friends.getName(),
                    username: friends.username,
                    friendStatus: friends.friendStatus);
              },
            ))
          : const Center(child: ImportContacts())
    ]);
    ;
  }
}

/// The import contacts button and business logic
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
        child: const Text("Import Contacts"));
  }

  /// Show a message that contacts are importing
  void _importingContacts() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          duration: Duration(seconds: 4), content: Text('Importing contacts')),
    );
  }

  /// Check contacts permission
  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;

    //If the contacts permission is not granted or denied
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      //Ask for contacts permission
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      await ContactsService.getContacts();
      return permissionStatus[Permission.contacts] ?? PermissionStatus.limited;
    } else {
      return permission;
    }
  }
}

/// A widget to store the firend information
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
      const Spacer(),
      Column(children: [
        Text(widget.name),
        Text(widget.username),
      ]),
      const Spacer(),
      ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  duration: Duration(seconds: 4),
                  content: Text('Adding friend')),
            );
          },
          child: (widget.friendStatus == FriendStatus.inactive)
              ? const Text('Add Friend')
              : const Text('Remove Friend'))
    ]);
  }
}
