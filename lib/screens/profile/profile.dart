import 'package:blurt/screens/templates/template.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../services/auth_service.dart';
import '../auth/login.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Template(
      child: Center(
          child: ElevatedButton(
        child: Text("Log out"),
        onPressed: () {
          _logOut(context);
        },
      )),
      bottomButton: ElevatedButton(
        child: Text("done"),
        onPressed: () {
          Navigator.pop(context);
        },
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Theme.of(context).primaryColor)),
      ),
    );
  }

  void _logOut(BuildContext context) async {
    await AuthService().signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainAuth(page: Login())),
    );
  }
}
