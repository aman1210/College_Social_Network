import 'dart:async';
// import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool _userLoggedIn = true;
  bool isDarkMode = false;

  bool get isLoading => _isLoading;
  bool get userLoggedIn => _userLoggedIn;

  setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> loginUser(dynamic args) async {
    setLoading(true);
    Timer(const Duration(seconds: 3), () {
      _userLoggedIn = true;
      setLoading(false);
    });
  }

  void logout() {
    _userLoggedIn = false;
    setLoading(false);
  }

  void toggleDarkMode() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  // Future<void> loginWithGoogle() async {
  //   Uri uri =
  //       Uri.parse("https://connectus15-backend.herokuapp.com/auth/google");
  //   var x = html.window
  //       .open("https://connectus15-backend.herokuapp.com/auth/google", "_self");

  //   Timer(Duration(seconds: 5), () => x.close());
  //   // print(x.);
  //   // var response = await http.get(uri);
  //   // print(response);
  // }
}
