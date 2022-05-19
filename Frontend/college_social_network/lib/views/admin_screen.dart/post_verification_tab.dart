import '../../utils/constants.dart';
import 'package:flutter/material.dart';

class PostsVerification extends StatelessWidget {
  const PostsVerification({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
        itemBuilder: (context, index) => PostsVerificationItem(),
        separatorBuilder: (context, index) => Divider(),
        itemCount: 50,
      ),
    );
  }
}

class PostsVerificationItem extends StatelessWidget {
  const PostsVerificationItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
    );
  }
}
