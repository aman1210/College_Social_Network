import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var lightTheme = ThemeData(
  primaryColor: Colors.blue,
  brightness: Brightness.light,
  textTheme: GoogleFonts.poppinsTextTheme(),
);

var darkTheme = ThemeData(
  scaffoldBackgroundColor: Color(0xff1a1d22),
  primaryColor: Colors.blue,
  brightness: Brightness.dark,
  textTheme: GoogleFonts.poppinsTextTheme(),
);
