import 'package:ConnectUs/view_models/admin_view_model.dart';
import 'package:ConnectUs/view_models/chat_view_model.dart';
import 'package:ConnectUs/view_models/post_view_model.dart';
import 'package:ConnectUs/view_models/user_view_model.dart';
import 'package:ConnectUs/views/admin_screen.dart/admin_screen.dart';
import 'package:ConnectUs/views/auth_screen/auth_screen.dart';

import '../../utils/theme.dart';
import '../../view_models/auth_view_model.dart';
import '../../view_models/message_view_model.dart';
import '../../views/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        ChangeNotifierProvider(create: (ctx) => AdminViewModel()),
        ChangeNotifierProvider(create: (ctx) => ChatModel()),
        ChangeNotifierProvider(create: (ctx) => MessageViewModel()),
        ChangeNotifierProvider(create: (ctx) => PostViewModel()),
        ChangeNotifierProxyProvider<AuthViewModel, UserViewModel>(
            create: (ctx) => UserViewModel(),
            update: (context, auth, user) {
              return user!
                ..id = auth.userId
                ..token = auth.token;
            }),
      ],
      child: Consumer<AuthViewModel>(
        builder: (context, value, child) {
          return MaterialApp(
            title: 'ConnectUs',
            theme: value.isDarkMode ? darkTheme : lightTheme,
            debugShowCheckedModeBanner: false,
            home: value.isAdmin ? AdminScreen() : MainScreen(),
          );
        },
      ),
    );
  }
}
