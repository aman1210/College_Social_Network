import 'dart:convert';

import 'package:ConnectUs/models/HttpExceptions.dart';
import 'package:ConnectUs/models/adminPosts.dart';
import 'package:ConnectUs/utils/constants.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminViewModel extends ChangeNotifier {
  List<AdminUsers> users = [];
  List<AdminPosts> posts = [];
  List<AdminPosts> reports = [];

  Future<void> getUsers() async {
    Uri uri = Uri.parse(server + 'admin/users');

    try {
      var response = await http.get(uri);
      var responseBody = json.decode(response.body);
      var resusers = responseBody['users'] as List<dynamic>;
      if (response.statusCode >= 400) {
        throw HttpExceptions(responseBody['message']);
      }
      List<AdminUsers> temp = [];
      resusers.forEach((user) {
        temp.add(AdminUsers.fromJson(user));
      });
      users = temp;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> getPosts() async {
    Uri uri = Uri.parse(server + 'admin/posts');

    try {
      var response = await http.get(uri);
      var responseBody = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpExceptions(responseBody['message']);
      }
      var resposts = responseBody['posts'] as List<dynamic>;
      List<AdminPosts> temp = [];
      resposts.forEach((post) {
        temp.add(AdminPosts.fromJson(post));
      });
      posts = temp;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> getReports() async {
    Uri uri = Uri.parse(server + 'admin/reports');

    try {
      var response = await http.get(uri);
      var responseBody = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpExceptions(responseBody['message']);
      }
      List<AdminPosts> temp = [];
      if (responseBody['posts'] != null) {
        var resposts = responseBody['posts'] as List<dynamic>;
        resposts.forEach((post) {
          temp.add(AdminPosts.fromJson(post));
        });
      }
      reports = temp;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> createEvent(
      String title, String detail, String venue, String time) async {
    Uri uri = Uri.parse(server + "admin/event");

    var data = {"title": title, "detail": detail, "venue": venue, "time": time};

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

      // print(responseBody);
    } catch (err) {
      throw err;
    }
  }

  Future<void> verifyUser(String id) async {
    Uri uri = Uri.parse(server + "admin/users/$id");
    try {
      var response = await http.patch(uri);
      var responseBody = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpExceptions(responseBody['message']);
      }
      users.removeWhere((user) => user.id == id);
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> deleteUser(String id) async {
    Uri uri = Uri.parse(server + "admin/users/$id");
    try {
      var response = await http.delete(uri);
      var responseBody = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpExceptions(responseBody['message']);
      }
      users.removeWhere((user) => user.id == id);
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> verifyPost(String id) async {
    Uri uri = Uri.parse(server + "admin/posts/$id");
    try {
      var response = await http.patch(uri);
      var responseBody = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpExceptions(responseBody['message']);
      }
      // print(responseBody);
      posts.removeWhere((post) => post.id == id);
      notifyListeners();
    } catch (err) {
      print("hello $err");
      throw err;
    }
  }

  Future<void> deletePost(String id) async {
    Uri uri = Uri.parse(server + "admin/posts/$id");
    try {
      var response = await http.delete(uri);
      var responseBody = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpExceptions(responseBody['message']);
      }
      print(responseBody);
      posts.removeWhere((post) => post.id == id);
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> createPost(String text, String userName, String userId,
      List<CloudinaryResponse> images) async {
    Uri uri = Uri.parse(server + "admin/post");
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
}

// To parse this JSON data, do
//
//     final adminUsers = adminUsersFromJson(jsonString);

AdminUsers adminUsersFromJson(String str) =>
    AdminUsers.fromJson(json.decode(str));

String adminUsersToJson(AdminUsers data) => json.encode(data.toJson());

class AdminUsers {
  AdminUsers({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
  });

  String id;
  String name;
  String email;
  String? profileImage;

  factory AdminUsers.fromJson(Map<String, dynamic> json) => AdminUsers(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        profileImage: json["profile_image"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "profile_image": profileImage,
      };
}
