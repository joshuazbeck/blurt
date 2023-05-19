import 'package:blurt/view/auth/register.dart';
import 'package:blurt/view/auth/register_info.dart';
import 'package:blurt/controllers/auth_service.dart';
import 'package:blurt/controllers/shared.dart';
import 'package:blurt/view/welcome/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main.dart';
import '../main/dashboard.dart';
import '../templates/template.dart';
import '../templates/template_form.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  /// ********** BUILD THE FORM *************
  @override
  Widget build(BuildContext context) {
    return MainAuth(page: SplashPage());
  }
}

/** REGISTER PAGE */
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _isVisible = false;
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      _next();
    });
  }

  void _next() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainAuth(page: Welcome())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Template(
        bottomBarVisible: false,
        bottomButton: Container(),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('lib/assets/icon/icon_dark.png', width: 45, height: 45),
            SizedBox(height: 20),
            Text(
              "blurt.",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Theme.of(context).primaryColor),
            ),
          ],
        )));
  }
}
