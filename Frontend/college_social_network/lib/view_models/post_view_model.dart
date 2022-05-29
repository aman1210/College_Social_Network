import 'dart:convert';
import 'dart:html';
import 'dart:io';

import 'package:ConnectUs/models/postModel.dart';
import 'package:ConnectUs/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class PostViewModel with ChangeNotifier {
  List<Post> posts = [];

  Future<void> getAllPosts() async {
    Uri uri = Uri.parse(server + "posts");
    var response = await http.get(uri);
    var responseBody = json.decode(response.body);
    List<Post> temp = [];
    var resposts = responseBody['posts'] as List<dynamic>;
    resposts.forEach((element) {
      var post = Post.fromJson(element);
      print(post.likeCount);
      temp.add(post);
    });
    posts = temp;
    notifyListeners();
  }

  Future<void> addNewPost(String text, List<XFile> images) async {
    Uri uri = Uri.parse(server + "posts/");

    var request = http.MultipartRequest('POST', uri)
      ..fields['text'] = text
      ..fields['timeStamp'] = DateTime.now().toIso8601String()
      ..fields['userName'] = "Khushboo Arora";

    for (var i = 0; i < images.length; i++) {
      var e = images[i].readAsBytes();
      request.files.add(http.MultipartFile.fromBytes('images', await e));
    }

    print(request);

    var response = await request.send();
    print(response.reasonPhrase);
  }
}
