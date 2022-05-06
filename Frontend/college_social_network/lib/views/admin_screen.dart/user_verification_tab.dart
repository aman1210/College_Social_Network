import 'package:flutter/material.dart';

class UserVerification extends StatelessWidget {
  const UserVerification({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
      ),
      itemBuilder: (context, index) => Text("User $index"),
      itemCount: 50,
    ));
  }
}
