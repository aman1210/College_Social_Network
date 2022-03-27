import 'package:college_social_network/utils/constants.dart';
import 'package:flutter/material.dart';

import 'post_card.dart';

class PostFeed extends StatelessWidget {
  PostFeed({Key? key}) : super(key: key);

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        width: double.infinity,
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.only(top: kDefaultPadding),
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(kDefaultPadding * 1.5),
                topRight: Radius.circular(kDefaultPadding * 1.5))),
        child: ListView.separated(
          clipBehavior: Clip.hardEdge,
          controller: _scrollController,
          itemBuilder: (context, index) => PostCard(),
          separatorBuilder: (context, index) =>
              const SizedBox(height: kDefaultPadding),
          itemCount: 10,
        ));
  }
}
