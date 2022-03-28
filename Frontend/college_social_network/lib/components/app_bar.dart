import 'package:college_social_network/responsive.dart';
import 'package:college_social_network/utils/constants.dart';
import 'package:college_social_network/utils/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isMobile = Responsive.isMobile(context);
    var isTablet = Responsive.isTablet(context);
    return Container(
      height: isMobile ? 60 : 70,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(children: [
        if (isMobile)
          IconButton(
            splashRadius: 25,
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.menu),
          ),
        if (!isMobile) AppLogo(),
        const Expanded(flex: 1, child: SizedBox()),
        if (!isTablet && !isMobile)
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              child: TextFormField(
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kDefaultPadding / 2),
                    borderSide: BorderSide(
                      color: Colors.black12,
                    ),
                  ),
                  hintText: "Search for something here...",
                  hintStyle: TextStyle(fontSize: 14),
                  prefixIcon: Icon(
                    CupertinoIcons.search,
                    size: 15,
                  ),
                ),
              ),
            ),
          ),
        const Expanded(flex: 4, child: SizedBox()),
        Container(
          child: Row(
            children: [
              Text(
                "User Name",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.blueGrey.shade700),
              ),
              SizedBox(width: kDefaultPadding),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kDefaultPadding / 4),
                  color: Colors.blue.shade100,
                ),
                child: Icon(
                  CupertinoIcons.person,
                  color: Colors.blue,
                ),
              )
            ],
          ),
        )
      ]),
    );
  }
}

class AppLogo extends StatelessWidget {
  const AppLogo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Image.asset(Images.logo, height: 40),
          const SizedBox(width: 12),
          const Text(
            "ConnectUs",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
