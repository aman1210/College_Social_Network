import 'package:college_social_network/utils/constants.dart';
import 'package:flutter/material.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);
  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  final List<List<dynamic>> tabs = [
    ['Feed', Icons.grid_view_outlined],
    ['My Community', Icons.people_alt_outlined],
    ['Messages', Icons.message_outlined],
    ['Notification', Icons.notifications_outlined],
    ['Profile', Icons.person_outline_rounded],
    ['Settings', Icons.settings_outlined],
    ['Logout', Icons.logout_rounded],
  ];

  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: kDefaultPadding, horizontal: kDefaultPadding / 2),
      child: ListView.builder(
        itemBuilder: (context, index) => InkWell(
          borderRadius: BorderRadius.circular(kDefaultPadding / 5),
          onTap: () {
            setState(() {
              selected = index;
            });
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
                    tabs[index][1],
                    color: selected != index
                        ? Colors.blueGrey.shade600
                        : Colors.white,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    tabs[index][0],
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
        itemCount: tabs.length,
      ),
    );
  }
}
