import 'package:blurt/screens/main/dashboard.dart';
import 'package:blurt/screens/login/register_personal_info.dart';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

import '../main/add_friends.dart';
import '../login/register.dart';

class Layout extends StatelessWidget {
  const Layout({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: (Text('Blurt.'))),
        backgroundColor: Color(int.parse("242322", radix: 16)).withOpacity(1.0),
        body: const SafeArea(child: FriendsAdd()));

    //FriendsAdd
    //Dashboard
    //Register
    //RegisterPersonalInfo
  }
}
