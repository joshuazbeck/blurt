import 'package:blurt/screens/login/register_info.dart';
import 'package:blurt/screens/login/login.dart';
import 'package:blurt/screens/login/register.dart';
import 'package:blurt/screens/login/welcome.dart';
import 'package:blurt/screens/main/dashboard.dart';
import 'package:blurt/services/auth_service.dart';
import 'package:blurt/services/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:google_fonts/google_fonts.dart';

import 'assets/style/theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
      title: 'Blurt',
      theme: BlurtTheme().primary,
      home: const RoutingController()));
}

class RoutingController extends StatefulWidget {
  const RoutingController({super.key});

  @override
  State<RoutingController> createState() => _RoutingControllerState();
}

class _RoutingControllerState extends State<RoutingController> {
  AuthenticationState _authState = AuthenticationState.loading;

  Future _build() async {
    User? _user = await Shared.isLoggedIn();
    if (_user != null) {
      AuthService authService = AuthService();

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: (context, snapshot) {
          if (_authState == AuthenticationState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (_authState == AuthenticationState.unauthenticated) {
            return const MainAuth(page: Register());
          } else if (_authState == AuthenticationState.authenticated) {
            return Main(page: const Dashboard());
          } else {
            return const MainAuth(page: const RegisterInfo());
          }
        },
        future: _build());
  }
}

class Main extends StatelessWidget {
  final StatefulWidget page;
  Main({super.key, required this.page});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Row(children: [
              GestureDetector(
                onTap: () {
                  print("HEYO");
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage('https://picsum.photos/200'),
                  radius: 20,
                ),
              ),
              Spacer(),
              const Text('blurt.'),
              Spacer(),
              IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  _openProfile(context);
                },
                color: Colors.white,
              ),
            ])),
        body: page);
  }

  void _openProfile(BuildContext context) async {
    AuthService authService = AuthService();
    await authService.signOut();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => MainAuth(page: Login())),
    );
  }
}

class MainAuth extends StatelessWidget {
  final Widget page;
  const MainAuth({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: page);

    FirebaseAuth instance = FirebaseAuth.instance;
    if (instance.currentUser != null) {
      AuthService _auth = AuthService();
      // FullUser? fullUser = await _auth.getFullUser(instance.currentUser!);
      // if (fullUser != null) {
      //   //Show the current dashboard
      // } else {
      //   //Show the complete profile
      // }
    } else {
      //Show login or registration
    }
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return MaterialApp(
//             title: 'Blurt',
//             theme: ThemeData(
//               fontFamily: "Josefin Slab",
//               colorScheme: ColorScheme.fromSeed(
//                   seedColor:
//                       Color(int.parse("F77777", radix: 16)).withOpacity(1.0)),
//             ),
//             home: const Layout(),
//           );
//         }

//         return MaterialApp(
//           title: 'Blurt',
//           theme: ThemeData(
//             fontFamily: "Josefin Slab",
//             colorScheme: ColorScheme.fromSeed(
//                 seedColor:
//                     Color(int.parse("F77777", radix: 16)).withOpacity(1.0)),
//           ),
//           home: const Layout(),
//         );
//       },
//     );
  }
}
