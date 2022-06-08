import 'dart:convert';

import 'package:ConnectUs/models/HttpExceptions.dart';
import 'package:ConnectUs/models/friendList.dart';
import 'package:ConnectUs/models/notificationModel.dart';
import 'package:ConnectUs/models/user.dart';
import 'package:ConnectUs/utils/constants.dart';
import 'package:ConnectUs/view_models/secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserViewModel with ChangeNotifier {
  List<FriendListElement> friendList = [];
  List<FriendListElement> friendRequest = [];
  List<FriendListElement> searchResult = [];
  List<Notification> notifications = [];
  User? user;
  String? _token;
  String? _id;

  set token(String token) {
    _token = token;
    notifyListeners();
  }

  set id(String id) {
    _id = id;
    notifyListeners();
  }

  Future<void> getFriendList(String id, String token) async {
    Uri uri = Uri.parse(server + "user/myCommunity");

    try {
      var response =
          await http.get(uri, headers: {"Authorization": "Bearer $_token"});
      var responseBody = json.decode(response.body);

      if (responseBody['friendList'] != null) {
        var fl = responseBody['friendList'] as List<dynamic>;
        List<FriendListElement> temp = [];
        fl.forEach((f) {
          temp.add(FriendListElement.fromJson(f));
        });
        friendList = temp;
        notifyListeners();
      }
    } catch (err) {
      throw err;
    }
  }

  Future<void> getProfile(String id, String token) async {
    Uri uri = Uri.parse(server + "user/profile/$_id");

    try {
      var response = await http.get(uri, headers: {
        "Authorization": "Bearer $_token",
        'Content-Type': 'application/json; charset=UTF-8',
      });
      var responseBody = json.decode(response.body);

      if (response.statusCode >= 400) {
        throw HttpExceptions(responseBody['error']);
      }
      user = User.fromJson(responseBody['userProfile']);
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> editProfile(String id, String token, User user) async {
    Uri uri = Uri.parse(server + "user/editProfile/$id");
    var data = {
      "intro": user.intro,
      "about": user.about,
      "dob": user.dob,
      "location": user.location,
      "social_links": user.socialLinks,
      "profile_image": user.profileImage,
    };

    var request = json.encode(data);

    try {
      var response = await http.patch(uri, body: request, headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer $token"
      });

      var responseBody = json.decode(response.body);

      if (response.statusCode >= 400) {
        throw HttpExceptions(responseBody['message'] ?? responseBody['error']);
      }
      return;
    } catch (err) {
      throw err;
    }
  }

  Future<void> getNotifications(String id) async {
    Uri uri = Uri.parse(server + 'other/notifications/$id');

    try {
      var response = await http.get(uri);
      var responseBody = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpExceptions(responseBody['message']);
      }

      var n = responseBody['notification'] as List<dynamic>;

      if (n != null && n.length != 0) {
        List<Notification> temp = [];

        n.forEach((no) {
          temp.add(Notification.fromJson(no));
        });
        notifications = temp;
        notifyListeners();
      }
    } catch (err) {
      throw err;
    }
  }

  Future<void> getFriendRequest(String id, String token) async {
    Uri uri = Uri.parse(server + "user/friendRequests/");

    try {
      var response =
          await http.get(uri, headers: {"Authorization": "Bearer $token"});
      var responseBody = json.decode(response.body);

      print(responseBody);

      if (responseBody['friendRequest'] != null) {
        var fl = responseBody['friendRequest'] as List<dynamic>;
        List<FriendListElement> temp = [];
        fl.forEach((f) {
          temp.add(FriendListElement.fromJson(f));
        });
        friendRequest = temp;
        notifyListeners();
      }
    } catch (err) {
      throw err;
    }
  }

  Future<void> acceptFriendRequest(String friendId, String token) async {
    Uri uri = Uri.parse(server + "user/acceptRequest/$friendId");

    try {
      var response =
          await http.patch(uri, headers: {"Authorization": "Bearer $token"});

      var responseBody = json.decode(response.body);

      if (response.statusCode >= 400) {
        throw HttpExceptions(responseBody['error']);
      }

      var f = friendRequest.firstWhere((element) => element.id == friendId);
      friendList.add(f);
      friendRequest.removeWhere((element) => element.id == friendId);
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> searchFriendOnDB(String parameter, String value) async {
    Uri uri = Uri.parse(server + "other/searchResults?$parameter=$value");

    try {
      var response = await http.get(uri);
      var responseBody = json.decode(response.body);

      if (response.statusCode >= 400) {
        throw HttpExceptions(responseBody['error']);
      }
      List<FriendListElement> temp = [];
      var users = responseBody as List<dynamic>;
      if (users.length == 0) {
        throw HttpExceptions("No users found!");
      }
      users.forEach((user) {
        temp.add(FriendListElement.fromJson(user));
      });

      searchResult = temp;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> sendFriendRequest(String id, String token) async {
    Uri uri = Uri.parse(server + "user/sendRequest/$id");

    try {
      var response = await http.patch(uri, headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer $token"
      });

      var responseBody = json.decode(response.body);

      if (response.statusCode >= 400) {
        throw HttpExceptions(responseBody['error']);
      }
    } catch (err) {
      throw err;
    }
  }
}
