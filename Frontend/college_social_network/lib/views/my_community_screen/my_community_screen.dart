import 'package:ConnectUs/models/friendList.dart';
import 'package:ConnectUs/view_models/auth_view_model.dart';
import 'package:ConnectUs/view_models/user_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../../views/profile_screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_fade/image_fade.dart';

import '../../responsive.dart';
import '../../utils/constants.dart';

class MyCommunityScreen extends StatefulWidget {
  MyCommunityScreen({Key? key}) : super(key: key);

  @override
  State<MyCommunityScreen> createState() => _MyCommunityScreenState();
}

class _MyCommunityScreenState extends State<MyCommunityScreen> {
  ScrollController _controller = ScrollController();

  String? viewProfile;
  bool showRequest = false;

  bool isLoading = false;

  List<FriendListElement> friendList = [];
  List<FriendListElement> friendRequest = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    var id = Provider.of<AuthViewModel>(context, listen: false).userId;
    var token = Provider.of<AuthViewModel>(context, listen: false).token;
    Provider.of<UserViewModel>(context, listen: false)
        .getFriendList(id, token)
        .then((value) => {
              setState(() {
                isLoading = false;
              })
            });
  }

  getFriendRequest() {
    setState(() {
      isLoading = true;
    });
    var id = Provider.of<AuthViewModel>(context, listen: false).userId;
    var token = Provider.of<AuthViewModel>(context, listen: false).token;
    Provider.of<UserViewModel>(context, listen: false)
        .getFriendList(id, token)
        .then((value) => {
              setState(() {
                isLoading = false;
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    var isMobile = Responsive.isMobile(context);
    var istablet = Responsive.isTablet(context);
    friendList = Provider.of<UserViewModel>(context).friendList;
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : viewProfile != null
            ? ProfileScreen(
                id: viewProfile,
              )
            : Container(
                width: double.infinity,
                clipBehavior: Clip.hardEdge,
                padding: const EdgeInsets.only(
                    top: kDefaultPadding,
                    left: kDefaultPadding,
                    right: kDefaultPadding),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white10
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                        isMobile ? kDefaultPadding : kDefaultPadding * 1.5),
                    topRight: Radius.circular(
                        isMobile ? kDefaultPadding : kDefaultPadding * 1.5),
                  ),
                ),
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: Column(
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        TextButton(
                            onPressed: () {
                              setState(() {
                                showRequest = !showRequest;
                              });
                            },
                            child: Text("Show Requests"))
                      ]),
                      SizedBox(height: kDefaultPadding / 2),
                      Expanded(
                        child: friendList.length == 0
                            ? Center(
                                child: Text(
                                    "Please add new friends to show here!"),
                              )
                            : GridView.builder(
                                controller: _controller,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: isMobile
                                            ? 2
                                            : istablet
                                                ? 3
                                                : 4,
                                        mainAxisSpacing: kDefaultPadding,
                                        crossAxisSpacing: kDefaultPadding,
                                        childAspectRatio: 3 / 4),
                                itemBuilder: (context, user) {
                                  return Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.blueGrey.withOpacity(0.3)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            kDefaultPadding / 4)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft: Radius.circular(
                                                        kDefaultPadding / 4),
                                                    topRight: Radius.circular(
                                                        kDefaultPadding / 4)),
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: CachedNetworkImage(
                                                imageUrl: friendList[user]
                                                    .profileImage!,
                                                fit: BoxFit.cover,
                                                placeholder:
                                                    (context, progress) =>
                                                        SpinKitCubeGrid(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: kDefaultPadding / 4),
                                          child: Text(
                                            friendList[user].name!,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(
                                              kDefaultPadding / 4),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      viewProfile =
                                                          friendList[user].id;
                                                    });
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                kDefaultPadding /
                                                                    4)),
                                                    child: const Text(
                                                      "View",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {},
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                                    .brightness ==
                                                                Brightness.dark
                                                            ? Colors.white10
                                                            : Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                kDefaultPadding /
                                                                    4)),
                                                    child: Text(
                                                      "Delete",
                                                      style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                itemCount: friendList.length,
                              ),
                      ),
                    ],
                  ),
                ),
              );
  }
}
