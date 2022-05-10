import 'package:college_social_network/components/app_bar.dart';
import 'package:college_social_network/components/current_state.dart';
import 'package:college_social_network/responsive.dart';
import 'package:college_social_network/utils/constants.dart';
import 'package:college_social_network/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideBar extends StatefulWidget {
  SideBar({Key? key, required this.function}) : super(key: key);
  Function function;

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    AuthViewModel authViewModel = context.watch<AuthViewModel>();
    var isMobile = Responsive.isMobile(context);
    selected = CurrentState.selectedIndex;
    return Container(
      color: Colors.white,
      constraints: const BoxConstraints(maxWidth: 300),
      padding: const EdgeInsets.symmetric(
          vertical: kDefaultPadding, horizontal: kDefaultPadding),
      child: Column(
        children: [
          if (isMobile)
            AppLogo(
              scrollPageView: widget.function,
            ),
          if (isMobile) const SizedBox(height: kDefaultPadding),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => InkWell(
                borderRadius: BorderRadius.circular(kDefaultPadding / 2),
                onTap: () {
                  if (index == CurrentState.tabs.length - 1) {
                    authViewModel.logout();
                  } else {
                    CurrentState.selectedIndex = index;
                    // CurrentState.pageController.animateToPage(index,
                    //     duration: const Duration(milliseconds: 750),
                    //     curve: Curves.decelerate);
                    widget.function(index);
                    // CurrentState.pageController.jumpToPage(index);
                    setState(() {
                      selected = index;
                    });
                    if (isMobile) Navigator.pop(context);
                  }
                },
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(
                      bottom: kDefaultPadding / 4,
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: kDefaultPadding / 1.5,
                        horizontal: kDefaultPadding / 2),
                    decoration: BoxDecoration(
                        color: selected == index
                            ? Colors.blueGrey.shade600
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Icon(
                          CurrentState.tabs[index][1],
                          color: selected != index
                              ? Colors.blueGrey.shade600
                              : Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          CurrentState.tabs[index][0],
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: selected != index
                                  ? Colors.blueGrey.shade600
                                  : Colors.white),
                        ),
                      ],
                    )),
              ),
              itemCount: CurrentState.tabs.length,
            ),
          ),
        ],
      ),
    );
  }
}
