import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData tema() {
  return ThemeData(
    textTheme: TextTheme(
      bodySmall: GoogleFonts.roboto(
        fontSize: 12,
      ),
      bodyMedium: GoogleFonts.roboto(
        fontSize: 14,
      ),
      bodyLarge: GoogleFonts.roboto(
        fontSize: 16,
      ),
      titleLarge: GoogleFonts.roboto(
        fontSize: 22,
      ),
    ),
  );
}
