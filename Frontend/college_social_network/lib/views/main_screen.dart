import 'package:college_social_network/components/app_bar.dart';
import 'package:college_social_network/responsive.dart';
import 'package:college_social_network/views/auth_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white70,
        body: Column(
          children: [
            CustomAppBar(),
            Responsive(
                mobile: AuthScreen(),
                tablet: AuthScreen(),
                desktop: AuthScreen()),
          ],
        ));
  }
}
