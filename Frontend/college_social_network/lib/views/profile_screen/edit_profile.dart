import 'package:ConnectUs/components/custom_dialog.dart';
import 'package:ConnectUs/models/HttpExceptions.dart';
import 'package:ConnectUs/models/user.dart';
import 'package:ConnectUs/utils/constants.dart';
import 'package:ConnectUs/view_models/auth_view_model.dart';
import 'package:ConnectUs/view_models/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.user.dob != null && widget.user.dob != '') {
      dob = DateTime.parse(widget.user.dob!);
    }
    _intro.text = widget.user.intro ?? "";
    _about.text = widget.user.about ?? "";
    _location.text = widget.user.location ?? "";
    if (widget.user.socialLinks != null &&
        widget.user.socialLinks!.length > 0) {
      social = widget.user.socialLinks as List<String>;
    }
    setState(() {});
  }

  submit() async {
    widget.user.intro = _intro.text;
    widget.user.about = _about.text;
    widget.user.dob = dob.toIso8601String();
    widget.user.location = _location.text;
    widget.user.socialLinks = social;

    try {
      var id = Provider.of<AuthViewModel>(context, listen: false).userId;
      var token = Provider.of<AuthViewModel>(context, listen: false).token;
      setState(() {
        isLoading = true;
      });
      await Provider.of<UserViewModel>(context, listen: false)
          .editProfile(id, token, widget.user);
    } on HttpExceptions catch (err) {
      showDialog(
          context: context,
          builder: (context) => CustomDialog(msg: err.toString()));
    } catch (err) {
      showDialog(
          context: context,
          builder: (context) => CustomDialog(msg: err.toString()));
    }
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
                const Text("Edit Profile"),
                const SizedBox(height: kDefaultPadding),
                TextFormField(
                  controller: _intro,
                  // initialValue: intro,
                  decoration: const InputDecoration(
                    hintText: "Intro",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: kDefaultPadding / 2),
                Row(
                  children: [
                    Text(
                      "DOB: ${DateFormat('dd/MMMM/yyyy').format(dob)}",
                      style: const TextStyle(color: Colors.blue),
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
                        icon: const Icon(Icons.calendar_month)),
                  ],
                ),
                const SizedBox(height: kDefaultPadding / 2),
                TextFormField(
                  controller: _about,
                  // initialValue: about,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: "About",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: kDefaultPadding / 2),
                TextFormField(
                  // initialValue: location,
                  controller: _location,
                  decoration: const InputDecoration(
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
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                )
                              ],
                            ),
                          )),
                    )
                    .toList(),
                const SizedBox(height: kDefaultPadding / 2),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _social,
                        decoration: const InputDecoration(
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
                      icon: const Icon(
                        Icons.add_circle_outline_rounded,
                        color: Colors.green,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: kDefaultPadding / 2),
                if (isLoading) const CircularProgressIndicator(),
                if (!isLoading)
                  ElevatedButton(
                    onPressed: () {
                      submit();
                    },
                    child: const Text("Submit"),
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
