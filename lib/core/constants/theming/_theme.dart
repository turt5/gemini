import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme{
  static ThemeData getTheme()=> ThemeData(
    fontFamily: GoogleFonts.poppins().fontFamily,
    colorScheme: ColorScheme.dark(
      primary: CupertinoColors.activeBlue,
      secondary: CupertinoColors.activeGreen,
      surface: Colors.black,
    )
  );
}