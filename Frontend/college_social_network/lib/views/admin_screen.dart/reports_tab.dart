import 'package:ConnectUs/components/custom_dialog.dart';
import 'package:ConnectUs/responsive.dart';
import 'package:ConnectUs/view_models/admin_view_model.dart';
import 'package:ConnectUs/views/home_screen/post_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/HttpExceptions.dart';
import '../../models/adminPosts.dart';
import '../../utils/constants.dart';

class ReportsVerification extends StatefulWidget {
  const ReportsVerification({
    Key? key,
  }) : super(key: key);

  @override
  State<ReportsVerification> createState() => _ReportsVerificationState();
}

class _ReportsVerificationState extends State<ReportsVerification> {
  List<AdminPosts> reportedPosts = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    Provider.of<AdminViewModel>(context, listen: false)
        .getReports()
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    reportedPosts = Provider.of<AdminViewModel>(context).reports;
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : reportedPosts.length == 0
            ? const Center(
                child: Text("No report pending"),
              )
            : Container(
                child: ListView.separated(
                  itemBuilder: (context, index) =>
                      ReportsItem(post: reportedPosts[index]),
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: reportedPosts.length,
                ),
              );
  }
}

class ReportsItem extends StatelessWidget {
  const ReportsItem({Key? key, required this.post}) : super(key: key);

  final AdminPosts post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: InkWell(
        onTap: () {},
        child: Row(
          children: [
            if (post.images != null)
              Container(
                height: 60,
                width: 60,
                child: CachedNetworkImage(
                  imageUrl: post.images![0],
                  placeholder: (context, string) =>
                      const CircularProgressIndicator(),
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(width: kDefaultPadding),
            if (post.text != null)
              Expanded(
                child: Text(
                  post.text!.length > 100
                      ? "${post.text!.substring(0, 197)}..."
                      : post.text!,
                ),
              ),
            const SizedBox(width: kDefaultPadding),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  post.userName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: kDefaultPadding / 4),
                Text(
                  DateFormat('EE, d/MM/yyyy').add_jm().format(post.timeStamp),
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w300),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ReportDetail extends StatelessWidget {
  ReportDetail({Key? key, required this.post}) : super(key: key);

  final AdminPosts post;
  final buttonCarouselController = CarouselController();
  ScrollController controller = ScrollController();

  decision(String decision, BuildContext context) async {
    try {
      if (decision == "approve") {
        await Provider.of<AdminViewModel>(context, listen: false)
            .deletePost(post.id)
            .then((value) => showDialog(
                context: context,
                builder: (context) =>
                    const CustomDialog(msg: "Task Successful")));
      }
    } on HttpExceptions catch (err) {
      showDialog(
          context: context, builder: (context) => CustomDialog(msg: "Error"));
    } catch (err) {
      showDialog(
          context: context,
          builder: (context) => CustomDialog(msg: err.toString()));
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var isMobile = Responsive.isMobile(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: isMobile ? size.width * 0.9 : size.width * 0.5,
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PostImages(
                  buttonCarouselController: buttonCarouselController,
                  images: post.images!,
                  isMobile: isMobile,
                ),
                const SizedBox(height: kDefaultPadding),
                Text(
                  post.text!,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: kDefaultPadding),
                const Text("User and post Detail:"),
                Text(
                  post.userName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  DateFormat('d/MM/yy').add_jm().format(post.timeStamp),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: kDefaultPadding * 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        decision("approve", context);
                      },
                      icon: const Icon(
                        Icons.delete_forever_rounded,
                        size: 40,
                        color: Colors.red,
                      ),
                      label: const Text("Delete Post",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold)),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        decision("delete", context);
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 40,
                        color: Colors.blue,
                      ),
                      label: const Text("Ignore",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
