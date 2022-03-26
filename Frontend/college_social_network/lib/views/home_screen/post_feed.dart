import 'package:college_social_network/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:college_social_network/extensions.dart';

class PostFeed extends StatelessWidget {
  const PostFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.only(
          top: kDefaultPadding, left: kDefaultPadding, right: kDefaultPadding),
      decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(kDefaultPadding * 1.5),
              topRight: Radius.circular(kDefaultPadding * 1.5))),
      child: Container(
        child: ListView(physics: NeverScrollableScrollPhysics(), children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.red,
              ),
              Column(
                children: [
                  Text(
                    "First Name",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              )
            ],
          )
        ]),
      ).addNeumorphism(),
    );
  }
}
