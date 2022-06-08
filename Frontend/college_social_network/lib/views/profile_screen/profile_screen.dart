import 'package:ConnectUs/models/user.dart';
import 'package:ConnectUs/view_models/auth_view_model.dart';
import 'package:ConnectUs/view_models/user_view_model.dart';
import 'package:ConnectUs/views/profile_screen/edit_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../../responsive.dart';
import '../../utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_fade/image_fade.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key, this.id}) : super(key: key);

  final String? id;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ScrollController _controller = ScrollController();
  User? userProfile;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    var id = Provider.of<AuthViewModel>(context, listen: false).userId;
    var token = Provider.of<AuthViewModel>(context, listen: false).token;

    Provider.of<UserViewModel>(context, listen: false)
        .getProfile(widget.id ?? id, token)
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var isMobile = Responsive.isMobile(context);
    userProfile = Provider.of<UserViewModel>(context).user;
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            margin: EdgeInsets.symmetric(
                horizontal: isMobile ? kDefaultPadding / 2 : kDefaultPadding),
            child: ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                controller: _controller,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileAndCoverPhotoCard(
                        isMobile: isMobile, user: userProfile!),
                    SizedBox(height: kDefaultPadding),
                    Container(
                      padding: EdgeInsets.all(kDefaultPadding),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.blueGrey.withOpacity(0.2)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(kDefaultPadding),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 20,
                            color: Colors.black.withOpacity(0.07),
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Intro",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white70
                                    : Colors.blueGrey.shade700),
                          ),
                          SizedBox(height: kDefaultPadding / 5),
                          introField(
                              Icons.cake_outlined,
                              "Born ${userProfile!.dob ?? 'Not entered'}",
                              context),
                          introField(
                              Icons.map_rounded,
                              userProfile!.location ?? "Not specified",
                              context),
                          if (userProfile!.socialLinks != null)
                            ...userProfile!.socialLinks!
                                .map(
                                  (e) => introField(
                                      Icons.south_america_rounded,
                                      userProfile!.location ?? "Not specified",
                                      context),
                                )
                                .toList(),
                          Divider(thickness: 1, height: kDefaultPadding * 2),
                          Text(
                            "About",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white70
                                    : Colors.blueGrey.shade700),
                          ),
                          SizedBox(height: kDefaultPadding / 5),
                          Text(
                            userProfile!.about ?? "'About' not specified",
                            style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white.withOpacity(0.65)
                                    : null),
                          ),
                          Divider(thickness: 1, height: kDefaultPadding * 2),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }

  Padding introField(IconData icon, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(children: [
        Icon(
          icon,
          color: Colors.blueGrey,
          size: 20,
        ),
        SizedBox(width: kDefaultPadding / 2),
        Text(
          value,
          style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.blueGrey),
        ),
      ]),
    );
  }
}

class ProfileAndCoverPhotoCard extends StatelessWidget {
  const ProfileAndCoverPhotoCard({
    Key? key,
    required this.isMobile,
    required this.user,
  }) : super(key: key);

  final bool isMobile;
  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.blueGrey.withOpacity(0.2)
            : Colors.white,
        borderRadius: BorderRadius.circular(kDefaultPadding),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 250),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(kDefaultPadding),
                      topRight: Radius.circular(kDefaultPadding)),
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://images.pexels.com/photos/2662116/pexels-photo-2662116.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder: (context, progress) => SpinKitWave(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Positioned(
                  left: kDefaultPadding,
                  bottom: -kDefaultPadding * 1.5,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      if (user.profileImage != null)
                        CircleAvatar(
                            maxRadius: isMobile ? 40 : 60,
                            backgroundColor: Colors.blue,
                            backgroundImage:
                                CachedNetworkImageProvider(user.profileImage!)),
                      Positioned(
                        bottom: 15,
                        right: isMobile ? -10 : 0,
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 20,
                                  color: Colors.black.withOpacity(0.2),
                                  offset: const Offset(0, 5),
                                )
                              ],
                            ),
                            child: Icon(
                              Icons.cloud_upload_outlined,
                              size: 20,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : null,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                top: kDefaultPadding * 2,
                left: isMobile ? kDefaultPadding / 2 : kDefaultPadding,
                right: isMobile ? kDefaultPadding / 2 : kDefaultPadding,
                bottom: kDefaultPadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(kDefaultPadding),
                bottomRight: Radius.circular(kDefaultPadding),
              ),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name ?? "AMan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.blueGrey.shade700,
                      ),
                    ),
                    Text(
                      user.intro ?? "",
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.blueGrey.shade400,
                      ),
                    ),
                  ],
                ),
                Expanded(child: SizedBox()),
                TextButton.icon(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => EditProfieForm());
                  },
                  icon: const Icon(
                    Icons.cloud_upload_outlined,
                    size: 18,
                  ),
                  label: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      "Edit Basic Info",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
