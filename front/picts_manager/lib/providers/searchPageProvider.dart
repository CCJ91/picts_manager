import 'package:flutter/material.dart';
import 'package:picts_manager/model/core/MyImage.dart';
import 'package:picts_manager/model/core/Tag.dart';

class SearchPageProvider extends ChangeNotifier {
  late Tag _currentTag;

  List<MyImage> _listImage = [];

  Tag get currentTag => _currentTag;
  set currentTag(Tag value) {
    _currentTag = value;
    notifyListeners();
  }

  set setCurrentTag(Tag value) {
    _currentTag = value;
  }

  List<MyImage> get listImage => _listImage;
  set listImage(List<MyImage> value) {
    _listImage = value;
    notifyListeners();
  }

  set setListImage(List<MyImage> value) {
    _listImage = value;
  }
}
