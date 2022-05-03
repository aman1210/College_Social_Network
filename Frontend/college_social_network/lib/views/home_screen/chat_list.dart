import 'package:college_social_network/components/current_state.dart';
import 'package:college_social_network/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatList extends StatelessWidget {
  ChatList({Key? key}) : super(key: key);
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding / 2,
      ),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kDefaultPadding / 2),
                ),
                hintText: "Search Friends!",
                prefixIcon: Icon(CupertinoIcons.search)),
          ),
          SizedBox(height: kDefaultPadding / 2),
          Expanded(
            child: ListView.separated(
                scrollDirection: Axis.vertical,
                controller: _controller,
                itemBuilder: (context, index) =>
                    AnimatedChatListItem(index: index),
                separatorBuilder: (context, index) => SizedBox(height: 6),
                itemCount: 15),
          )
        ],
      ),
    );
  }
}

class AnimatedChatListItem extends StatefulWidget {
  const AnimatedChatListItem({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  State<AnimatedChatListItem> createState() => _AnimatedChatListItemState();
}

class _AnimatedChatListItemState extends State<AnimatedChatListItem> {
  bool _animate = false;

  static bool _isStart = true;

  @override
  void initState() {
    super.initState();
    _isStart
        ? Future.delayed(Duration(milliseconds: (widget.index + 1) * 150), () {
            setState(() {
              _animate = true;
              _isStart = false;
            });
          })
        : _animate = true;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 1000),
      opacity: _animate ? 1 : 0,
      curve: Curves.easeInOutQuart,
      child: AnimatedPadding(
        duration: Duration(milliseconds: 1000),
        padding: _animate
            ? const EdgeInsets.all(2.0)
            : const EdgeInsets.only(top: 10),
        child: ListTile(
          onTap: () {
            CurrentState.pageController.animateToPage(
              2,
              duration: Duration(milliseconds: 700),
              curve: Curves.decelerate,
            );
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          leading: CircleAvatar(
            child: Icon(Icons.person_outline_rounded),
          ),
          title: Text(
            "Friend ${widget.index + 1}",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey.shade700),
          ),
          trailing: widget.index % 3 == 0
              ? Container(
                  height: 8,
                  width: 8,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.green),
                )
              : Text(
                  "5 min",
                  style: TextStyle(color: Colors.grey.shade500),
                ),
        ),
      ),
    );
  }
}
