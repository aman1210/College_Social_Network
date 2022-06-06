import 'dart:convert';

import 'package:ConnectUs/models/HttpExceptions.dart';
import 'package:ConnectUs/models/friendList.dart';
import 'package:ConnectUs/models/user.dart';
import 'package:ConnectUs/utils/constants.dart';
import 'package:ConnectUs/view_models/secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserViewModel with ChangeNotifier {
  List<FriendListElement> friendList = [];
  List<FriendListElement> friendRequest = [];
  User? user;

  Future<void> getFriendList(String id, String token) async {
    Uri uri = Uri.parse(server + "user/myCommunity");

    try {
      var response =
          await http.get(uri, headers: {"Authorization": "Bearer $token"});
      var responseBody = json.decode(response.body);

      if (responseBody['friendList'] != null) {
        var fl = responseBody['friendList'] as List<dynamic>;
        List<FriendListElement> temp = [];
        print(fl);
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
    Uri uri = Uri.parse(server + "user/profile/$id");

    try {
      var response = await http.get(uri, headers: {
        "Authorization": "Bearer $token",
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
}
