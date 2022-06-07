import 'package:ConnectUs/components/custom_dialog.dart';
import 'package:ConnectUs/models/HttpExceptions.dart';
import 'package:ConnectUs/responsive.dart';
import 'package:ConnectUs/utils/constants.dart';
import 'package:ConnectUs/view_models/admin_view_model.dart';
import 'package:ConnectUs/views/home_screen/new_post.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '/components/app_bar.dart';
import '/views/admin_screen.dart/post_verification_tab.dart';
import '/views/admin_screen.dart/reports_tab.dart';
import '/views/admin_screen.dart/user_verification_tab.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var isMobile = Responsive.isMobile(context);
    var isTablet = Responsive.isTablet(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(isAdmin: true),
          TabBar(
            // overlayColor: MaterialStateProperty.all(Colors.grey),
            indicator: BoxDecoration(
              color: Colors.blue.withOpacity(0.07),
              border: const Border(
                bottom: BorderSide(color: Colors.blue, width: 2),
              ),
            ),
            indicatorColor: Colors.red,
            labelStyle: const TextStyle(
              fontSize: 16,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
            labelColor: Colors.black,

            tabs: const [
              Tab(child: Text("User Verification")),
              Tab(child: Text("Post Verification")),
              Tab(child: Text("Reports")),
            ],
            unselectedLabelColor: Colors.grey,
            controller: _tabController,
          ),
          Expanded(
            child: TabBarView(
              children: const [
                UsersVerification(),
                PostsVerification(),
                ReportsVerification(),
              ],
              controller: _tabController,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var res = await showOption(isMobile, isTablet, size);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  showOption(bool isMobile, bool isTablet, Size size) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create"),
        content: SizedBox(
          width: isMobile
              ? size.width * 0.9
              : isTablet
                  ? size.width * 0.8
                  : size.width * 0.3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                child: ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ShowEventForm(
                        isMobile: isMobile,
                        isTablet: isTablet,
                        size: size,
                      ),
                    ));
                  },
                  tileColor: Colors.black12,
                  title: const Text("Event"),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              content: SizedBox(
                                  width: isMobile
                                      ? size.width * 0.9
                                      : size.width * 0.6,
                                  child: NewPost(
                                    isMobile: isMobile,
                                    isAdmin: true,
                                  )),
                            ));
                  },
                  tileColor: Colors.black12,
                  title: const Text("Post"),
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"))
        ],
      ),
    );
  }
}

class ShowEventForm extends StatefulWidget {
  const ShowEventForm(
      {Key? key,
      required this.isMobile,
      required this.isTablet,
      required this.size})
      : super(key: key);

  final bool isMobile;
  final bool isTablet;
  final Size size;

  @override
  State<ShowEventForm> createState() => _ShowEventFormState();
}

class _ShowEventFormState extends State<ShowEventForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final ScrollController _controller = ScrollController();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();

  DateTime dateTime = DateTime.now();

  bool isLoading = false;

  submit() async {
    if (!_key.currentState!.validate()) {
      return;
    }
    _key.currentState!.save();
    try {
      setState(() {
        isLoading = true;
      });
      await Provider.of<AdminViewModel>(context, listen: false).createEvent(
          _titleController.text,
          _detailController.text,
          _venueController.text,
          dateTime.toIso8601String());
      showDialog(
          context: context,
          builder: (context) =>
              CustomDialog(msg: "Event created successfully"));
      _titleController.clear();
      _detailController.clear();
      _venueController.clear();
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
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        alignment: Alignment.topCenter,
        width: double.infinity,
        child: Form(
          key: _key,
          child: SizedBox(
            width: widget.isMobile
                ? widget.size.width * 0.9
                : widget.isTablet
                    ? widget.size.width * 0.8
                    : widget.size.width * 0.3,
            child: SingleChildScrollView(
              controller: _controller,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: kDefaultPadding),
                  const Text(
                    "Create Event",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: kDefaultPadding),
                  TextFormField(
                    controller: _titleController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please enter event title';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Title",
                    ),
                  ),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                  TextFormField(
                    controller: _detailController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please enter event detail';
                      }
                      return null;
                    },
                    minLines: 3,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Details",
                    ),
                  ),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                  TextFormField(
                    controller: _venueController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please enter event venue';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Venue",
                    ),
                  ),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('EE, d/MM/yyyy')
                          .add_jm()
                          .format(dateTime)),
                      TextButton(
                          onPressed: () async {
                            var date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 30)),
                            );
                            if (date != null) {
                              var time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now());
                              if (time != null) {
                                setState(() {
                                  dateTime = DateTime(date.year, date.month,
                                      date.day, time.hour, time.minute);
                                });
                              }
                            }
                          },
                          child: const Text("Date time")),
                    ],
                  ),
                  const SizedBox(height: kDefaultPadding * 2),
                  ElevatedButton(
                    onPressed: () {
                      submit();
                    },
                    child: const Text("Create"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
