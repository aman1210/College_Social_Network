import 'package:college_social_network/responsive.dart';
import 'package:college_social_network/utils/constants.dart';
import 'package:flutter/material.dart';

import 'post_card.dart';

class PostFeed extends StatelessWidget {
  PostFeed({Key? key}) : super(key: key);

  final ScrollController _scrollController = ScrollController();
  final ScrollController _cardController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var isMobile = Responsive.isMobile(context);
    var istablet = Responsive.isTablet(context);
    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.only(
          top: isMobile ? kDefaultPadding / 2 : kDefaultPadding),
      decoration: BoxDecoration(
          color: Colors.grey.shade200,
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
              child: ListView.separated(
                clipBehavior: Clip.hardEdge,
                scrollDirection: Axis.vertical,
                controller: _scrollController,
                itemBuilder: (context, index) => index == 0
                    ? NewPost(isMobile: isMobile)
                    : PostCard(
                        index: index - 1,
                      ),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: kDefaultPadding),
                itemCount: 10 + 1,
              ),
            ),
          ),
          if (!isMobile && !istablet)
            Expanded(
              flex: 5,
              child: ListView(
                controller: _cardController,
                children: const [
                  RecentEventCard(),
                  SizedBox(height: kDefaultPadding),
                  BirthdayCard(),
                ],
              ),
            )
        ],
      ),
    );
  }
}

class NewPost extends StatelessWidget {
  const NewPost({
    Key? key,
    required this.isMobile,
  }) : super(key: key);

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: isMobile ? kDefaultPadding / 2 : kDefaultPadding),
      padding: EdgeInsets.symmetric(
          vertical: kDefaultPadding / 2,
          horizontal: isMobile ? kDefaultPadding / 2 : kDefaultPadding),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kDefaultPadding),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(0.07),
              offset: const Offset(0, 5),
            )
          ]),
      child: Column(children: [
        Row(
          children: [
            const CircleAvatar(
              child: Icon(Icons.person),
            ),
            const SizedBox(width: kDefaultPadding / 2),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                  left: kDefaultPadding / 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(kDefaultPadding / 2),
                ),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: "What's happening?",
                    hintStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1),
                    border: InputBorder.none,
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: kDefaultPadding / 2),
        Row(
          children: [
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.emoji_emotions_outlined),
              label: const Text("Feeling"),
            ),
            const SizedBox(height: kDefaultPadding / 4),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.photo_outlined),
              label: const Text("Photo"),
            ),
            const Expanded(child: SizedBox()),
            ElevatedButton(onPressed: () {}, child: const Text("Post"))
          ],
        ),
      ]),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(kDefaultPadding),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
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
                    bottom: BorderSide(color: Colors.black12, width: 2))),
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
                        color: Colors.grey.shade100,
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
                            color: Colors.blueGrey.shade100,
                            borderRadius:
                                BorderRadius.circular(kDefaultPadding / 4)),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 12),
                          decoration: const InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: "Write on their inbox",
                              hintStyle: TextStyle(fontSize: 12, height: 1)),
                        ),
                      ),
                    ),
                    const SizedBox(width: kDefaultPadding / 4),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius:
                            BorderRadius.circular(kDefaultPadding / 4),
                      ),
                      child: const Icon(
                        Icons.send_outlined,
                        color: Colors.blue,
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

class RecentEventCard extends StatelessWidget {
  const RecentEventCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          right: kDefaultPadding, top: kDefaultPadding * 0.2),
      padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding / 1.5, vertical: kDefaultPadding / 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kDefaultPadding),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
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
                    bottom: BorderSide(color: Colors.black12, width: 2))),
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
          const SizedBox(height: kDefaultPadding / 2),
          const EventListItem(
            color: Colors.green,
            icon: Icons.menu_book_rounded,
            content: "The graduation ceremony is somtimes also called",
            title: "Graduation Ceremony",
          ),
          const EventListItem(
            color: Colors.red,
            icon: Icons.camera_alt_outlined,
            content: "Reflections. Reflections work because they can create",
            title: "Photography Ideas",
          ),
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
    required this.content,
    required this.icon,
    required this.title,
  }) : super(key: key);

  final Color color;
  final String title;
  final String content;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: kDefaultPadding / 2, horizontal: kDefaultPadding / 4),
      padding: const EdgeInsets.all(kDefaultPadding / 2),
      decoration: BoxDecoration(
          color: Colors.grey.shade100,
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
                  Icons.headphones,
                  color: color,
                ),
              ),
              const SizedBox(width: kDefaultPadding / 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.blueGrey.shade700,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: kDefaultPadding / 5),
                    Text(
                      content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              )
            ],
          ),
          const Divider(),
          Row(
            children: const [
              Text(
                "8 seen",
                style: TextStyle(fontSize: 12),
              )
            ],
          )
        ],
      ),
    );
  }
}
