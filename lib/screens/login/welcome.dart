import 'package:blurt/screens/login/register.dart';
import 'package:blurt/screens/login/register_info.dart';
import 'package:blurt/services/auth_service.dart';
import 'package:blurt/services/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main.dart';
import '../main/dashboard.dart';
import '../templates/template.dart';
import '../templates/template_form.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    if (Shared.isLoggedIn() != null) {
      return MainAuth(page: WelcomePage());
    } else {
      return MainAuth(page: RegisterInfo());
    }
  }
}

/** REGISTER PAGE */
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _isVisible = false;
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  void _next() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainAuth(page: Register())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Template(
        bottomBarVisible: _isVisible,
        bottomButton: ElevatedButton(
            child: Text("get started"),
            onPressed: _next,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).primaryColor))),
        child: Padding(
            padding: EdgeInsets.all(50),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  Column(children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "blurt.",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: Theme.of(context).primaryColor),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("1.",
                            style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(
                          width: 20,
                        ),
                        Flexible(
                            child: Text(
                                "short daily audio story shared with friends",
                                style: Theme.of(context).textTheme.bodyMedium))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "2.",
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Flexible(
                            child: Text(
                                "say (something) suddenly and without careful consideration.",
                                style: Theme.of(context).textTheme.bodyMedium))
                      ],
                    ),
                  ])
                ]))));
  }
}
