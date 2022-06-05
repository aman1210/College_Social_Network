import 'dart:convert';

import 'package:ConnectUs/models/HttpExceptions.dart';
import 'package:ConnectUs/models/adminPosts.dart';
import 'package:ConnectUs/utils/constants.dart';
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
