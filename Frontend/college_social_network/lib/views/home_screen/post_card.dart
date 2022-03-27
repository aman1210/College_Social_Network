import 'package:carousel_slider/carousel_slider.dart';
import 'package:college_social_network/utils/constants.dart';
import 'package:college_social_network/utils/images.dart';
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  PostCard({
    Key? key,
  }) : super(key: key);

  List<String> images = [
    Images.img1,
    Images.img2,
    Images.img3,
    Images.img4,
    Images.img5,
  ];

  CarouselController buttonCarouselController = CarouselController();

  final String lp =
      "Lorem ipsum dolor sit amet. Ut error rerum ut dolorem velit et iusto nulla qui nihil itaque qui facilis distinctio. Ut accusamus quisquam eos distinctio odit et labore provident aut odit molestiae hic fuga nulla. Et distinctio iure At accusantium quas sed placeat vero ut tempore necessitatibus et cu";
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      padding: const EdgeInsets.symmetric(
          vertical: kDefaultPadding / 2, horizontal: kDefaultPadding),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kDefaultPadding / 2),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(0.07),
              offset: const Offset(0, 5),
            )
          ]),
      child: Column(
        children: [
          const PostHead(),
          if (lp != null)
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
              child: Text(lp),
            ),
          PostImages(
              buttonCarouselController: buttonCarouselController,
              images: images),
          PostStats(),
          PostButtons(),
          Container(
            padding: const EdgeInsets.only(top: kDefaultPadding / 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.lightBlue,
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding / 2),
                    padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding / 2),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade50,
                      borderRadius: BorderRadius.circular(
                        kDefaultPadding / 2,
                      ),
                    ),
                    child: TextFormField(
                      maxLines: 5,
                      minLines: 1,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Write a comment..",
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.gif_box_outlined,
                              color: Colors.blueGrey.shade500,
                            ),
                            SizedBox(width: kDefaultPadding / 4),
                            Icon(
                              Icons.image_outlined,
                              color: Colors.blueGrey.shade500,
                            ),
                            SizedBox(width: kDefaultPadding / 4),
                            Icon(
                              Icons.emoji_emotions_outlined,
                              color: Colors.blueGrey.shade500,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kDefaultPadding / 4),
                    color: Colors.blue.withOpacity(0.1),
                  ),
                  child: Icon(
                    Icons.send,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class PostButtons extends StatelessWidget {
  const PostButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.grey.shade300, width: 2),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.favorite_border_rounded),
            label: Text("Like"),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.mode_comment_outlined),
            label: Text("Comment"),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.share_outlined),
            label: Text("Share"),
          ),
        ],
      ),
    );
  }
}

class PostStats extends StatelessWidget {
  const PostStats({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      child: Row(
        children: [
          Text(
            "100 Likes",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.blueGrey.shade400),
          ),
          Expanded(child: SizedBox()),
          Text(
            "3 Comments",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.blueGrey.shade400),
          ),
          SizedBox(width: kDefaultPadding),
          Text(
            "17 Share",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.blueGrey.shade400),
          ),
        ],
      ),
    );
  }
}

class PostImages extends StatelessWidget {
  const PostImages({
    Key? key,
    required this.buttonCarouselController,
    required this.images,
  }) : super(key: key);

  final CarouselController buttonCarouselController;
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(kDefaultPadding)),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
            child: CarouselSlider(
              carouselController: buttonCarouselController,
              options: CarouselOptions(
                enlargeCenterPage: true,
                height: 400,
                enlargeStrategy: CenterPageEnlargeStrategy.scale,
                enableInfiniteScroll: false,
                scrollDirection: Axis.horizontal,
              ),
              items: images
                  .map(
                    (e) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(kDefaultPadding),
                        child: Image.asset(
                          e,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Positioned(
            right: 0,
            child: InkWell(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              highlightColor: Colors.transparent,
              onTap: () {
                buttonCarouselController.nextPage(
                    curve: Curves.easeInOut,
                    duration: const Duration(milliseconds: 300));
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(kDefaultPadding),
                    topRight: Radius.circular(kDefaultPadding),
                  ),
                ),
                width: 60,
                height: 400 + kDefaultPadding,
                child: const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white,
                  size: 60,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            child: InkWell(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              highlightColor: Colors.transparent,
              onTap: () {
                buttonCarouselController.previousPage(
                    curve: Curves.easeInOut,
                    duration: const Duration(milliseconds: 300));
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(kDefaultPadding),
                    topLeft: Radius.circular(kDefaultPadding),
                  ),
                ),
                width: 60,
                height: 400 + kDefaultPadding,
                child: const Icon(
                  Icons.chevron_left_rounded,
                  color: Colors.white,
                  size: 60,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PostHead extends StatelessWidget {
  const PostHead({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircleAvatar(
          backgroundColor: Colors.black,
          child: Icon(Icons.person),
          maxRadius: 20,
        ),
        const SizedBox(width: kDefaultPadding),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Person Name",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade600,
                  height: 1),
            ),
            const SizedBox(height: kDefaultPadding / 5),
            Text(
              "Time",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey.shade300,
                height: 1,
              ),
            ),
          ],
        ),
        const Expanded(child: SizedBox()),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.more_horiz_outlined,
            color: Colors.grey.shade700,
          ),
          tooltip: "Report",
        )
      ],
    );
  }
}
