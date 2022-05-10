import 'package:college_social_network/components/app_bar.dart';
import 'package:college_social_network/utils/constants.dart';
import 'package:college_social_network/views/admin_screen.dart/post_verification_tab.dart';
import 'package:college_social_network/views/admin_screen.dart/reports_tab.dart';
import 'package:college_social_network/views/admin_screen.dart/user_verification_tab.dart';
import 'package:flutter/material.dart';

import '../../utils/images.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(isAdmin: true),
          TabBar(
            // overlayColor: MaterialStateProperty.all(Colors.grey),
            indicator: BoxDecoration(
              color: Colors.blue.withOpacity(0.07),
              border: Border(
                bottom: BorderSide(color: Colors.blue, width: 2),
              ),
            ),
            indicatorColor: Colors.red,
            labelStyle: const TextStyle(
              fontSize: 16,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
            labelColor: Colors.black,

            tabs: const [
              Tab(child: Text("User Verification")),
              Tab(child: Text("Post Verification")),
              Tab(child: Text("Reports")),
            ],
            unselectedLabelColor: Colors.grey,
            controller: _tabController,
          ),
          Expanded(
            child: TabBarView(
              children: [
                UsersVerification(),
                PostsVerification(),
                ReportsVerification(),
              ],
              controller: _tabController,
            ),
          )
        ],
      ),
    );
  }
}
