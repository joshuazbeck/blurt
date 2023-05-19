import 'package:blurt/view/auth/register_info.dart';
import 'package:blurt/view/welcome/splash.dart';
import 'package:blurt/view/main/dashboard.dart';
import 'package:blurt/view/friends/friends.dart';
import 'package:blurt/view/profile/profile.dart';
import 'package:blurt/controllers/auth_service.dart';
import 'package:blurt/controllers/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'assets/style/theme.dart';
import 'firebase_options.dart';
import 'model/items/enums.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the firebase app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Start the app
  runApp(MaterialApp(
      title: 'blurt.',
      debugShowCheckedModeBanner: false,
      theme: BlurtTheme().primary,
      home: const RoutingController()));
}

/// A controller to handle routing to different widgets based off of the authentication state
class RoutingController extends StatefulWidget {
  const RoutingController({super.key});

  @override
  State<RoutingController> createState() => _RoutingControllerState();
}

class _RoutingControllerState extends State<RoutingController> {
  AuthenticationState _authState = AuthenticationState.loading;

  Future _build() async {
    // Check if the user is logged in based off of the shared credentials
    User? _user = await Shared.isLoggedIn();

    if (_user != null) {
      // Create an instance of the authentication service
      AuthService authService = AuthService();

      // Check if the full user information is available
      if (await authService.getFullUser(_user) != null) {
        _authState = AuthenticationState.authenticated;
        return;
      } else {
        _authState = AuthenticationState.missingInfo;
        return;
      }
    } else {
      _authState = AuthenticationState.unauthenticated;
      return;
    }
  }

  /// *********** BUILD THE WIDGET *********
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: (context, snapshot) {
          if (_authState == AuthenticationState.loading) {
            return const Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: BlurtTheme.white,
                body: Center(child: CircularProgressIndicator()));
          } else if (_authState == AuthenticationState.unauthenticated) {
            return MainAuth(page: const Splash());
          } else if (_authState == AuthenticationState.authenticated) {
            return Main(page: const Dashboard());
          } else {
            return MainAuth(page: RegisterInfo());
          }
        },
        future: _build());
  }
}

/// An instance of the main widget to handle styling
class Main extends StatelessWidget {
  final Widget page;
  String text = "blurt.";
  Main({super.key, required this.page, this.text = "blurt."});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Row(children: [
              GestureDetector(
                onTap: () {
                  _openProfile(context);
                },
                child: const CircleAvatar(
                  backgroundImage: NetworkImage('https://picsum.photos/200'),
                  radius: 20,
                ),
              ),
              const Spacer(),
              Text(this.text),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  _manageFriends(context);
                },
                color: BlurtTheme.white,
              ),
            ])),
        body: page);
  }

  /// Open the user profile
  void _openProfile(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) =>
              MainSecondary(page: const Profile(), text: "profile.")),
    );
  }

  void _manageFriends(BuildContext context) async {
    // AuthService authService = AuthService();
    // await authService.signOut();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => MainAuth(page: const Friends())),
    );
  }
}

/// An instance of the main widget to handle styling (a custom styling)
class MainSecondary extends StatelessWidget {
  final StatefulWidget page;
  String text = "blurt.";
  MainSecondary({super.key, required this.page, this.text = "blurt."});

  /// ********** BUILD THE WIDGET *********
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: BlurtTheme.white,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).primaryColor,
            title: Row(children: [
              const Spacer(),
              Text(this.text),
              const Spacer(),
            ])),
        body: page);
  }
}

/// Create a widget that is customized for authentication workflows
class MainAuth extends StatelessWidget {
  Widget page;
  MainAuth({super.key, required this.page});

  /// ********** BUILD THE WIDGET *********
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: BlurtTheme.white,
        body: page);
  }
}
