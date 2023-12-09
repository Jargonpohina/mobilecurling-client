import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeDataCurling {
  static const primaryColorDark = Color.fromARGB(255, 144, 73, 151);
  static const primaryColorDarkLighter = Color.fromARGB(255, 123, 107, 124);
  static const highlightColorDark = Color.fromARGB(255, 200, 96, 157);
  static const defaultTextColorDark = Color.fromARGB(255, 230, 204, 232);

  static const primaryColorLight = Color.fromARGB(255, 192, 98, 201);
  static const primaryColorLightLighter = Color.fromARGB(255, 171, 148, 173);
  static const highlightColorLight = Color.fromARGB(255, 200, 96, 157);
  static const defaultTextColorLight = Color.fromARGB(255, 92, 62, 94);

  ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColorDark,
      highlightColor: highlightColorDark,
      primaryColorLight: primaryColorDarkLighter,
      textTheme: TextTheme(
          titleLarge: GoogleFonts.rubik(color: primaryColorDark, fontSize: 40),
          displayLarge: GoogleFonts.rubik(color: primaryColorDark, fontSize: 57),
          displayMedium: GoogleFonts.rubik(color: primaryColorLight, fontSize: 25, letterSpacing: 2),
          bodyMedium: GoogleFonts.rubik(color: defaultTextColorDark, fontSize: 14),
          bodySmall: GoogleFonts.rubik(color: defaultTextColorDark, fontSize: 12),
          headlineSmall: GoogleFonts.workSans(color: defaultTextColorDark, fontSize: 14, letterSpacing: 2)),
    );
  }
}
