import 'package:ConnectUs/view_models/chat_view_model.dart';
import 'package:scoped_model/scoped_model.dart';

import '/components/app_bar.dart';
import '/components/current_state.dart';
import '/components/side_bar.dart';
import '/responsive.dart';
import '/view_models/auth_view_model.dart';
import '/views/auth_screen/auth_screen.dart';
import '/views/home_screen/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool showChatList = true;

  late List<Widget> pageViews;
  late List<Widget> visiblePageViews;

  void animateToOne() {
    CurrentState.pageController.animateToPage(
      0,
      curve: Curves.easeIn,
      duration: const Duration(seconds: 1),
    );
  }

  void jumpAnimateEight() async {
    CurrentState.pageController.jumpToPage(6);
    await CurrentState.pageController.animateToPage(
      7,
      curve: Curves.easeIn,
      duration: const Duration(seconds: 1),
    );
  }

  void refreshChildren(Duration duration) {
    setState(() {
      visiblePageViews = createPageContents();
    });
  }

  Future<void> swapChildren(int pageCurrent, int pageTarget) async {
    List<Widget> newVisiblePageViews = [];
    newVisiblePageViews.addAll(pageViews);

    if (pageTarget > pageCurrent) {
      newVisiblePageViews[pageCurrent + 1] = visiblePageViews[pageTarget];
    } else if (pageTarget < pageCurrent) {
      newVisiblePageViews[pageCurrent - 1] = visiblePageViews[pageTarget];
    }

    // print(newVisiblePageViews);
    // print(visiblePageViews);

    setState(() {
      visiblePageViews = newVisiblePageViews;
    });
  }

  Future quickJump(int pageCurrent, int pageTarget) async {
    int quickJumpTarget = -1;

    if (pageTarget > pageCurrent) {
      quickJumpTarget = pageCurrent + 1;
    } else if (pageTarget < pageCurrent) {
      quickJumpTarget = pageCurrent - 1;
    }
    if (quickJumpTarget != -1) {
      await CurrentState.pageController.animateToPage(
        quickJumpTarget,
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 500),
      );
      CurrentState.pageController.jumpToPage(pageTarget);
    }
  }

  void flashToEight(int newpageTarget) async {
    int pageCurrent = CurrentState.pageController.page!.round();
    int pageTarget = newpageTarget;
    // print("$pageCurrent  $pageTarget");
    if (pageCurrent == pageTarget) {
      return;
    }
    await swapChildren(pageCurrent, pageTarget);
    await quickJump(pageCurrent, pageTarget);
    WidgetsBinding.instance.addPostFrameCallback(refreshChildren);
  }

  List<Widget> createPageContents() {
    return CurrentState.screens;
  }

  @override
  void initState() {
    pageViews = createPageContents();
    visiblePageViews = createPageContents();
    super.initState();
  }

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
        drawer: SideBar(function: flashToEight),
        body: Column(
          children: [
            CustomAppBar(scrollPageView: flashToEight),
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
            Expanded(
                flex: 3,
                child: ChatList(
                  scrollPageView: flashToEight,
                )),
          ],
        ),
        desktop: Row(
          children: [
            Expanded(
                flex: 2,
                child: SideBar(
                  function: flashToEight,
                )),
            Expanded(
              flex: 6,
              child: mainarea(pageController),
            ),
            Expanded(
              flex: 2,
              child: ChatList(scrollPageView: flashToEight),
            ),
          ],
        ),
      ),
    );
  }

  PageView mainarea(PageController controller) {
    return PageView.builder(
      itemBuilder: (context, index) {
        return visiblePageViews[index];
      },
      controller: controller,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: visiblePageViews.length,
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
