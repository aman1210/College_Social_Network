import 'package:college_social_network/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      home: Scaffold(
          body: Center(
        child: Text(
          "Hello World!",
          style: GoogleFonts.poppins(fontSize: 36),
        ),
      )),
    );
  }
}
