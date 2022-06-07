import 'package:flutter/material.dart';

import '../../responsive.dart';

class EditProfieForm extends StatelessWidget {
  EditProfieForm({Key? key}) : super(key: key);
  final _key = GlobalKey<FormState>();
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    var isMobile = Responsive.isMobile(context);
    var isTablet = Responsive.isTablet(context);
    var size = MediaQuery.of(context).size;
    return AlertDialog(
      content: Form(
        child: Container(
          width: isMobile
              ? size.width * 0.9
              : isTablet
                  ? size.width * 0.8
                  : size.width * 0.6,
          height: size.height * 0.8,

          color: Colors.white,
          // child: Text("hello"),
          child: SingleChildScrollView(
            controller: _controller,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Edit Profile"),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Intro",
                    border: OutlineInputBorder(),
                  ),
                ),
                TextFormField(
                  minLines: 3,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "About",
                    border: OutlineInputBorder(),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Location",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
        key: _key,
      ),
    );
  }
}
