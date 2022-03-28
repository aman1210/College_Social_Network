import 'package:college_social_network/components/current_state.dart';
import 'package:college_social_network/utils/constants.dart';
import 'package:college_social_network/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    AuthViewModel authViewModel = context.watch<AuthViewModel>();
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: kDefaultPadding, horizontal: kDefaultPadding),
      child: ListView.builder(
        itemBuilder: (context, index) => InkWell(
          borderRadius: BorderRadius.circular(kDefaultPadding / 2),
          onTap: () {
            if (index == CurrentState.tabs.length - 1) {
              authViewModel.logout();
            } else {
              CurrentState.selectedIndex = index;
              CurrentState.pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 750),
                  curve: Curves.decelerate);
              setState(() {
                selected = index;
              });
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
    );
  }
}
