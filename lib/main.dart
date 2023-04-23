import 'package:blurt/screens/login/register.dart';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

import 'screens/templates/layout.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    final newTextTheme = Theme.of(context).textTheme.apply(
          bodyColor: Colors.pink,
          displayColor: Colors.pink,
        );
    return MaterialApp(
      title: 'Blurt',
      theme: ThemeData(
        primaryTextTheme: Typography(platform: TargetPlatform.iOS).white,
        textTheme: Typography(platform: TargetPlatform.iOS).white,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color(int.parse("F77777", radix: 16)).withOpacity(1.0)),
      ),
      home: const Layout(),
    );
  }
}
