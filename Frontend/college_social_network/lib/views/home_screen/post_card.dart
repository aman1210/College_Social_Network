import 'package:ConnectUs/components/custom_dialog.dart';
import 'package:ConnectUs/models/HttpExceptions.dart';
import 'package:ConnectUs/models/postModel.dart';
import 'package:ConnectUs/view_models/auth_view_model.dart';
import 'package:ConnectUs/view_models/post_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../responsive.dart';
import '../../utils/constants.dart';
import '../../utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_fade/image_fade.dart';

class PostCard extends StatefulWidget {
  PostCard({Key? key, required this.index, this.post}) : super(key: key);
  final int index;
  final Post? post;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  CarouselController buttonCarouselController = CarouselController();

  bool _animate = false;

  static bool _isStart = true;

  TextEditingController _commentController = TextEditingController();
  bool disableComment = false;

  submit() async {
    if (_commentController.text.length == 0) {
      return;
    }
    setState(() {
      disableComment = true;
    });
    try {
      await Provider.of<PostViewModel>(context, listen: false).commentOnPost(
          widget.post!.id!,
          Provider.of<AuthViewModel>(context, listen: false).userName,
          _commentController.text,
          Provider.of<AuthViewModel>(context, listen: false).userId);
    } catch (err) {
      showDialog(
          context: context,
          builder: (context) => CustomDialog(msg: err.toString()));
    }
    setState(() {
      disableComment = false;
    });
    _commentController.clear();
  }

  @override
  void initState() {
    super.initState();
    _isStart
        ? Future.delayed(Duration(milliseconds: (widget.index + 1) * 250), () {
            setState(() {
              _animate = true;
              _isStart = false;
            });
          })
        : _animate = true;
  }

  @override
  Widget build(BuildContext context) {
    var isMobile = Responsive.isMobile(context);
    var profileImage =
        Provider.of<AuthViewModel>(context, listen: false).profileImage;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 1000),
      opacity: _animate ? 1 : 0,
      curve: Curves.easeInOutQuart,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 1000),
        padding: _animate
            ? const EdgeInsets.all(4.0)
            : const EdgeInsets.only(top: 10),
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: isMobile ? kDefaultPadding / 2 : kDefaultPadding),
          padding: EdgeInsets.symmetric(
              vertical: kDefaultPadding / 2,
              horizontal: isMobile ? kDefaultPadding / 2 : kDefaultPadding),
          decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).scaffoldBackgroundColor
                  : Colors.white,
              borderRadius: BorderRadius.circular(kDefaultPadding),
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.03)
                      : Colors.black.withOpacity(0.07),
                  offset: const Offset(0, 5),
                )
              ]),
          child: Column(
            children: [
              PostHead(post: widget.post),
              if (widget.post?.text != null)
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
                  child: Text(
                    widget.post!.text!,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : null),
                  ),
                ),
              if (widget.post != null &&
                  widget.post!.images != null &&
                  widget.post!.images!.length != 0)
                PostImages(
                  buttonCarouselController: buttonCarouselController,
                  images: widget.post!.images!,
                  isMobile: isMobile,
                ),
              PostStats(post: widget.post),
              PostButtons(
                post: widget.post,
              ),
              Container(
                padding: const EdgeInsets.only(top: kDefaultPadding / 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.lightBlue,
                      backgroundImage: CachedNetworkImageProvider(profileImage),
                      child: profileImage != null
                          ? null
                          : Icon(
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
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.blueGrey.withOpacity(0.2)
                              : Colors.blueGrey.shade50,
                          borderRadius: BorderRadius.circular(
                            kDefaultPadding / 2,
                          ),
                        ),
                        child: TextFormField(
                          maxLines: 5,
                          minLines: 1,
                          controller: _commentController,
                          readOnly: disableComment,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Write a comment..",
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        submit();
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(kDefaultPadding / 4),
                          color: Colors.blue.withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.send,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              if (widget.post!.comments != null &&
                  widget.post!.comments!.length > 0)
                ...widget.post!.comments!.map(
                  (c) => Card(
                    child: ListTile(
                      title: Text(
                        c['text'],
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Author: ${c['userName']}",
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class PostButtons extends StatefulWidget {
  PostButtons({Key? key, this.post}) : super(key: key);

  Post? post;

  @override
  State<PostButtons> createState() => _PostButtonsState();
}

class _PostButtonsState extends State<PostButtons> {
  bool isLiked = false;

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
            onPressed: () async {
              setState(() {
                isLiked = !isLiked;
              });
              try {
                await Provider.of<PostViewModel>(context, listen: false)
                    .likePost(
                        widget.post!.id!,
                        Provider.of<AuthViewModel>(context, listen: false)
                            .userId);
              } catch (err) {
                showDialog(
                    context: context,
                    builder: (context) => CustomDialog(msg: err.toString()));
              }
            },
            icon: isLiked
                ? const Icon(
                    Icons.favorite_rounded,
                    color: Colors.red,
                  )
                : const Icon(
                    Icons.favorite_border_rounded,
                  ),
            label: const Text("Like"),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.mode_comment_outlined),
            label: const Text("Comments"),
          ),
          TextButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(
                  text:
                      "http://connectus-9b0c5.web.app/post/${widget.post!.id!}"));

              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: const Text("URL copied to clipboard!"),
                duration: const Duration(seconds: 1),
              ));
            },
            icon: const Icon(Icons.share_outlined),
            label: const Text("Share"),
          ),
        ],
      ),
    );
  }
}

class PostStats extends StatelessWidget {
  const PostStats({Key? key, this.post}) : super(key: key);
  final Post? post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      child: Row(
        children: [
          Text(
            // ${post!.likeCount ?? 0}
            " ${post?.likeCount == null ? 0 : post!.likeCount} Likes",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.blueGrey.shade400),
          ),
          const Expanded(child: SizedBox()),
          Text(
            //
            "${post?.comments == null ? 0 : post?.comments!.length} Comments",
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
    required this.isMobile,
  }) : super(key: key);

  final CarouselController buttonCarouselController;
  final List<String> images;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.blueGrey.withOpacity(0.2)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(kDefaultPadding)),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: isMobile ? kDefaultPadding / 4 : kDefaultPadding,
                vertical: isMobile ? kDefaultPadding / 4 : kDefaultPadding / 2),
            child: CarouselSlider(
              carouselController: buttonCarouselController,
              options: CarouselOptions(
                enlargeCenterPage: true,
                height: isMobile ? 200 : 300,
                viewportFraction: isMobile ? 1 : 0.9,
                enlargeStrategy: CenterPageEnlargeStrategy.scale,
                enableInfiniteScroll: false,
                scrollDirection: Axis.horizontal,
              ),
              items: images
                  .map(
                    (e) => Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 0 : kDefaultPadding),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            isMobile ? kDefaultPadding / 2 : kDefaultPadding),
                        child: ImageFade(
                          image: NetworkImage(e),
                          placeholder: SpinKitCubeGrid(
                              color: Theme.of(context).primaryColor),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          if (images.length > 1)
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
                  margin: isMobile
                      ? null
                      : const EdgeInsets.only(right: kDefaultPadding / 2),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(kDefaultPadding),
                      topRight: Radius.circular(kDefaultPadding),
                    ),
                  ),
                  width: isMobile ? 30 : 40,
                  height: (isMobile ? 200 : 300) + kDefaultPadding,
                  child: CircleAvatar(
                    backgroundColor: Colors.black26,
                    maxRadius: isMobile ? 15 : 20,
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white,
                      size: isMobile ? 30 : 40,
                    ),
                  ),
                ),
              ),
            ),
          if (images.length > 1)
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
                  margin: isMobile
                      ? null
                      : const EdgeInsets.only(left: kDefaultPadding / 2),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(kDefaultPadding),
                      topLeft: Radius.circular(kDefaultPadding),
                    ),
                  ),
                  width: isMobile ? 30 : 40,
                  height: (isMobile ? 200 : 300) + kDefaultPadding,
                  child: CircleAvatar(
                    maxRadius: isMobile ? 15 : 20,
                    backgroundColor: Colors.black26,
                    child: Icon(
                      Icons.chevron_left_rounded,
                      color: Colors.white,
                      size: isMobile ? 30 : 40,
                    ),
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
  const PostHead({Key? key, this.post}) : super(key: key);
  final Post? post;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (post!.profileImage == null)
          CircleAvatar(
            child: Icon(Icons.person),
            maxRadius: 20,
          ),
        if (post!.profileImage != null)
          CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: CachedNetworkImageProvider(post!.profileImage!),
            maxRadius: 20,
          ),
        const SizedBox(width: kDefaultPadding),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              post!.userName!,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade600,
                  height: 1),
            ),
            const SizedBox(height: kDefaultPadding / 5),
            Text(
              DateFormat('EEE, MMM d, yy')
                  .add_jm()
                  .format(DateTime.parse(post!.timeStamp!)),
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
          onPressed: () async {
            bool res = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      content: const Text(
                          "Do you want to report this post to admin?"),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: const Text("Yes")),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: const Text("No")),
                      ],
                    ));
            if (res) {
              try {
                await Provider.of<PostViewModel>(context, listen: false)
                    .reportPost(post!.id!);
                showDialog(
                    context: context,
                    builder: (context) =>
                        const CustomDialog(msg: "Post reported Successfully!"));
              } on HttpExceptions catch (err) {
                showDialog(
                    context: context,
                    builder: (context) =>
                        const CustomDialog(msg: "Something went wrong!"));
              } catch (err) {
                showDialog(
                    context: context,
                    builder: (context) =>
                        const CustomDialog(msg: "Something went wrong!"));
              }
            }
          },
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
