import 'package:college_social_network/responsive.dart';
import 'package:college_social_network/utils/constants.dart';
import 'package:college_social_network/utils/images.dart';
import 'package:college_social_network/view_models/auth_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isMobile = Responsive.isMobile(context);
    var isTablet = Responsive.isTablet(context);
    AuthViewModel authViewModel = context.watch<AuthViewModel>();
    return Container(
      height: isMobile ? 60 : 70,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Row(children: [
        if ((isMobile || isTablet) && authViewModel.userLoggedIn)
          IconButton(
            splashRadius: 25,
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.menu),
          ),
        if (!isMobile || !authViewModel.userLoggedIn) const AppLogo(),
        const Expanded(flex: 1, child: SizedBox()),
        if (!isTablet && !isMobile && authViewModel.userLoggedIn)
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              child: TextFormField(
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kDefaultPadding / 2),
                    borderSide: const BorderSide(
                      color: Colors.black12,
                    ),
                  ),
                  hintText: "Search for something here...",
                  hintStyle: const TextStyle(fontSize: 14),
                  prefixIcon: const Icon(
                    CupertinoIcons.search,
                    size: 15,
                  ),
                ),
              ),
            ),
          ),
        const Expanded(flex: 4, child: SizedBox()),
        if (authViewModel.userLoggedIn)
          Row(
            children: [
              Text(
                "User Name",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.blueGrey.shade700),
              ),
              const SizedBox(width: kDefaultPadding),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kDefaultPadding / 4),
                  color: Colors.blue.shade100,
                ),
                child: const Icon(
                  CupertinoIcons.person,
                  color: Colors.blue,
                ),
              )
            ],
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
    return Row(
      children: [
        Image.asset(Images.logo, height: 40),
        const SizedBox(width: 12),
        Text(
          "ConnectUs",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black87
                : Colors.white,
          ),
        ),
      ],
    );
  }
}
