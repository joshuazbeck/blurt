import 'package:blurt/controllers/blurt_service.dart';
import 'package:blurt/controllers/auth_service.dart';
import 'package:flutter/material.dart';

import '../../model/items/blurt.dart';
import 'blurt_row.dart';

class Mine extends StatefulWidget {
  const Mine({super.key});

  @override
  State<Mine> createState() => _MineState();
}

class _MineState extends State<Mine> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get the blurts

      // Refresh state

      getMyBlurt();
    });
    super.initState();
  }

  Blurt? _myBlurt = null;
  Future<void> getMyBlurt() async {
    BlurtService bS = BlurtService();
    // Create a new instance of the authentication service
    AuthService authService = AuthService();

    // Get the authenticated users
    authService.getAuthenticatedUser().then((value) async {
      // If the user is logged in
      if (value != null && value.username != null) {
        Blurt? newBlurt = await bS.getPersonalBlurt(value.username!);
        setState(() {
          _myBlurt = newBlurt;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              (_myBlurt != null)
                  ? Column(
                      children: [BlurtRow(expanded: false, blurt: _myBlurt!)])
                  : Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          CircularProgressIndicator(),
                        ])),
            ]));
  }
}
