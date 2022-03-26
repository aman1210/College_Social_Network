import 'package:college_social_network/utils/images.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(children: [
        Image.asset(Images.logo, height: 40),
        const SizedBox(width: 12),
        const Text(
          "ConnectUs",
          style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const Expanded(child: SizedBox())
      ]),
    );
  }
}
