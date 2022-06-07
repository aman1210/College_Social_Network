import 'package:ConnectUs/models/user.dart';
import 'package:ConnectUs/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../responsive.dart';

class EditProfieForm extends StatefulWidget {
  const EditProfieForm({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<EditProfieForm> createState() => _EditProfieFormState();
}

class _EditProfieFormState extends State<EditProfieForm> {
  final _key = GlobalKey<FormState>();

  String? intro;
  String? about;
  String? location;

  final ScrollController _controller = ScrollController();
  final TextEditingController _intro = TextEditingController();
  final TextEditingController _about = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _social = TextEditingController();
  List<String> social = [];

  DateTime dob = DateTime.now();

  @override
  void initState() {
    super.initState();
    // if (widget.user.dob != null) {
    //   dob = DateTime.parse(widget.user.dob!);
    // }
    _intro.text = widget.user.intro ?? "";
    _about.text = widget.user.about ?? "";
    _location.text = widget.user.location ?? "";
    if (widget.user.socialLinks != null &&
        widget.user.socialLinks!.length > 0) {
      social = widget.user.socialLinks as List<String>;
    }
    setState(() {});
  }

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
                SizedBox(height: kDefaultPadding),
                TextFormField(
                  controller: _intro,
                  // initialValue: intro,
                  decoration: InputDecoration(
                    hintText: "Intro",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: kDefaultPadding / 2),
                Row(
                  children: [
                    Text(
                      "DOB: ${DateFormat('dd/MMMM/yyyy').format(dob)}",
                      style: TextStyle(color: Colors.blue),
                    ),
                    IconButton(
                        onPressed: () async {
                          var datePicked = await showDatePicker(
                              context: context,
                              initialDate: dob,
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2050));
                          if (datePicked != null) {
                            setState(() {
                              dob = datePicked;
                            });
                          }
                        },
                        icon: Icon(Icons.calendar_month)),
                  ],
                ),
                SizedBox(height: kDefaultPadding / 2),
                TextFormField(
                  controller: _about,
                  // initialValue: about,
                  minLines: 3,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "About",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: kDefaultPadding / 2),
                TextFormField(
                  // initialValue: location,
                  controller: _location,
                  decoration: InputDecoration(
                    hintText: "Location",
                    border: OutlineInputBorder(),
                  ),
                ),
                ...social
                    .map(
                      ((e) => Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: kDefaultPadding / 4),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    readOnly: true,
                                    initialValue: e,
                                    decoration: InputDecoration(
                                      hintText: e,
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                )
                              ],
                            ),
                          )),
                    )
                    .toList(),
                SizedBox(height: kDefaultPadding / 2),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _social,
                        decoration: InputDecoration(
                          hintText: "Social Link",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        social.add(_social.text);
                        _social.clear();
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.add_circle_outline_rounded,
                        color: Colors.green,
                      ),
                    )
                  ],
                ),
                SizedBox(height: kDefaultPadding / 2),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Submit"),
                ),
              ],
            ),
          ),
          key: _key,
        ),
      ),
    );
  }
}
