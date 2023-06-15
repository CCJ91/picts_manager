import 'package:flutter/material.dart';
import 'package:picts_manager/model/core/Tag.dart';

class TagProvider extends ChangeNotifier {
  List<Tag> _listTag = [];

  late Tag _currentTag;

  List<Tag> get listTag => _listTag;

  set listTag(List<Tag> value) {
    _listTag = value;
    notifyListeners();
  }

  set setListTag(List<Tag> value) {
    _listTag = value;
  }

  Tag get currentTag => _currentTag;
  set currentTag(Tag value) {
    _currentTag = value;
    notifyListeners();
  }

  set setCurrentTag(Tag value) {
    _currentTag = value;
  }
}
