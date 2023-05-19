import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BlurtTheme {
  static const Color white = Color.fromRGBO(247, 247, 247, 1);
  static const Color whiteLight = Colors.white24;
  static const Color black = Colors.black;

  ThemeData primary =
      ThemeData(primaryColor: Color.fromRGBO(243, 96, 102, 1)).copyWith(
    textTheme: TextTheme(
      headlineMedium: GoogleFonts.josefinSlab(
          fontSize: 40, color: black, fontWeight: FontWeight.bold),
      headlineSmall: GoogleFonts.josefinSlab(
          fontSize: 30, color: black, fontWeight: FontWeight.bold),
      titleLarge: GoogleFonts.josefinSlab(
          fontSize: 20, color: black, fontWeight: FontWeight.bold),
      labelLarge: GoogleFonts.josefinSlab(
          fontSize: 18, color: black, fontWeight: FontWeight.bold),
      labelMedium: GoogleFonts.josefinSlab(
          fontSize: 16, color: black, fontWeight: FontWeight.bold),
      labelSmall: GoogleFonts.josefinSlab(
          fontSize: 12,
          color: black,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline),
      bodyLarge: GoogleFonts.josefinSlab(
          fontSize: 30, color: black, fontWeight: FontWeight.bold),
      bodyMedium: GoogleFonts.josefinSlab(
          fontSize: 20,
          fontWeight: FontWeight.normal,
          color: black,
          height: 1.5),
      bodySmall: GoogleFonts.josefinSlab(
          fontSize: 14, fontWeight: FontWeight.w600, color: black),
    ),
  );
}
