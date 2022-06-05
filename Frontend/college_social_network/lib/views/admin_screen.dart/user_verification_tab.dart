import 'package:ConnectUs/view_models/admin_view_model.dart';
import 'package:provider/provider.dart';

import '../../utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_fade/image_fade.dart';

class UsersVerification extends StatefulWidget {
  const UsersVerification({
    Key? key,
  }) : super(key: key);

  @override
  State<UsersVerification> createState() => _UsersVerificationState();
}

class _UsersVerificationState extends State<UsersVerification> {
  List<AdminUsers> users = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    Provider.of<AdminViewModel>(context, listen: false)
        .getUsers()
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    users = Provider.of<AdminViewModel>(context).users;
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : users.length == 0
            ? Center(
                child: Text("No new user to verify"),
              )
            : Container(
                padding: const EdgeInsets.only(
                    top: kDefaultPadding,
                    left: kDefaultPadding,
                    right: kDefaultPadding),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 3 / 4,
                      crossAxisSpacing: kDefaultPadding,
                      mainAxisSpacing: kDefaultPadding),
                  itemBuilder: (context, index) =>
                      UserVerificationCard(user: users[index]),
                  itemCount: users.length,
                ));
  }
}

class UserVerificationCard extends StatelessWidget {
  UserVerificationCard({Key? key, required this.user}) : super(key: key);
  AdminUsers user;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(kDefaultPadding / 4),
                  topRight: Radius.circular(kDefaultPadding / 4)),
              child: Container(
                width: double.infinity,
                child: ImageFade(
                  image: NetworkImage(
                    user.profileImage ??
                        "https://images.pexels.com/photos/1704488/pexels-photo-1704488.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                  ),
                  fit: BoxFit.cover,
                  placeholder: SpinKitCubeGrid(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: kDefaultPadding / 2),
            child: Text(
              user.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: kDefaultPadding / 2),
            child: Text(
              user.email,
              style: TextStyle(
                  height: 1,
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
                  color: Colors.black.withOpacity(0.7)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding / 4),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius:
                              BorderRadius.circular(kDefaultPadding / 4)),
                      child: const Text(
                        "Approve",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(kDefaultPadding / 4)),
                      child: Text(
                        "Delete",
                        style: TextStyle(color: Theme.of(context).primaryColor),
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
