import 'package:flutter/foundation.dart';

class MessageViewModel with ChangeNotifier {
  int? _selectedUser;

  get selectedUser {
    return _selectedUser;
  }

  void selectUser(int index) {
    if (_selectedUser != index) {
      _selectedUser = index;
      notifyListeners();
    }
    if (index == -1) {
      _selectedUser = null;
      notifyListeners();
    }
  }
}
