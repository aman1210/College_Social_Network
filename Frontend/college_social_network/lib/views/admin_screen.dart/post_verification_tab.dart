import 'package:ConnectUs/models/adminPosts.dart';
import 'package:ConnectUs/responsive.dart';
import 'package:ConnectUs/view_models/admin_view_model.dart';
import 'package:ConnectUs/view_models/auth_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../utils/constants.dart';
import 'package:flutter/material.dart';

import '../home_screen/post_card.dart';

class PostsVerification extends StatefulWidget {
  const PostsVerification({
    Key? key,
  }) : super(key: key);

  @override
  State<PostsVerification> createState() => _PostsVerificationState();
}

class _PostsVerificationState extends State<PostsVerification> {
  List<AdminPosts> posts = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    Provider.of<AdminViewModel>(context, listen: false)
        .getPosts()
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    posts = Provider.of<AdminViewModel>(context).posts;
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : posts.length == 0
            ? Center(
                child: Text("No new post to verify"),
              )
            : Container(
                child: ListView.separated(
                  itemBuilder: (context, index) =>
                      PostsVerificationItem(post: posts[index]),
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: posts.length,
                ),
              );
  }
}

class PostsVerificationItem extends StatelessWidget {
  const PostsVerificationItem({Key? key, required this.post}) : super(key: key);

  final AdminPosts post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: ((context) => PostVerificationPostDetail(post: post))));
        },
        child: Row(
          children: [
            if (post.images != null)
              Container(
                height: 60,
                width: 60,
                child: CachedNetworkImage(
                  imageUrl: post.images![0],
                  placeholder: (context, string) => CircularProgressIndicator(),
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(width: kDefaultPadding),
            if (post.text != null)
              Expanded(
                child: Text(
                  post.text!.length > 100
                      ? "${post.text!.substring(0, 197)}..."
                      : post.text!,
                ),
              ),
            SizedBox(width: kDefaultPadding),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  post.userName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: kDefaultPadding / 4),
                Text(
                  DateFormat('EE, d/MM/yyyy').add_jm().format(post.timeStamp),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PostVerificationPostDetail extends StatelessWidget {
  PostVerificationPostDetail({Key? key, required this.post}) : super(key: key);

  final AdminPosts post;
  final buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    var isMobile = Responsive.isMobile(context);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          PostImages(
            buttonCarouselController: buttonCarouselController,
            images: post.images!,
            isMobile: isMobile,
          ),
          Text(post.text!),
        ],
      ),
    );
  }
}
