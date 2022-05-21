import 'package:ConnectUs/view_models/chat_view_model.dart';

import '../../models/message.dart';
import '../../models/user.dart';
import '../../responsive.dart';
import '../../view_models/message_view_model.dart';
import '../../views/home_screen/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/constants.dart';

class MessageScreen extends StatefulWidget {
  MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final ScrollController _chatListController = ScrollController();

  List<Message> chats = [];
  late String chatId;
  late User selected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isMobile = Responsive.isMobile(context);
    var selectedUser = Provider.of<MessageViewModel>(context).selectedUser;
    // var model = Provider.of<ChatModel>(context);
    if (selectedUser != null) {
      selected = Provider.of<ChatModel>(context, listen: false)
          .friendList[selectedUser];
      chatId = selected.chatID;
      chats = Provider.of<ChatModel>(context).getMessagesForChatID(chatId);
    }
    return isMobile && selectedUser == null
        ? ChatList()
        : Container(
            width: double.infinity,
            clipBehavior: Clip.hardEdge,
            padding: EdgeInsets.only(
                top: isMobile ? kDefaultPadding / 2 : kDefaultPadding,
                left: isMobile ? kDefaultPadding / 2 : kDefaultPadding,
                right: isMobile ? kDefaultPadding / 2 : kDefaultPadding),
            decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white10
                    : Colors.grey.shade200,
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
                    margin: const EdgeInsets.only(bottom: kDefaultPadding / 2),
                    padding: EdgeInsets.only(
                        top: isMobile ? kDefaultPadding / 2 : kDefaultPadding),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context).scaffoldBackgroundColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(
                          isMobile ? kDefaultPadding / 2 : kDefaultPadding * 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ChatBoxHeading(
                          selectedUser: selected,
                          isMobile: isMobile,
                        ),
                        Divider(height: kDefaultPadding),
                        Expanded(
                          child: ListView.builder(
                            controller: _chatListController,
                            reverse: true,
                            itemBuilder: (context, index) => MessageBubble(
                              chatSelected: chats[index],
                              isMobile: isMobile,
                              userChatID: chatId,
                            ),
                            itemCount: chats.length,
                          ),
                        ),
                        Divider(height: kDefaultPadding / 2),
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Theme.of(context).scaffoldBackgroundColor
                                  : null,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(isMobile
                                      ? kDefaultPadding / 2
                                      : kDefaultPadding * 1),
                                  bottomRight: Radius.circular(isMobile
                                      ? kDefaultPadding / 2
                                      : kDefaultPadding * 1))),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: isMobile
                                          ? kDefaultPadding / 2
                                          : kDefaultPadding),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: isMobile
                                          ? kDefaultPadding / 2
                                          : kDefaultPadding),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.03),
                                    borderRadius: BorderRadius.circular(5),
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: TextFormField(
                                    style: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? TextStyle(color: Colors.white70)
                                        : null,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Type something here",
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: isMobile ? 12 : 14),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                margin: EdgeInsets.only(
                                    right: isMobile
                                        ? kDefaultPadding / 2
                                        : kDefaultPadding),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Icon(
                                  Icons.send,
                                  color: Colors.blue,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
          );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {Key? key,
      required this.chatSelected,
      required this.isMobile,
      required this.userChatID})
      : super(key: key);

  final Message chatSelected;
  final bool isMobile;
  final String userChatID;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: userChatID == chatSelected.senderID
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          if (userChatID == chatSelected.senderID)
            Container(
              margin: const EdgeInsets.only(right: 8),
              height: 40,
              width: 40,
              child: CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: isMobile ? kDefaultPadding / 2 : kDefaultPadding,
                vertical: isMobile ? kDefaultPadding / 4 : kDefaultPadding / 2),
            constraints:
                BoxConstraints(maxWidth: isMobile ? width * 0.6 : width * 0.38),
            decoration: BoxDecoration(
              border: Border.all(
                  color: userChatID == chatSelected.senderID
                      ? Colors.lightBlue
                      : Color(0xff707C9740).withOpacity(0.25),
                  width: 1),
              color: userChatID == chatSelected.senderID
                  ? Theme.of(context).brightness == Brightness.dark
                      ? Colors.blueGrey.shade900
                      : Colors.lightBlue[300]
                  : Theme.of(context).brightness == Brightness.dark
                      ? Colors.white10
                      : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: userChatID == chatSelected.senderID
                    ? const Radius.circular(0)
                    : const Radius.circular(10),
                bottomLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),
                bottomRight: userChatID == chatSelected.senderID
                    ? const Radius.circular(10)
                    : const Radius.circular(0),
              ),
            ),
            child: Text(
              chatSelected.text,
              textAlign: userChatID == chatSelected.senderID
                  ? TextAlign.start
                  : TextAlign.end,
              style: TextStyle(
                  fontSize: isMobile ? 12 : 14,
                  color: userChatID == chatSelected.senderID
                      ? Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.white
                      : Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : const Color(0xff707C97)),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBoxHeading extends StatelessWidget {
  const ChatBoxHeading(
      {Key? key, required this.selectedUser, required this.isMobile})
      : super(key: key);

  final User selectedUser;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: isMobile ? kDefaultPadding / 4 : kDefaultPadding / 2,
          right: isMobile ? kDefaultPadding / 2 : kDefaultPadding),
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                Provider.of<MessageViewModel>(context, listen: false)
                    .selectUser(-1);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).primaryColor,
              )),
          CircleAvatar(
            child: Icon(Icons.person),
          ),
          SizedBox(width: kDefaultPadding / 2),
          Text(
            "${selectedUser.name} ",
            style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          Expanded(child: SizedBox()),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.info_outline_rounded,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessageModel {
  String name;
  String lastOnline;
  String issueType;
  List<MessageModel> msgs;
  ChatMessageModel(
      {required this.name,
      required this.lastOnline,
      required this.issueType,
      required this.msgs});
}

class MessageModel {
  String msg;
  String time;
  bool fromUser;
  MessageModel({required this.msg, required this.time, required this.fromUser});
}
