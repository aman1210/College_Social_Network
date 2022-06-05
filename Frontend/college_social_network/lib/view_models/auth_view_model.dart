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
  String _userName = '';
  String _email = '';
  String _profileImage = '';

  final SecureStroage secureStroage = SecureStroage();

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

      _email = bodyresponse['body'];
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

      _email = bodyresponse['body'];
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

  void logout() {
    _expiryDate = DateTime.now();
    _userId = '';
    _userName = '';
    _token = "";
    _userId = "";
    _profileImage = '';
    _userLoggedIn = false;
    notifyListeners();
    secureStroage.deleteStorage();
  }

  void toggleDarkMode() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  Future<void> saveData() async {
    secureStroage.writeSecureStorage('token', _token);
    secureStroage.writeSecureStorage('userId', _userId);
    secureStroage.writeSecureStorage('userName', _userName);
    secureStroage.writeSecureStorage('profileImage', _profileImage);
    secureStroage.writeSecureStorage('email', _email);
    secureStroage.writeSecureStorage(
        'expiry', _expiryDate.add(const Duration(hours: 1)).toIso8601String());
  }

  Future<bool> tryAutoLogin() async {
    Map<String, String> data = await secureStroage.realStorage();
    _userId = data['userId'] ?? '';
    _userName = data['userName'] ?? '';
    _token = data['token'] ?? '';
    _email = data['email'] ?? '';
    _expiryDate =
        DateTime.parse(data['expiry'] ?? DateTime.now().toIso8601String());
    _profileImage = data['profileImage'] ?? '';

    if (_token != '' && _expiryDate.isAfter(DateTime.now())) {
      _userLoggedIn = true;
    } else {
      _userLoggedIn = false;
      logout();
    }

    notifyListeners();
    return true;
  }
}
