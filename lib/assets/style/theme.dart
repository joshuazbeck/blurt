import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BlurtTheme {
  ThemeData primary = ThemeData(primaryColor: Colors.red).copyWith(
    textTheme: TextTheme(
      headlineMedium: GoogleFonts.josefinSlab(
          fontSize: 40, color: Colors.black, fontWeight: FontWeight.bold),
      headlineSmall: GoogleFonts.josefinSlab(
          fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
      titleLarge: GoogleFonts.josefinSlab(
          fontSize: 20, color: Colors.black38, fontWeight: FontWeight.bold),
      labelLarge: GoogleFonts.josefinSlab(
          fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
      labelMedium: GoogleFonts.josefinSlab(
          fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
      labelSmall: GoogleFonts.josefinSlab(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline),
      bodyLarge: GoogleFonts.josefinSlab(
          fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
      bodyMedium: GoogleFonts.josefinSlab(
          fontSize: 20,
          fontWeight: FontWeight.normal,
          color: Colors.black,
          height: 1.5),
      bodySmall: GoogleFonts.josefinSlab(
          fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
    ),
  );
}
