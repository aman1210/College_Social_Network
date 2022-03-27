import 'dart:async';

import 'package:flutter/foundation.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool _userLoggedIn = true;

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
}
