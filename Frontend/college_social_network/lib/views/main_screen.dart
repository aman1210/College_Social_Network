import 'package:college_social_network/components/app_bar.dart';
import 'package:college_social_network/components/current_state.dart';
import 'package:college_social_network/components/side_bar.dart';
import 'package:college_social_network/responsive.dart';
import 'package:college_social_network/view_models/auth_view_model.dart';
import 'package:college_social_network/views/auth_screen/auth_screen.dart';
import 'package:college_social_network/views/home_screen/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool showChatList = true;

  @override
  void dispose() {
    super.dispose();
    CurrentState.pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthViewModel authViewModel = context.watch<AuthViewModel>();
    var pageController = CurrentState.pageController;

    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.white70,
        drawerEnableOpenDragGesture: false,
        drawer: const SideBar(),
        body: Column(
          children: [
            CustomAppBar(),
            ui(authViewModel, pageController),
          ],
        ),
      ),
    );
  }

  ui(AuthViewModel authViewModel, PageController pageController) {
    if (!authViewModel.userLoggedIn) {
      return const AuthScreen();
    }
    return Expanded(
      child: Responsive(
        mobile: mainarea(pageController),
        tablet: Row(
          children: [
            Expanded(flex: 8, child: mainarea(pageController)),
            Expanded(flex: 3, child: ChatList()),
          ],
        ),
        desktop: Row(
          children: [
            const Expanded(flex: 2, child: SideBar()),
            Expanded(
              flex: 6,
              child: mainarea(pageController),
            ),
            Expanded(
              flex: 2,
              child: ChatList(),
            ),
          ],
        ),
      ),
    );
  }

  PageView mainarea(PageController controller) {
    return PageView.builder(
      itemBuilder: (context, index) {
        return CurrentState.screens[index];
      },
      controller: controller,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: CurrentState.screens.length,
      onPageChanged: (val) {
        if (val == 4) {
          showChatList = false;
        } else {
          showChatList = true;
        }
        setState(() {});
      },
    );
  }
}
