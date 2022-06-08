import 'dart:convert';
import 'dart:io';

import 'package:ConnectUs/models/HttpExceptions.dart';
import 'package:ConnectUs/models/eventModel.dart';
import 'package:ConnectUs/models/postModel.dart';
import 'package:ConnectUs/utils/constants.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class PostViewModel with ChangeNotifier {
  List<Post> posts = [];
  List<Event> events = [];

  Future<void> getAllPosts() async {
    Uri uri = Uri.parse(server + "posts");
    var response = await http.get(uri);
    var responseBody = json.decode(response.body);
    List<Post> temp = [];
    var resposts = responseBody['posts'] as List<dynamic>;
    resposts.forEach((element) {
      var post = Post.fromJson(element);

      temp.add(post);
    });
    posts = temp;
    notifyListeners();
  }

  Future<void> getAllEvents() async {
    Uri uri = Uri.parse(server + "other/events");
    try {
      var response = await http.get(uri);
      var responseBody = json.decode(response.body);
      List<Event> temp = [];
      if (responseBody['events'] != null) {
        var resposts = responseBody['events'] as List<dynamic>;
        resposts.forEach((element) {
          var event = Event.fromJson(element);
          temp.add(event);
        });
        events = temp;
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addNewPost(String text, String userName, String userId,
      List<CloudinaryResponse> images) async {
    Uri uri = Uri.parse(server + "posts/");
    List<String> postImages = images.map((image) => image.secureUrl).toList();

    var data = {
      "userId": userId,
      "text": text,
      "timeStamp": DateTime.now().toIso8601String(),
      "userName": userName,
      "images": postImages,
    };

    var request = json.encode(data);
    try {
      var response = await http.post(
        uri,
        body: request,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var responseBody = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpExceptions(responseBody['message']);
      }
    } catch (err) {
      throw err;
    }
  }

  Future<void> reportPost(String id) async {
    Uri uri = Uri.parse(server + "posts/$id/report");
    try {
      var response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var responseBody = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpExceptions("Something went wrong!");
      }
    } catch (err) {
      throw err;
    }
  }

  Future<void> likePost(String id, String userId) async {
    Uri uri = Uri.parse(server + "posts/$id");
    var data = {
      "userId": userId,
      "timeStamp": DateTime.now().toIso8601String(),
    };

    var request = json.encode(data);
    try {
      var response = await http.post(
        uri,
        body: request,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var responseBody = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpExceptions("Something went wrong!");
      }
      var post = posts.firstWhere((element) => element.id == id);
      if (post != null) post.likeCount = post.likeCount! + 1;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> commentOnPost(
      String id, String userName, String text, String userId) async {
    Uri uri = Uri.parse(server + "posts/$id/comment");

    var data = {
      "userName": userName,
      "text": text,
      "time": DateTime.now().toIso8601String(),
      "userId": userId,
    };

    var request = json.encode(data);

    try {
      var respose = await http.post(
        uri,
        body: request,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      var responseBody = json.decode(respose.body);
      if (respose.statusCode >= 400) {
        throw HttpExceptions(responseBody['message']);
      }

      var post = posts.firstWhere((p) => p.id == id);
      post.comments!.add({
        "userName": userName,
        "timeStamp": DateTime.now().toIso8601String(),
        "text": text
      });

      notifyListeners();
    } catch (err) {
      throw err.toString();
    }
  }
}
