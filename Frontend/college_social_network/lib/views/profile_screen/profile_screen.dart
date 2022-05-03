import 'package:college_social_network/responsive.dart';
import 'package:college_social_network/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_fade/image_fade.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    var isMobile = Responsive.isMobile(context);
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: isMobile ? kDefaultPadding / 2 : kDefaultPadding),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          controller: _controller,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileAndCoverPhotoCard(isMobile: isMobile),
              SizedBox(height: kDefaultPadding),
              Container(
                padding: EdgeInsets.all(kDefaultPadding),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                          color: Colors.blueGrey.shade700),
                    ),
                    SizedBox(height: kDefaultPadding / 5),
                    introField(Icons.web, "www.portfolio.com"),
                    introField(CupertinoIcons.person, "Male"),
                    introField(Icons.cake_outlined, "Born October 12, 1998"),
                    introField(Icons.map_rounded, "Varanasi, India"),
                    introField(Icons.facebook_outlined, "Facebook name"),
                    introField(Icons.facebook, "Instagram name"),
                    Divider(thickness: 1, height: kDefaultPadding * 2),
                    Text(
                      "About",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blueGrey.shade700),
                    ),
                    SizedBox(height: kDefaultPadding / 5),
                    Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                      style: TextStyle(fontSize: 14),
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

  Padding introField(IconData icon, String value) {
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
          style: TextStyle(color: Colors.blueGrey),
        ),
      ]),
    );
  }
}

class ProfileAndCoverPhotoCard extends StatelessWidget {
  const ProfileAndCoverPhotoCard({
    Key? key,
    required this.isMobile,
  }) : super(key: key);

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
                    child: ImageFade(
                      image: NetworkImage(
                        "https://images.pexels.com/photos/2662116/pexels-photo-2662116.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                      ),
                      placeholder: SpinKitWave(
                        color: Theme.of(context).primaryColor,
                      ),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )),
                Positioned(
                  right: kDefaultPadding / 2,
                  bottom: kDefaultPadding / 2,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.cloud_upload_outlined,
                      size: 18,
                    ),
                    label: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        "Edit Cover Photo",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      foregroundColor: MaterialStateProperty.all(
                          Colors.black.withOpacity(0.7)),
                    ),
                  ),
                ),
                Positioned(
                  left: kDefaultPadding,
                  bottom: -kDefaultPadding * 1.5,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        maxRadius: isMobile ? 40 : 60,
                        backgroundColor: Colors.blue,
                      ),
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
                      "Person Name",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.blueGrey.shade700,
                      ),
                    ),
                    Text(
                      "One liner about",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blueGrey.shade400,
                      ),
                    ),
                  ],
                ),
                Expanded(child: SizedBox()),
                TextButton.icon(
                  onPressed: () {},
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
