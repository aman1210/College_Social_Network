import 'package:college_social_network/utils/theme.dart';
import 'package:college_social_network/view_models/auth_view_model.dart';
import 'package:college_social_network/view_models/message_view_model.dart';
import 'package:college_social_network/views/admin_screen.dart/admin_screen.dart';
import 'package:college_social_network/views/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthViewModel()),
        ChangeNotifierProvider(create: (ctx) => MessageViewModel()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: darkTheme,
        debugShowCheckedModeBanner: false,
        home: MainScreen(),
      ),
    );
  }
}
