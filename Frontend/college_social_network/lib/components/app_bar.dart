import 'dart:html' as html;
import 'dart:ui';

import 'package:ConnectUs/components/custom_dialog.dart';
import 'package:ConnectUs/components/searchUserScreen.dart';
import 'package:ConnectUs/models/HttpExceptions.dart';
import 'package:ConnectUs/view_models/user_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../components/current_state.dart';
import '../../responsive.dart';
import '../../utils/constants.dart';
import '../../utils/images.dart';
import '../../view_models/auth_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({Key? key, this.isAdmin = false, this.scrollPageView})
      : super(key: key);
  final bool isAdmin;
  final Function? scrollPageView;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final TextEditingController _searchController = TextEditingController();

  String parameter = "name";
  bool isLoading = false;

  submitSearch() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Provider.of<UserViewModel>(context, listen: false)
          .searchFriendOnDB(parameter, _searchController.text);
      _searchController.clear();

      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const SearchResultScreen()));
    } on HttpExceptions catch (err) {
      showDialog(
          context: context,
          builder: (context) => CustomDialog(msg: err.toString()));
    } catch (err) {
      showDialog(
          context: context,
          builder: (context) => CustomDialog(msg: err.toString()));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var isMobile = Responsive.isMobile(context);
    var isTablet = Responsive.isTablet(context);
    AuthViewModel authViewModel = context.watch<AuthViewModel>();
    var provider = Provider.of<AuthViewModel>(context);
    return Container(
      height: isMobile ? 60 : 70,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Row(
        children: [
          if ((isMobile || isTablet) && authViewModel.userLoggedIn)
            IconButton(
              splashRadius: 25,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            ),
          if (!isMobile || !authViewModel.userLoggedIn)
            AppLogo(scrollPageView: widget.scrollPageView),
          const Expanded(flex: 1, child: SizedBox()),
          if (!isTablet &&
              !isMobile &&
              authViewModel.userLoggedIn &&
              !widget.isAdmin)
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                child: TextFormField(
                  style: const TextStyle(fontSize: 16),
                  controller: _searchController,
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kDefaultPadding / 2),
                      borderSide: const BorderSide(
                        color: Colors.black12,
                      ),
                    ),
                    hintText: "Search for someone here...",
                    suffix: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DropdownButton(
                          value: parameter,
                          items: const [
                            DropdownMenuItem(
                                child: Text("Name"), value: "name"),
                            DropdownMenuItem(
                                child: Text("Location"), value: "location"),
                          ],
                          underline: Container(),
                          onChanged: (value) {
                            setState(() {
                              parameter = value.toString();
                            });
                          },
                        ),
                        if (isLoading) const CircularProgressIndicator(),
                        if (!isLoading)
                          IconButton(
                            onPressed: () {
                              submitSearch();
                            },
                            icon: const Icon(
                              CupertinoIcons.search,
                              color: Colors.blue,
                            ),
                          ),
                      ],
                    ),
                    hintStyle: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
          const Expanded(flex: 4, child: SizedBox()),
          if (authViewModel.userLoggedIn && !widget.isAdmin)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(kDefaultPadding / 4)),
              child: Row(
                children: [
                  Text(
                    provider.userName,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.8)
                            : Colors.blueGrey.shade700),
                  ),
                  const SizedBox(width: kDefaultPadding / 2),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kDefaultPadding / 4),
                      color: Colors.blue.shade100,
                    ),
                    child: provider.profileImage == ''
                        ? const Icon(
                            CupertinoIcons.person,
                            color: Colors.blue,
                          )
                        : ClipRRect(
                            borderRadius:
                                BorderRadius.circular(kDefaultPadding / 4),
                            child: CachedNetworkImage(
                              imageUrl: provider.profileImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                  )
                ],
              ),
            ),
          if (authViewModel.userLoggedIn && widget.isAdmin)
            TextButton.icon(
                onPressed: () {
                  Provider.of<AuthViewModel>(context, listen: false).logout();
                  html.window.location.reload();
                },
                icon: const Icon(Icons.logout_rounded),
                label: const Text("Logout"))
        ],
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  const AppLogo({Key? key, this.scrollPageView}) : super(key: key);
  final Function? scrollPageView;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        CurrentState.selectedIndex = 0;
        if (scrollPageView != null) {
          scrollPageView!(0);
        }
      },
      child: Row(
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
      ),
    );
  }
}
