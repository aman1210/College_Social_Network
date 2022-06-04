import 'package:cached_network_image/cached_network_image.dart';

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

  bool viewProfile = false;

  bool showRequest = false;

  List<String> url = [
    "https://www.theladders.com/wp-content/uploads/coder_190517-800x450.jpg",
    "https://d2jyir0m79gs60.cloudfront.net/news/images/successful-college-student-lg.png",
    "https://skillroads.com/images/blog//college_student.jpeg",
    "https://assets.new.siemens.com/siemens/assets/api/uuid:3ab33ae4-1260-44b7-95e0-3b05515ccebb/width:1125/quality:high/engineer-siemens.jpg",
    "https://www.ziprecruiter.com/svc/fotomat/public-ziprecruiter/uploads/job_description_template/Principal_Software_Engineer.jpg",
    "https://www.industry.gov.au/sites/default/files/styles/space_career/public/March%202021/image/space-profile-eloise-matheson.png",
    "https://cdn.mos.cms.futurecdn.net/Po8boBSzfQifAxkbgftCLV.jpg",
    "https://ece.mst.edu/media/academic/ece/images/homepage/Ryan-Vasquez-lead.jpg",
    "https://images.pexels.com/photos/1704488/pexels-photo-1704488.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"
  ];

  List<String> names = [
    "Ayush Gupta",
    "Mayank Pratap Singh",
    "Khushboo Arora",
    "Shivam Sharma",
    "Pratap Singh",
    "Amrisha Pandey",
    "Vijay Gupta",
    "Ratnesh Verma",
    "Aman Kumar Gupta"
  ];

  @override
  Widget build(BuildContext context) {
    var isMobile = Responsive.isMobile(context);
    var istablet = Responsive.isTablet(context);
    return viewProfile
        ? ProfileScreen()
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
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    TextButton(onPressed: () {}, child: Text("Show Requests"))
                  ]),
                  SizedBox(height: kDefaultPadding / 2),
                  Expanded(
                    child: GridView.builder(
                      controller: _controller,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                              borderRadius:
                                  BorderRadius.circular(kDefaultPadding / 4)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft:
                                          Radius.circular(kDefaultPadding / 4),
                                      topRight:
                                          Radius.circular(kDefaultPadding / 4)),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: CachedNetworkImage(
                                      imageUrl: url[user % 9],
                                      fit: BoxFit.cover,
                                      placeholder: (context, progress) =>
                                          SpinKitCubeGrid(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: kDefaultPadding / 4),
                                child: Text(
                                  "${names[user % 9]}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                ),
                              ),
                              // Padding(
                              //   padding:
                              //       const EdgeInsets.only(left: kDefaultPadding / 4),
                              //   child: Text(
                              //     "About $user",
                              //     style: TextStyle(
                              //         height: 1,
                              //         fontWeight: FontWeight.w300,
                              //         fontSize: 12,
                              //         color: Colors.black.withOpacity(0.7)),
                              //   ),
                              // ),
                              Padding(
                                padding:
                                    const EdgeInsets.all(kDefaultPadding / 4),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            viewProfile = true;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      kDefaultPadding / 4)),
                                          child: const Text(
                                            "View",
                                            style:
                                                TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center,
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
                                                      kDefaultPadding / 4)),
                                          child: Text(
                                            "Delete",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            textAlign: TextAlign.center,
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
                      itemCount: 50,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
