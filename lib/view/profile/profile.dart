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
      child: Center(
          child: ElevatedButton(
        child: const Text("Log out"),
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Theme.of(context).primaryColor)),
        onPressed: () {
          _logOut(context);
        },
      )),
    );
  }

  /// Log the user out
  void _logOut(BuildContext context) async {
    await AuthService().signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const MainAuth(page: const Login())),
    );
  }
}
