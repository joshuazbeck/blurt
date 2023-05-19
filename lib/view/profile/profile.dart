import 'package:blurt/view/templates/template.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../controllers/auth_service.dart';
import '../auth/login.dart';

/// Create a profile widget
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _username = "";

  @override
  void initState() {
    super.initState();
    initUsername();
  }

  Future<void> initUsername() async {
    String? u = (await AuthService().getAuthenticatedUser())?.username;
    if (u != null) {
      setState(() {
        _username = u;
      });
    }
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
        child: const Text("back"),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text("Log out '$_username'"),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColor)),
              onPressed: () {
                _logOut(context);
              },
            )
          ]),
    );
  }

  /// Log the user out
  void _logOut(BuildContext context) async {
    await AuthService().signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainAuth(page: Login())),
    );
  }
}
