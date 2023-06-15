import 'package:flutter/material.dart';
import 'package:picts_manager/model/core/MyImage.dart';

class MyImageProvider extends ChangeNotifier {
  List<MyImage> _listImage = [];

  List<MyImage> get listImage => _listImage;
  set listImage(List<MyImage> value) {
    _listImage = value;
    notifyListeners();
  }

  set setListImage(List<MyImage> value) {
    _listImage = value;
  }
}
