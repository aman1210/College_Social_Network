import 'package:ConnectUs/view_models/admin_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
