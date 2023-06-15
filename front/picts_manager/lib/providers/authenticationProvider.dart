import 'package:flutter/material.dart';
import 'package:picts_manager/model/core/User.dart';

class AuthenticationProvider extends ChangeNotifier {
  String _token = "";
  User _user = User
      .empty() /* User(username: "CHRICHRI", email: "chrichri@sushi.dev", userId: "1") */;

  String get token => _token;
  set token(String value) {
    print("refresh token");
    _token = value;
    notifyListeners();
  }

  User get user => _user;
  set user(User value) {
    _user = value;
    notifyListeners();
  }
}
