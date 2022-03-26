import 'package:college_social_network/components/app_bar.dart';
import 'package:college_social_network/components/side_bar.dart';
import 'package:college_social_network/responsive.dart';
import 'package:college_social_network/view_models/auth_view_model.dart';
import 'package:college_social_network/views/auth_screen/auth_screen.dart';
import 'package:college_social_network/views/home_screen/chat_list.dart';
import 'package:college_social_network/views/home_screen/post_feed.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    AuthViewModel authViewModel = context.watch<AuthViewModel>();
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Column(
        children: [
          const CustomAppBar(),
          ui(authViewModel),
        ],
      ),
    );
  }

  ui(AuthViewModel authViewModel) {
    if (!authViewModel.userLoggedIn) {
      return const AuthScreen();
    }
    return Expanded(
      child: Responsive(
        mobile: const PostFeed(),
        tablet: Row(
          children: const [
            Expanded(flex: 8, child: PostFeed()),
            Expanded(flex: 4, child: ChatList()),
          ],
        ),
        desktop: Row(children: const [
          Expanded(flex: 2, child: SideBar()),
          Expanded(
            flex: 7,
            child: PostFeed(),
          ),
          Expanded(flex: 3, child: ChatList()),
        ]),
      ),
    );
  }
}
