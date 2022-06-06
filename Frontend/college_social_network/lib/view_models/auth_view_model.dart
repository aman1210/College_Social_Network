import 'dart:async';
import 'dart:convert';
// import 'dart:html' as html;

import 'package:ConnectUs/models/HttpExceptions.dart';
import 'package:ConnectUs/utils/constants.dart';
import 'package:ConnectUs/view_models/secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool _userLoggedIn = false;
  bool _isAdmin = false;
  bool isDarkMode = false;

  bool get isLoading => _isLoading;
  bool get userLoggedIn => _userLoggedIn;
  bool get isAdmin => _isAdmin;

  String _token = '';
  DateTime _expiryDate = DateTime.now();
  String _userId = '';
  String _userName = '';
  String _email = '';
  String _profileImage = '';

  AuthViewModel() {
    tryAutoLogin();
  }

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

  String get userName {
    return _userName;
  }

  String get profileImage {
    return _profileImage;
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

      _email = bodyresponse['email'];
      _userId = bodyresponse['userId'];
      _userName = bodyresponse['userName'];
      _profileImage = bodyresponse['profile_image'];
      _token = bodyresponse['token'];

      if (_email == "aman.18605@knit.ac.in") {
        _isAdmin = true;
      }

      saveData();
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

      _email = bodyresponse['email'];
      _userId = bodyresponse['userId'];
      _userName = bodyresponse['userName'];
      _profileImage = bodyresponse['profile_image'];
      _token = bodyresponse['token'];

      saveData();

      _userLoggedIn = true;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    _expiryDate = DateTime.now();
    _userId = '';
    _userName = '';
    _token = "";
    _userId = "";
    _profileImage = '';
    _userLoggedIn = false;

    notifyListeners();
    await prefs.clear();
  }

  void toggleDarkMode() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString('token', _token);
    prefs.setString('userId', _userId);
    prefs.setString('userName', _userName);
    prefs.setString('profileImage', _profileImage);
    prefs.setString('email', _email);
    prefs.setString(
        'expiry', _expiryDate.add(const Duration(hours: 1)).toIso8601String());
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('token')) {
      _userId = prefs.getString('userId') ?? '';
      _userName = prefs.getString('userName') ?? '';
      _token = prefs.getString('token') ?? '';
      _email = prefs.getString('email') ?? '';
      _expiryDate = DateTime.parse(
          prefs.getString('expiry') ?? DateTime.now().toIso8601String());
      _profileImage = prefs.getString('profileImage') ?? '';

      if (_token != '' && _expiryDate.isAfter(DateTime.now())) {
        _userLoggedIn = true;
        if (_email == "aman.18605@knit.ac.in") {
          _isAdmin = true;
        }
      } else {
        _userLoggedIn = false;
        logout();
      }

      notifyListeners();
      return true;
    }
    return false;
  }
}
