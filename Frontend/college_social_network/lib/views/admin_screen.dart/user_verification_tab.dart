import '../../utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_fade/image_fade.dart';

class UsersVerification extends StatelessWidget {
  const UsersVerification({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          itemBuilder: (context, index) => UserVerificationCard(user: index),
          itemCount: 50,
        ));
  }
}

class UserVerificationCard extends StatelessWidget {
  UserVerificationCard({Key? key, required this.user}) : super(key: key);
  int user;

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
              "User $user",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: kDefaultPadding / 2),
            child: Text(
              "Email $user",
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
