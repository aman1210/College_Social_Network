import 'package:college_social_network/views/home_screen/post_feed.dart';
import 'package:college_social_network/views/message_screen/message_screen.dart';
import 'package:college_social_network/views/my_community_screen/my_community_screen.dart';
import 'package:college_social_network/views/notification_screen/notification_screen.dart';
import 'package:flutter/material.dart';

import '../views/profile_screen/profile_screen.dart';

class CurrentState extends ChangeNotifier {
  static int selectedIndex = 0;

  static List<List<dynamic>> tabs = [
    ['Feed', Icons.grid_view_outlined],
    ['My Community', Icons.people_alt_outlined],
    ['Messages', Icons.message_outlined],
    ['Notification', Icons.notifications_outlined],
    ['Profile', Icons.person_outline_rounded],
    ['Toggle Dark Mode', Icons.dark_mode_outlined],
    ['Logout', Icons.logout_rounded],
  ];

  static var screens = [
    PostFeed(),
    MyCommunityScreen(),
    MessageScreen(),
    NotificationScreen(),
    ProfileScreen(),
    // const Center(child: Text("6")),
    const Center(child: Text("7")),
  ];

  static PageController pageController = PageController(initialPage: 0);
}
