import 'dart:async';
import 'dart:convert';
// import 'dart:html' as html;

import 'package:ConnectUs/models/HttpExceptions.dart';
import 'package:ConnectUs/utils/constants.dart';
import 'package:ConnectUs/view_models/secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool _userLoggedIn = false;
  bool isDarkMode = false;

  bool get isLoading => _isLoading;
  bool get userLoggedIn => _userLoggedIn;

  String _token = '';
  DateTime _expiryDate = DateTime.now();
  String _userId = '';

  final SecureStroage secureStroage = SecureStroage();

  setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  bool get isAuth {
    return token != '';
  }

  String get token {
    if (_expiryDate != DateTime.now() &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != '') {
      return _token;
    }
    return '';
  }

  String get userId {
    return _userId;
  }

  Future<void> loginUser(String email, String password) async {
    Uri uri = Uri.parse(server + "login");

    var data = {"email": email, "password": password};

    var request = json.encode(data);

    try {
      var response = await http.post(
        uri,
        body: request,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      var bodyresponse = json.decode(response.body);

      if (response.statusCode >= 400) {
        throw HttpExceptions(bodyresponse['error']);
      }

      _userLoggedIn = true;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> signUpUser(
      String name, String email, String password, String profileImage) async {
    Uri uri = Uri.parse(server + "signup");

    var data = {
      "name": name,
      "email": email,
      "password": password,
      "profile_image": profileImage
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

      var bodyresponse = json.decode(response.body);

      if (response.statusCode >= 400) {
        throw HttpExceptions(bodyresponse['error']);
      }

      _userLoggedIn = true;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  void logout() {
    _userLoggedIn = false;
    setLoading(false);
  }

  void toggleDarkMode() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}
