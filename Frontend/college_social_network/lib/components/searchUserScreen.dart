import 'package:ConnectUs/components/custom_dialog.dart';
import 'package:ConnectUs/models/HttpExceptions.dart';
import 'package:ConnectUs/models/friendList.dart';
import 'package:ConnectUs/responsive.dart';
import 'package:ConnectUs/utils/constants.dart';
import 'package:ConnectUs/view_models/auth_view_model.dart';
import 'package:ConnectUs/view_models/user_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({Key? key}) : super(key: key);

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  List<String> sentRequest = [];

  var isLoading = false;

  sendRequest(String id) async {
    var token = Provider.of<AuthViewModel>(context, listen: false).token;
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<UserViewModel>(context, listen: false)
          .sendFriendRequest(id, token);
      sentRequest.add(id);
    } on HttpExceptions catch (err) {
      showDialog(
          context: context,
          builder: (context) => CustomDialog(msg: err.toString()));
    } catch (err) {
      showDialog(
          context: context,
          builder: (context) => CustomDialog(msg: err.toString()));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var listOfUser = Provider.of<UserViewModel>(context).searchResult;
    var isMobile = Responsive.isMobile(context);
    var isTab = Responsive.isTablet(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Search Result"),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile
                        ? 2
                        : isTab
                            ? 3
                            : 5,
                    childAspectRatio: 3 / 4,
                    crossAxisSpacing: kDefaultPadding,
                    mainAxisSpacing: kDefaultPadding),
                itemBuilder: (context, index) => SearchResultItem(
                    user: listOfUser[index],
                    isSent: sentRequest.contains(listOfUser[index].id),
                    send: sendRequest),
                itemCount: listOfUser.length,
              ),
            ),
    );
  }
}

class SearchResultItem extends StatelessWidget {
  SearchResultItem(
      {Key? key, required this.user, this.isSent = false, required this.send})
      : super(key: key);
  final FriendListElement user;
  bool isSent;
  final Function send;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kDefaultPadding / 4),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(kDefaultPadding / 4, kDefaultPadding / 2),
                blurRadius: kDefaultPadding / 2)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(kDefaultPadding / 4),
                  topRight: Radius.circular(kDefaultPadding / 4)),
              child: SizedBox(
                width: double.infinity,
                child: user.profileImage != null &&
                        user.profileImage!.contains('.com')
                    ? CachedNetworkImage(
                        imageUrl: user.profileImage!,
                        placeholder: (context, progress) =>
                            SpinKitDancingSquare(
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : Icon(
                        CupertinoIcons.person_solid,
                        size: 80,
                        color: Colors.blue,
                      ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: kDefaultPadding / 2),
            child: Text(
              user.name!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding / 2),
            child: isSent
                ? Icon(
                    Icons.check,
                    color: Colors.green,
                  )
                : Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            send(user.id);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius:
                                    BorderRadius.circular(kDefaultPadding / 4)),
                            child: const Text(
                              "Send Connection Request",
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          )
        ],
      ),
    );
  }
}
