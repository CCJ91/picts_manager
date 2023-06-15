import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _index = 0;

  int get index => _index;

  set index(int value) {
    _index = value;
    notifyListeners();
  }
}
