import 'package:ConnectUs/models/notificationModel.dart' as noti;
import 'package:ConnectUs/view_models/auth_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../responsive.dart';
import '../../utils/constants.dart';
import '../../view_models/user_view_model.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  ScrollController _controller = ScrollController();
  bool isLoading = false;
  List<noti.Notification> _noti = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    var id = Provider.of<AuthViewModel>(context, listen: false).userId;
    Provider.of<UserViewModel>(context, listen: false)
        .getNotifications(id)
        .then((value) => {
              setState(() {
                isLoading = false;
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    var isMobile = Responsive.isMobile(context);
    _noti = Provider.of<UserViewModel>(context).notifications;
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
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
            child: _noti.length == 0
                ? Center(
                    child: Text("No new notifications"),
                  )
                : ListView.separated(
                    controller: _controller,
                    itemBuilder: (context, index) => ListTile(
                          leading: _noti[index].type == 'liked'
                              ? CircleAvatar(
                                  maxRadius: 30,
                                  backgroundColor: Colors.red.withOpacity(0.3),
                                  child: Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                )
                              : CircleAvatar(
                                  maxRadius: 30,
                                  backgroundColor: Colors.blue.withOpacity(0.3),
                                  child: Icon(
                                    Icons.comment,
                                    color: Colors.blue,
                                  ),
                                ),
                          trailing: Container(
                              height: 40,
                              width: 40,
                              child: _noti[index].postId != null &&
                                      _noti[index].postId!.images!.length > 0
                                  ? CachedNetworkImage(
                                      imageUrl: _noti[index].postId!.images![0])
                                  : CircleAvatar(
                                      backgroundColor:
                                          Colors.yellow.withOpacity(0.3),
                                      child: Icon(
                                        Icons.celebration,
                                        color: Colors.amber,
                                      ),
                                    )),
                          title: Text(
                            "${_noti[index].senderId?.name ?? "Unspecified"} ${_noti[index].type == 'liked' ? 'liked' : 'commented'} on your post.",
                            style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white70
                                    : null),
                          ),
                          subtitle: Text(
                            DateFormat('EE, d/MM/yy')
                                .add_jm()
                                .format(_noti[index].timeStamp!),
                            style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white70
                                    : null),
                          ),
                        ),
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: _noti.length),
          );
  }
}
