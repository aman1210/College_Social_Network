import 'package:college_social_network/responsive.dart';
import 'package:college_social_network/view_models/message_view_model.dart';
import 'package:college_social_network/views/home_screen/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/constants.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    var isMobile = Responsive.isMobile(context);
    var selectedUser = Provider.of<MessageViewModel>(context).selectedUser;
    return isMobile && selectedUser == null
        ? ChatList()
        : Container(
            width: double.infinity,
            clipBehavior: Clip.hardEdge,
            padding: EdgeInsets.only(
                top: isMobile ? kDefaultPadding / 2 : kDefaultPadding * 1.2,
                left: kDefaultPadding,
                right: kDefaultPadding),
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                        isMobile ? kDefaultPadding : kDefaultPadding * 1.5),
                    topRight: Radius.circular(
                        isMobile ? kDefaultPadding : kDefaultPadding * 1.5))),
            child: selectedUser == null
                ? Center(
                    child: Text("Please select user to chat"),
                  )
                : Container(
                    child: Text("User $selectedUser chatbox"),
                  ),
          );
  }
}
