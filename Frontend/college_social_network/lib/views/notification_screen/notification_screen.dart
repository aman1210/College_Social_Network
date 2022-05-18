import 'package:flutter/material.dart';

import '../../responsive.dart';
import '../../utils/constants.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({Key? key}) : super(key: key);

  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    var isMobile = Responsive.isMobile(context);
    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.only(
          top: isMobile ? kDefaultPadding / 2 : kDefaultPadding * 1.2,
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
                  isMobile ? kDefaultPadding : kDefaultPadding * 1.5))),
      child: ListView.separated(
          controller: _controller,
          itemBuilder: (context, index) => ListTile(
                leading: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                trailing: Container(
                  height: 40,
                  width: 40,
                  child: Image.asset(
                    "assets/images/img4.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  "User XYZ liked your photo.",
                  style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : null),
                ),
                subtitle: Text(
                  DateTime.now().toString(),
                  style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : null),
                ),
              ),
          separatorBuilder: (context, index) => Divider(),
          itemCount: 20),
    );
  }
}
