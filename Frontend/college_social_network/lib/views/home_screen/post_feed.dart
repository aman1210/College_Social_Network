import 'dart:async';
import 'dart:math' as math;

import 'package:ConnectUs/models/eventModel.dart';
import 'package:ConnectUs/models/postModel.dart';
import 'package:ConnectUs/view_models/post_view_model.dart';
import 'package:ConnectUs/views/home_screen/new_post.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../responsive.dart';
import '../../utils/constants.dart';
import 'package:flutter/material.dart';

import 'post_card.dart';

class PostFeed extends StatefulWidget {
  PostFeed({Key? key}) : super(key: key);

  @override
  State<PostFeed> createState() => _PostFeedState();
}

class _PostFeedState extends State<PostFeed> {
  final ScrollController _scrollController = ScrollController();

  final ScrollController _cardController = ScrollController();
  List<Post> posts = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    Provider.of<PostViewModel>(context, listen: false)
        .getAllPosts()
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void didUpdateWidget(covariant PostFeed oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var isMobile = Responsive.isMobile(context);
    var istablet = Responsive.isTablet(context);
    posts = Provider.of<PostViewModel>(context).posts;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.only(
          top: isMobile ? kDefaultPadding / 2 : kDefaultPadding),
      decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white10
              : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                  isMobile ? kDefaultPadding : kDefaultPadding * 1.5),
              topRight: Radius.circular(
                  isMobile ? kDefaultPadding : kDefaultPadding * 1.5))),
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.separated(
                        clipBehavior: Clip.hardEdge,
                        scrollDirection: Axis.vertical,
                        controller: _scrollController,
                        itemBuilder: (context, index) => index == 0
                            ? NewPost(isMobile: isMobile)
                            : PostCard(
                                index: index - 1, post: posts[index - 1]),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: kDefaultPadding),
                        itemCount: posts.length + 1,
                      )),
          ),
          if (!isMobile && !istablet)
            Expanded(
              flex: 5,
              child: ListView(
                controller: _cardController,
                children: const [
                  RecentEventCard(),
                  SizedBox(height: kDefaultPadding),
                  // BirthdayCard(),
                ],
              ),
            )
        ],
      ),
    );
  }
}

class BirthdayCard extends StatelessWidget {
  const BirthdayCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: kDefaultPadding),
      padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding / 1.5, vertical: kDefaultPadding / 2),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).scaffoldBackgroundColor
            : Colors.white,
        borderRadius: BorderRadius.circular(kDefaultPadding),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.03)
                : Colors.black.withOpacity(0.07),
            blurRadius: kDefaultPadding,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black12, width: 2),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Birthdays",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade700),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "See All",
                    style: TextStyle(fontSize: 12),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(kDefaultPadding / 2),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.blueGrey.withOpacity(0.2)
                            : Colors.grey.shade100,
                        borderRadius:
                            BorderRadius.circular(kDefaultPadding / 4),
                      ),
                      child: const Icon(Icons.person),
                    ),
                    const SizedBox(width: kDefaultPadding / 2),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Person Name",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey.shade700,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Birthday today",
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade500),
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(height: kDefaultPadding / 2),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding / 2,
                            vertical: kDefaultPadding / 3),
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.blueGrey.withOpacity(0.2)
                                    : Colors.blueGrey.shade100,
                            borderRadius:
                                BorderRadius.circular(kDefaultPadding / 4)),
                        child: TextFormField(
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.blueGrey.withOpacity(0.2)
                                  : null),
                          decoration: const InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: "Write on their inbox",
                            hintStyle: TextStyle(
                              fontSize: 12,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: kDefaultPadding / 4),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.blueGrey.withOpacity(0.2)
                            : Colors.blue.shade100,
                        borderRadius:
                            BorderRadius.circular(kDefaultPadding / 4),
                      ),
                      child: Icon(
                        Icons.send_outlined,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.blue.shade700
                            : Colors.blue,
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class RecentEventCard extends StatefulWidget {
  const RecentEventCard({
    Key? key,
  }) : super(key: key);

  @override
  State<RecentEventCard> createState() => _RecentEventCardState();
}

class _RecentEventCardState extends State<RecentEventCard> {
  bool isLoading = false;
  List<Event> upcomingEvents = [];
  List<Color> color = [Colors.green, Colors.blue, Colors.purple, Colors.brown];

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    Provider.of<PostViewModel>(context, listen: false)
        .getAllEvents()
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void didUpdateWidget(covariant RecentEventCard oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    upcomingEvents = Provider.of<PostViewModel>(context).events;
    return Container(
      margin: const EdgeInsets.only(
          right: kDefaultPadding, top: kDefaultPadding * 0.2),
      padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding / 1.5, vertical: kDefaultPadding / 2),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).scaffoldBackgroundColor
            : Colors.white,
        borderRadius: BorderRadius.circular(kDefaultPadding),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.03)
                : Colors.black.withOpacity(0.07),
            blurRadius: kDefaultPadding,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black12, width: 2),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Event",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade700),
                ),
              ],
            ),
          ),
          const SizedBox(height: kDefaultPadding / 2),
          if (isLoading) CircularProgressIndicator(),
          if (!isLoading && upcomingEvents.length == 0)
            Text("No upcoming events for next 3 days!"),
          if (!isLoading && upcomingEvents.length > 0)
            ...upcomingEvents
                .map((e) => EventListItem(
                      color: color[math.Random().nextInt(4)],
                      icon: Icons.calendar_month,
                      event: e,
                    ))
                .toList()
        ],
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }
}

class EventListItem extends StatelessWidget {
  const EventListItem({
    Key? key,
    required this.color,
    required this.event,
    required this.icon,
  }) : super(key: key);

  final Color color;
  final Event event;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: kDefaultPadding / 2, horizontal: kDefaultPadding / 4),
      padding: const EdgeInsets.all(kDefaultPadding / 2),
      decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.blueGrey.withOpacity(0.2)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(kDefaultPadding / 2)),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(kDefaultPadding / 4)),
                child: Icon(
                  Icons.calendar_month,
                  color: color,
                ),
              ),
              const SizedBox(width: kDefaultPadding / 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.blueGrey.shade300
                              : Colors.blueGrey.shade700,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: kDefaultPadding / 5),
                    Text(
                      event.detail,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : null,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const Divider(),
          Row(
            children: [
              Text(
                DateFormat('EE, d/MM/yy')
                    .add_jm()
                    .format(event.time!.toLocal()),
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white30
                      : null,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
