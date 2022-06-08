import 'dart:io';

import 'package:ConnectUs/components/custom_dialog.dart';
import 'package:ConnectUs/models/HttpExceptions.dart';
import 'package:ConnectUs/view_models/admin_view_model.dart';
import 'package:ConnectUs/view_models/auth_view_model.dart';
import 'package:ConnectUs/view_models/post_view_model.dart';
import 'package:ConnectUs/views/home_screen/post_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../utils/constants.dart';

class NewPost extends StatefulWidget {
  const NewPost({Key? key, required this.isMobile, this.isAdmin = false})
      : super(key: key);

  final bool isMobile;
  final bool isAdmin;

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  TextEditingController _editingController = TextEditingController();
  final _key = GlobalKey<FormState>();
  List<File> imagesPicked = [];
  CarouselController buttonCarouselController = CarouselController();

  bool isLoading = false;
  final cloudinary =
      CloudinaryPublic('knitconnectus', 'gjj0b8fp', cache: false);

  submit() async {
    if (_key.currentState!.validate()) {
      return;
    }
    _key.currentState!.save();
    setState(() {
      isLoading = true;
    });
    try {
      List<CloudinaryResponse> response =
          await cloudinary.multiUpload(imagesPicked.map((image) async {
        return CloudinaryFile.fromFile(image.path,
            resourceType: CloudinaryResourceType.Image);
      }).toList());
      var provider = Provider.of<AuthViewModel>(context, listen: false);
      var userName = provider.userName;
      var userId = provider.userId;
      if (widget.isAdmin) {
        await Provider.of<AdminViewModel>(context, listen: false)
            .createPost(_editingController.text, userName, userId, response);
        Navigator.pop(context);
      } else {
        await Provider.of<PostViewModel>(context, listen: false)
            .addNewPost(_editingController.text, userName, userId, response);
      }
      showDialog(
          context: context,
          builder: (context) => CustomDialog(
              msg: widget.isAdmin
                  ? "Post created successfully"
                  : "Post created successfully! It will appear in feed after verification!"));
    } on HttpExceptions catch (err) {
      showDialog(
          context: context,
          builder: (context) => CustomDialog(msg: err.toString()));
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => CustomDialog(
              msg: "Something went wrong! Please try again later"));
    }

    _editingController.clear();

    setState(() {
      imagesPicked = [];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal:
                widget.isMobile ? kDefaultPadding / 2 : kDefaultPadding),
        padding: EdgeInsets.symmetric(
            vertical: kDefaultPadding / 2,
            horizontal:
                widget.isMobile ? kDefaultPadding / 2 : kDefaultPadding),
        decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).scaffoldBackgroundColor
                : Colors.white,
            borderRadius: BorderRadius.circular(kDefaultPadding),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.03)
                    : Colors.black.withOpacity(0.07),
                offset: const Offset(0, 5),
              )
            ]),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                    Provider.of<AuthViewModel>(context, listen: false)
                        .profileImage),
              ),
              const SizedBox(width: kDefaultPadding / 2),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                    left: kDefaultPadding / 2,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.blueGrey.withOpacity(0.2)
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(kDefaultPadding / 2),
                  ),
                  child: TextFormField(
                    controller: _editingController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Please enter something to post!";
                      }
                      return '';
                    },
                    decoration: const InputDecoration(
                      hintText: "What's happening?",
                      hintStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: kDefaultPadding / 2),
          if (imagesPicked.isNotEmpty)
            PostImages(
              buttonCarouselController: buttonCarouselController,
              images: imagesPicked.map((e) => e.path).toList(),
              isMobile: widget.isMobile,
            ),
          if (imagesPicked.isNotEmpty)
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    imagesPicked.clear();
                  });
                },
                child: Text("Remove image")),
          Row(
            children: [
              TextButton.icon(
                onPressed: () async {
                  ImagePicker picker = ImagePicker();
                  var x = await picker.pickMultiImage();
                  if (x != null) {
                    x.forEach((e) {
                      var y = File(e.path);
                      imagesPicked.add(y);
                    });
                    setState(() {});
                  } else {
                    print("no image selected");
                  }
                },
                icon: const Icon(Icons.photo_outlined),
                label: const Text("Photo"),
              ),
              const Expanded(child: SizedBox()),
              if (isLoading) CircularProgressIndicator(),
              if (!isLoading)
                ElevatedButton(
                    onPressed: () {
                      submit();
                    },
                    child: const Text("Post"))
            ],
          ),
        ]),
      ),
    );
  }
}
