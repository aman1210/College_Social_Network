import 'package:college_social_network/utils/constants.dart';
import 'package:flutter/material.dart';

class PostFeed extends StatelessWidget {
  const PostFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.only(
            top: kDefaultPadding,
            left: kDefaultPadding,
            right: kDefaultPadding),
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(kDefaultPadding * 1.5),
                topRight: Radius.circular(kDefaultPadding * 1.5))),
        child: Text("Welcome user"),
      ),
    );
  }
}
